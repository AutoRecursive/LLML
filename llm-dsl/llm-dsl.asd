(asdf:defsystem #:llm-dsl
  :description "A DSL for controlling LLM workflows"
  :author "Your Name"
  :license "MIT"
  :depends-on (#:dexador          ; HTTP client for Ollama API
               #:jonathan         ; JSON parsing
               #:alexandria       ; Utilities
               #:serapeum)       ; More utilities
  :components ((:file "package")
              (:file "core")
              (:file "modules")
              (:file "workflow"))) 