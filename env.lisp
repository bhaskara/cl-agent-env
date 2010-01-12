;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic operations on environments
;; An environment is a stateful blackbox where you do actions
;; and receive observations and rewards.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :agent-env)

(defgeneric act (env action)
  (:documentation "Perform the given action in ENV.  Return 1) observation 2) reward."))

(defgeneric reset (env)
  (:documentation "Reset ENV's state according to some initial distribution"))

(defgeneric reset-to-state (env state)
  (:documentation "Reset ENV's state to STATE, and return the corresponding initial observation."))

(defgeneric get-state (env)
  (:documentation "Return current state of ENV."))

(defgeneric set-state (s e)
  (:documentation "Cause the environment to be in the given state (and return it)."))

(defgeneric at-terminal-state (env)
  (:documentation "Is the environment at a terminal state?"))

(defgeneric legal-action-list (env)
  (:documentation "Return list of legal actions at state"))
