(in-package :agent-env)

(defun default-prompter (env show-state)
  #'(lambda (str o r)
      (terpri str)
      (let ((s (get-state env))
	    (actions (legal-action-list env)))
	(pprint-logical-block (str nil)
	  (format str "Observation: ~a~:@_Reward: ~a~:@_~:[~*~;State: ~a~:@_~]Actions: ~a~:@_Next action? " 
		  o r show-state s actions)))))

(defun make-prompt-agent (env &key (show-state t) (prompter nil))
  "Agent that prints observation and reward, then reads state from standard input."
  (setq prompter (or prompter (default-prompter env show-state)))
  #'(lambda (o r)
      (let ((str t))
	(terpri str)
	(pprint-logical-block (str nil)
	  (funcall prompter str o r)
	  (format str "~:@_Action? ")))
      (read)))
	  

(defun io-interface (env &key (reset t) (prompter nil))
  (collect (env-agent-trajectory env (make-prompt-agent env :prompter prompter) :reset reset)))