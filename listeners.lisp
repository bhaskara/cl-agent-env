(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful listeners for execute-agent-in-env
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun stdout-listener (env)
  #'(lambda (trans)
      (let ((str t))
	(terpri str)
	(let ((actions (handler-case (legal-action-list env) (error (c) (declare (ignore c)) "unavailable"))))
	  (with-readers ((o transition-o) (r transition-r) (s transition-s)) trans
	    (pprint-logical-block (str nil)
	      (format str "Observation: ~a~:@_Reward: ~a~:@_~:[State: ~a~:@_~;~*~]Actions: ~a~:@_"
		      o r (eql s :unspecified) s actions)))))))

