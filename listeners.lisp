(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful listeners for execute-agent-in-env
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun stdout-listener (env &key obs-printer)
  "Listener that just prints the transition"
  (orf obs-printer #'pprint)
  #'(lambda (trans)
      (let ((str t))
	(terpri str)
	(let ((actions (handler-case (legal-action-list env) (error (c) (declare (ignore c)) "unavailable"))))
	  (with-struct (transition- observation reward state action) trans
	    (pprint-logical-block (str nil)
	      (format str "Action: ~a~:@_Observation: " action)
	      (funcall obs-printer observation str)
	      (format str "~:@_Reward: ~a~:@_~:[State: ~a~:@_~;~*~]Actions: ~a~:@_"
		      reward (eql state :unspecified) state actions)))))))


(defun reward-listener ()
  "Listener that keeps track of rewards across episodes of runs in an ENV.  Returns 1) Vector of episode total-rewards 2) The listener.  Run one or more episodes in the environment using the listener, then look at the alist."
  (let ((stats (make-adjustable-vector)))
    (flet ((listener (trans)
	     (if (eql 'reset (transition-action trans))
		 (vector-push-extend 0.0 stats)
		 (let ((l (length stats)))
		   (incf (aref stats (1- l)) (transition-reward trans))))))
      (values stats #'listener))))

  
(defun agent-listener (a &key profile)
  "Listener that prints out the actions recommended by a particular agent"
  #'(lambda (trans)
      (with-struct (transition- observation action reward) trans
	(handler-case 
	    (mvbind (a2 v) (if profile (time (funcall a observation action reward)) (funcall a observation action reward))
	      (format t "~&Agent returned ~a with extra info ~a" a2 v))
	  (agent-finished (c)
	    (declare (ignore c))
	    (format t "~&Agent signalled agent-finished"))))))


(defun progress-printer (n)
  "Listener that prints a . every N steps"
  (let ((i 0))
    #'(lambda (trans)
	(declare (ignore trans))
	(when (= (incf i) n)
	  (setq i 0)
	  (format t ".")))))