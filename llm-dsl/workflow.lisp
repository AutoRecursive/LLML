(in-package #:llm-dsl)

(defmacro define-workflow (name (&rest args) &body body)
  `(defun ,name (,@args)
     ,@body))

;; LLM上下文管理宏
(defmacro with-llm ((&key (model "llama2") 
                         (temperature 0.7)
                         system) 
                    &body body)
  `(let ((*current-llm-config* 
          (make-instance 'llm-config 
                        :model ,model 
                        :temperature ,temperature
                        :system ,system)))
     ,@body)) 