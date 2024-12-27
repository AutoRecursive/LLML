(in-package :llm-dsl)

;; 定义模块
(define-module summarize (:input text :output result)
  (call-ollama (format nil "Summarize: ~A" text)))

(define-module translate-to-chinese (:input text :output result)
  (call-ollama (format nil "Translate to Chinese: ~A" text)))

;; 定义工作流
(define-workflow process-text (text)
  (with-llm (:model "Claude-3.5-Opus" 
             :temperature 0.7
             :system "You are a helpful assistant with two main functions:
1. When receiving text starting with 'Summarize:', provide a clear, concise one-sentence summary.
2. When receiving text starting with 'Translate to Chinese:', provide an accurate Chinese translation.
Always respond directly with the result, without any additional commentary or questions.")
    (let* ((summary (summarize text))
           (translation (translate-to-chinese summary)))
      translation)))

;; 运行工作流
(format t "~&Result: ~A~%"
        (process-text "Common Lisp is a dialect of the Lisp programming language.")) 
