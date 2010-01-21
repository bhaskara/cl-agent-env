(in-package :agent-env)

(defstruct (transition (:type list) (:constructor create-transition))
    action observation reward state)

(defun make-transition (a o r env include-state)
  (create-transition :action a :observation o :reward r :state (if include-state (get-state env) :unspecified)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generation of trajectories of an agent in environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reset-env (env reset)
  (cond
    ((eql reset :default) (reset env))
    ((eql reset :current) (reset-to-state env (get-state env)))
    (t (reset-to-state env reset))))

(defun env-agent-trajectory (env agent &key (reset :default) (include-state nil) max-num-steps termination-condition)
  "Return iterator over transitions resulting from running agent in environment.  RESET is either :default (to reset) or :current (reset to current state).  INCLUDE-STATE governs whether the full state is included in the transition (if not, it's set to :unspecified).  If MAX-NUM-STEPS is provided, the episode is terminated after that many steps at most.  If TERMINATION-CONDITION is provided, stop when you see a transition that satisfies it."
  (let ((first-time t)
	(done nil))
    (restrict-trajectory
     max-num-steps termination-condition
     #'(lambda ()
	(unless done
	  (if first-time

	      ;; Reset and return initial dummy transition
	      (let ((obs (reset-env env reset)))
		(observe-initial agent obs)
		(setq first-time nil)
		(values t (make-transition 'reset obs 0.0 env include-state)))

	      ;; Else, do a normal transition
	      (handler-case
		  (let ((action (select-action agent)))
		    (mvbind (obs reward) (act env action)
		      (observe agent obs action reward)
		      (setq done (at-terminal-state env))
		      (values t (make-transition action obs reward env include-state))))

		(agent-finished (c)
		  (declare (ignore c))
		  (setq done t)
		  nil))))))))

(defun execute-agent-in-env (agent env listeners &key (reset :default) (include-state nil) (max-num-steps nil))
  "Execute agent in ENV, and call each listener after each transition.  RESET and INCLUDE-STATE are as in env-agent-trajectory."
  (declare (list listeners))
  (do-iterator (trans (env-agent-trajectory env agent :reset reset :include-state include-state
					    :max-num-steps max-num-steps))
    (dolist (l listeners)
      (funcall l trans))))


(defun restrict-trajectory (n term fn)
  (orf term (constantly nil))
  (funcall
   (if n (partial #'take n) #'identity)
   (take-until term fn :include-last t)))
    

