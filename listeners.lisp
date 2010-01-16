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
	  (with-struct (transition- observation reward state) trans
	    (pprint-logical-block (str nil)
	      (format str "Observation: ")
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

  
(defun agent-listener (a)
  "Listener that prints out the actions recommended by a particular agent"
  #'(lambda (trans)
      (with-struct (transition- observation action reward) trans
	(mvbind (a2 v) (funcall a observation action reward)
	  (format t "~&Agent returned ~a with extra info ~a" a2 v)))))
