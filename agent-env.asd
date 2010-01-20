;;;; -*- Mode: LISP -*-

(in-package :asdf)

(defsystem :agent-env
  :components
  ((:file "package")
   (:file "env" :depends-on ("package"))
   (:file "agent" :depends-on ("package"))
   (:file "modeled-env" :depends-on ("env"))
   (:file "trajectory" :depends-on ("env" "agent"))
   (:file "listeners" :depends-on ("trajectory"))
   (:file "prompt-agent" :depends-on ("listeners" "agent"))
   )
  :depends-on ("cl-utils"))

  