(defpackage :agent-env
  (:use :cl :cl-utils) 
  (:export :act :reset :reset-to-state :get-state :set-state :at-terminal-state :legal-action-list
	   :modeled-env :model :sample-transition :sample-initial :is-terminal-state :sample-initial-observation
	   :is-legal-action :legal-action-list-at-state

	   :observe :observe-initial :select-action :reset-local-state :agent-finished
	   :prompt-agent :io-interface

	   :env-agent-trajectory :execute-agent-in-env :transition :transition-state :transition-reward :transition-observation :transition-action 

	   :stdout-listener :reward-listener :agent-listener))