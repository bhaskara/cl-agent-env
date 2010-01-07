;;;; -*- Mode: LISP -*-

(in-package :asdf)

(defsystem :agent-env
  :components
  ((:file "package")
   (:file "env" :depends-on ("package"))
   (:file "modeled-env" :depends-on ("env"))
   (:file "trajectory" :depends-on ("env"))
   (:file "prompt-agent" :depends-on ("package"))
   (:file "listeners" :depends-on ("trajectory"))
   )
  :depends-on ("cl-utils"))

  