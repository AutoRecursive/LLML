(in-package #:llm-dsl)

;; LLM 配置结构
(defclass llm-config ()
  ((model :initarg :model
          :accessor llm-model
          :initform "qwen2.5")
   (temperature :initarg :temperature
                :accessor llm-temperature
                :initform 0.7)
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
                       (format t "~&Parsed JSON: ~A~%" json-response)
                       (when response-text
                         (setf result (concatenate 'string result response-text))))
                     (error (e)
                       (format t "~&Error parsing line: ~A~%Error: ~A~%" line e)))))
      (error (e)
        (format t "~&Error processing response: ~A~%" e)))
    result))

;; 与Ollama API交互 - 修改后的版本
(defun call-ollama (prompt &optional (config (make-instance 'llm-config)))
  (format t "~&Sending request to Ollama with model: ~A~%" (llm-model config))
  (let* ((response (dex:post (llm-api-url config)
                            :content (jonathan:to-json
                                    `(("model" . ,(llm-model config))
                                      ("prompt" . ,prompt)
                                      ("temperature" . ,(llm-temperature config)))
                                    :from :alist)
                            :force-binary t))  ; 强制二进制响应
         (response-text (babel:octets-to-string response :encoding :utf-8)))
    (format t "~&Raw response: ~A~%" response-text)
    (process-ollama-response response-text)))

(defun test-connection ()
  (handler-case 
      (progn
        (call-ollama "test")
        (format t "~&Connection successful!"))
    (error (c)
      (format t "~&Connection failed: ~A" c))))