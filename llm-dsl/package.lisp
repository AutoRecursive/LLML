(defpackage #:llm-dsl
  (:use #:cl)
  (:export #:define-module
           #:define-workflow
           #:run-workflow
           #:with-llm
           #:->
           #:chain
           #:load-and-run-script
           #:*current-llm-config*)) 