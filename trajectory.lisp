(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generation of trajectories of an agent in environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun trajectory-initializer (env reset)
  #'(lambda ()
      (if reset
	  (values 'reset (reset env) 0.0 (get-state env))
	  (values 'reset 'unknown-observation 'unknown-reward (get-state env)))))

(defun trajectory-stepper (env agent)
  #'(lambda (last-action obs reward last-state)
      (declare (ignore last-action last-state))
      (let ((action (funcall agent obs reward)))
	(multiple-value-bind (obs reward) (act env action)
	  (values action obs reward (get-state env))))))

(defun trajectory-termination-checker (env)
  #'(lambda (action obs reward state)
      (declare (ignore action obs reward state))
      (at-terminal-state env)))

(defun env-agent-trajectory (env agent &key (reset t))
  "Return series of transitions, including state, from running agent in environment."
  (scan-fn '(values t t float t) 
	   (trajectory-initializer env reset) (trajectory-stepper env agent)
	   (trajectory-termination-checker env)))

(defun env-agent-observable-trajectory (env agent &key (reset t))
  "Return series of actions, observations, and rewards (but not full states) resulting from running agent in environment"
  (map-fn '(values t t float)
	  #'(lambda (action obs reward state) (declare (ignore state)) (values action obs reward))
	  (env-agent-trajectory env agent :reset reset)))


