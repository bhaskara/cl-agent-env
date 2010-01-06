(defpackage :agent-env
  (:use :cl :series) 
  (:export :act :reset :get-state :set-state :at-terminal-state :legal-action-list
	   :modeled-env :model :sample-transition :sample-initial :is-terminal-state 
	   :is-legal-action :legal-action-list-at-state
	   :unknown-observation :unknown-reward
	   :action-list-unavailable
	   :env-agent-trajectory :env-agent-observable-trajectory
	   :make-prompt-agent :io-interface))