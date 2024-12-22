(asdf:defsystem #:llm-dsl
  :description "A DSL for controlling LLM workflows"
  :author "Your Name"
  :license "MIT"
  :depends-on (#:dexador          ; HTTP client for Ollama API
               #:jonathan         ; JSON parsing
               #:alexandria       ; Utilities
               #:serapeum        ; More utilities
               #:babel)          ; 字符编码转换
  :components ((:module "llm-dsl"
                :components
                ((:file "package")
                 (:file "core" :depends-on ("package"))
                 (:file "modules" :depends-on ("core"))
                 (:file "workflow" :depends-on ("modules"))
                 (:file "script" :depends-on ("workflow")))))) 