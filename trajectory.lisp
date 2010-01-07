(in-package :agent-env)

(defstruct (transition (:type list) (:constructor create-transition))
    a o r s)

(defun make-transition (a o r env include-state)
  (create-transition :a a :o o :r r :s (if include-state (get-state env) :unspecified)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generation of trajectories of an agent in environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-condition agent-finished () ())

(defun reset-env (env reset)
  (cond
    ((eql reset :default) (reset env))
    ((eql reset :current) (reset-to-state env (get-state env)))
    (t (error "Unrecognized value ~a of reset argument" reset))))

(defun env-agent-trajectory (env agent &key (reset :default) (include-state nil))
  "Return iterator over transitions resulting from running agent in environment.  RESET is either :default (to reset) or :current (reset to current state).  INCLUDE-STATE governs whether the full state is included in the transition (if not, it's set to :unspecified)."
  (declare (function agent))
  (let ((first-time t)
	(done nil)
	last-obs last-reward)
    #'(lambda ()
	(unless done
	  (if first-time

	      ;; Reset and return initial dummy transition
	      (progn
		(setq last-obs (reset-env env reset)
		      last-reward 0.0
		      first-time nil
		      done (at-terminal-state env))
		(values t (make-transition 'reset last-obs last-reward env include-state)))

	      ;; Else, do a normal transition
	      (handler-case
		  (let ((action (funcall agent last-obs last-reward)))
		    (mvsetq (last-obs last-reward) (act env action))
		    (setq done (at-terminal-state env))
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

