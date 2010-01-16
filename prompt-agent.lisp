(in-package :agent-env)

(defun make-prompt-agent ()
  "Agent that reads action from standard input"
  #'(lambda (o a r)
      (declare (ignore o r a))
      (format t "~&Action? ")
      (let ((a (read)))
	(if (and (symbolp a) (equal (string-upcase (symbol-name a)) "Q"))
	    (progn 
	      (format t "~&Quitting")
	      (error 'agent-finished))
	    a))))
	  


(defun io-interface (e &key (reset :default) (include-state nil) obs-printer)
  (execute-agent-in-env 
   (make-prompt-agent) e
   (list (stdout-listener e :obs-printer obs-printer))
   :reset reset :include-state include-state))
  