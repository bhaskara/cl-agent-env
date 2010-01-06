(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simplest kind of environment
;; 1) State is fully contained in the current process
;; 2) There is a (purely functional) environment model
;; that we can sample from
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass modeled-env ()
  ((state :reader get-state :writer set-state)
   (model :reader model :initarg :model)))

(defmethod act ((env modeled-env) action)
  (multiple-value-bind (obs reward s2) (sample-transition (model env) (get-state env) action)
    (set-state s2 env)
    (values obs reward)))

(defmethod reset ((env modeled-env))
  (multiple-value-bind (obs s) (sample-initial (model env))
    (set-state s env)
    obs))

(defmethod at-terminal-state ((env modeled-env))
  (is-terminal-state (model env) (get-state env)))

(defmethod legal-action-list ((env modeled-env))
  (legal-action-list-at-state (model env) (get-state env)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ops to override
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric sample-transition (env-model s a)
  (:documentation "Sample from the transition distribution.  Return 1) observation 2) reward 3) next state."))

(defgeneric sample-initial (env-model)
  (:documentation "Sample from the initial state distribution of the environment.  Return the associated observation and state."))

(defgeneric is-terminal-state (env-model state)
  (:documentation "Is this a terminal state of the environment?.  By default, always returns nil.")
  (:method (env-model state) (declare (ignore env-model state)) nil))

(defgeneric is-legal-action (env-model state action)
  (:documentation "Is this a legal action at state?  By default, always returns t.")
  (:method (env-model state action) (declare (ignore env-model state action)) t))

(defgeneric legal-action-list-at-state (model state)
  (:documentation "List of legal actions at state (or throw action-list-unavailable condition).")
  (:method (model state) (declare (ignore model state)) (error 'action-list-unavailable)))
