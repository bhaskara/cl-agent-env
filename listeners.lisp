(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful listeners for execute-agent-in-env
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun stdout-listener (env)
  "Listener that just prints the transition"
  #'(lambda (trans)
      (let ((str t))
	(terpri str)
	(let ((actions (handler-case (legal-action-list env) (error (c) (declare (ignore c)) "unavailable"))))
	  (with-struct (transition- observation reward state) trans
	    (pprint-logical-block (str nil)
	      (format str "Observation: ~a~:@_Reward: ~a~:@_~:[State: ~a~:@_~;~*~]Actions: ~a~:@_"
		      observation reward (eql state :unspecified) state actions)))))))


(defun reward-listener ()
  "Listener that keeps track of rewards across episodes of runs in an ENV.  Returns 1) Vector of episode total-rewards 2) The listener.  Run one or more episodes in the environment using the listener, then look at the alist."
  (let ((stats (make-adjustable-vector)))
    (flet ((listener (trans)
	     (if (eql 'reset (transition-action trans))
		 (vector-push-extend 0.0 stats)
		 (let ((l (length stats)))
		   (incf (aref stats (1- l)) (transition-reward trans))))))
      (values stats #'listener))))

  
  
