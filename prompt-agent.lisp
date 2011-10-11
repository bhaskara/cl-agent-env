(in-package :agent-env)

(defmethod observe ((agent (eql 'prompt-agent)) o a r)
  (format t "~&Receiving observation ~a, ~a, ~a" o a r)
  )

(defmethod select-action ((agent (eql 'prompt-agent)))
  (format t "~&Action? ")
  (let ((a (read)))
    (if (and (symbolp a) (equal (string-upcase (symbol-name a)) "Q"))
	(progn 
	  (format t "~&Quitting")
	  (error 'agent-finished))
	a)))

(defmethod reset-local-state ((agent (eql 'prompt-agent))))

(defun io-interface (e &key (reset :default) (include-state nil) obs-printer listeners)
  (unless (listp listeners) (setq listeners (list listeners)))
  (execute-agent-in-env 
   'prompt-agent e
   (cons (stdout-listener e :obs-printer obs-printer) listeners)
   :reset reset :include-state include-state))
  