;;;; -*- Mode: LISP -*-

(in-package :asdf)

(defsystem :agent-env
  :components
  ((:file "package")
   (:file "conditions" :depends-on ("package"))
   (:file "env" :depends-on ("package" "conditions"))
   (:file "modeled-env" :depends-on ("env"))
   (:file "trajectory" :depends-on ("env"))
   (:file "prompt-agent" :depends-on ("package"))
   )
  :depends-on ("series"))
  