(in-package #:llm-dsl)

;; 定义全局配置变量
(defvar *current-llm-config* nil)

;; LLM 配置结构
(defclass llm-config ()
  ((model :initarg :model
          :accessor llm-model
          :initform "qwen2")
   (temperature :initarg :temperature
                :accessor llm-temperature
                :initform 0.7)
   (system :initarg :system
           :accessor llm-system
           :initform nil)
   (api-url :initarg :api-url
            :accessor llm-api-url
            :initform "http://localhost:11434/api/generate")))

;; 基础模块类
(defclass module ()
  ((name :initarg :name
         :accessor module-name)
   (input :initarg :input
          :accessor module-input)
   (output :initarg :output
           :accessor module-output)
   (processor :initarg :processor
              :accessor module-processor)))

;; 处理 Ollama 的流式响应
(defun process-ollama-response (response-string)
  (format t "~&Processing response...~%")
  (let ((result ""))
    (handler-case
        (with-input-from-string (stream response-string)
          (loop for line = (read-line stream nil nil)
                while line
                do (handler-case
                     (let* ((json-response (jonathan:parse line :as :hash-table))
                            (response-text (gethash "response" json-response)))
                       (when response-text
                         (setf result (concatenate 'string result response-text))))
                     (error (e)
                       (format t "~&Error parsing line: ~A~%Error: ~A~%" line e)))))
      (error (e)
        (format t "~&Error processing response: ~A~%" e)))
    result))

;; 与Ollama API交互 - 使用当前配置
(defun call-ollama (prompt &optional (config *current-llm-config*))
  (unless config
    (setf config (make-instance 'llm-config)))
  (format t "~&Sending request to Ollama with model: ~A~%" (llm-model config))
  (let* ((request-data `(("model" . ,(llm-model config))
                        ("prompt" . ,prompt)
                        ("temperature" . ,(llm-temperature config))))
         ;; 如果有系统提示词，添加到请求中
         (request-data (if (llm-system config)
                          (cons `("system" . ,(llm-system config)) request-data)
                          request-data))
         (response (dex:post (llm-api-url config)
                           :content (jonathan:to-json request-data :from :alist)
                           :force-binary t
                           :read-timeout nil     ; 设置为 nil 表示无超时限制
                           :connect-timeout nil  ; 连接超时也设置为无限制
                           :keep-alive t))
         (response-text (babel:octets-to-string response :encoding :utf-8)))
    (process-ollama-response response-text)))

(defun test-connection ()
  (handler-case 
      (progn
        (call-ollama "test")
        (format t "~&Connection successful!"))
    (error (c)
      (format t "~&Connection failed: ~A" c))))