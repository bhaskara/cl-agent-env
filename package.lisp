(defpackage :agent-env
  (:use :cl :cl-utils) 
  (:export :act :reset :reset-to-state :get-state :set-state :at-terminal-state :legal-action-list
	   :modeled-env :model :sample-transition :sample-initial :is-terminal-state :sample-initial-observation
	   :is-legal-action :legal-action-list-at-state

	   :env-agent-trajectory :execute-agent-in-env :transition :transition-state :transition-reward :transition-observation :transition-action
	   :make-prompt-agent
	   :stdout-listener :reward-listener))