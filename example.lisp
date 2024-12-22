(in-package :llm-dsl)

;; 定义模块
(define-module summarize (:input text :output result)
  (call-ollama (format nil "Please summarize: ~A" text)))

(define-module translate-to-chinese (:input text :output result)
  (call-ollama (format nil "Translate to Chinese: ~A" text)))

;; 定义工作流
(define-workflow process-text (text)
  (with-llm (:model "qwen2.5" :temperature 0.7)
    (chain
     (summarize text)
     (translate-to-chinese))))

;; 运行工作流
(format t "~&Result: ~A~%"
        (process-text "Common Lisp is a dialect of the Lisp programming language.")) 