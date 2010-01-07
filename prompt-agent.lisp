(in-package :agent-env)

(defun make-prompt-agent ()
  "Agent that reads action from standard input"
  #'(lambda (o r)
      (declare (ignore o r))
      (format t "~&Action? ")
      (let ((a (read)))
	(if (and (symbolp a) (equal (string-upcase (symbol-name a)) "Q"))
	    (progn 
	      (format t "~&Quitting")
	      (error 'agent-finished))
	    a))))
	  

