(in-package #:llm-dsl)

;; 定义模块宏
(defmacro define-module (name (&key input output) &body body)
  (declare (ignore output))  ; 显式声明忽略 output 参数
  `(defun ,name (,input)
     (let ((result (progn ,@body)))
       result)))

;; 工作流操作符
(defmacro -> (initial &rest forms)
  (reduce (lambda (acc form)
            `(funcall #',(car form) ,acc ,@(cdr form)))
          forms
          :initial-value initial))

;; 链式处理宏
(defmacro chain (&body forms)
  `(-> ,@forms)) 