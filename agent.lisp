(in-package :agent-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic ops for agents
;; An agent is something that can observe environment
;; transitions and select actions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric observe (agent observation action reward)
  (:documentation "Observe a transition in environment.  Returns nothing."))

(defgeneric observe-initial (agent observation)
  (:documentation "Receive initial observation from environment.  Defaults to calling observe with action 'reset.")
  (:method (agent obs) (observe agent obs 'reset 0.0)))

(defgeneric select-action (agent)
  (:documentation "Select an action given the observations seen so far.  The agent may also throw an error condition of type agent-finished.  Should be side-effect free (modulo things like caching which don't affect return value)."))

(defgeneric reset-local-state (agent)
  (:documentation "The intended semantics is that if agent sees a stream of observations, then state is reset, then sees the same stream, it will have the same resulting distribution over selected actions."))

(define-condition agent-finished () ())

