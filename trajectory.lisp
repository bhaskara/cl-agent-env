(in-package :agent-env)

(defstruct (transition (:type list) (:constructor create-transition))
    action observation reward state)

(defun make-transition (a o r env include-state)
  (create-transition :action a :observation o :reward r :state (if include-state (get-state env) :unspecified)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generation of trajectories of an agent in environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-condition agent-finished () ())

(defun reset-env (env reset)
  (cond
    ((eql reset :default) (reset env))
    ((eql reset :current) (reset-to-state env (get-state env)))
    (t (reset-to-state env reset))))

(defun env-agent-trajectory (env agent &key (reset :default) (include-state nil) max-num-steps)
  "Return iterator over transitions resulting from running agent in environment.  RESET is either :default (to reset) or :current (reset to current state).  INCLUDE-STATE governs whether the full state is included in the transition (if not, it's set to :unspecified).  If MAX-NUM-STEPS is provided, the episode is terminated after that many steps at most."
  (declare (function agent))
  (when max-num-steps (setq agent (stop-after agent max-num-steps)))
  (let ((first-time t)
	(done nil)
	last-obs last-reward last-action)
    #'(lambda ()
	(unless done
	  (if first-time

	      ;; Reset and return initial dummy transition
	      (progn
		(setq last-obs (reset-env env reset)
		      last-reward 0.0
		      last-action 'reset
		      first-time nil
		      done (at-terminal-state env))
		(values t (make-transition last-action last-obs last-reward env include-state)))

	      ;; Else, do a normal transition
	      (handler-case
		  (let ((action (funcall agent last-obs last-action last-reward)))
		    (mvsetq (last-obs last-reward) (act env action))
		    (setq done (at-terminal-state env)
			  last-action action)
		    (values t (make-transition action last-obs last-reward env include-state)))
		(agent-finished (c)
		  (declare (ignore c))
		  (setq done t)
		  nil)))))))

(defun execute-agent-in-env (agent env listeners &key (reset :default) (include-state nil))
  "Execute agent in ENV, and call each listener after each transition.  RESET and INCLUDE-STATE are as in env-agent-trajectory."
  (declare (function agent) (list listeners))
  (do-iterator (trans (env-agent-trajectory env agent :reset reset :include-state include-state))
    (dolist (l listeners)
      (funcall l trans))))

(defun stop-after (agent n)
  "Return a new agent that's like agent except it throws an agent-finished condition after n steps."
  (let ((i 0))
    #'(lambda (&rest args)
	(if (> (incf i) n)
	    (error 'agent-finished)
	    (apply agent args)))))