(in-package #:llm-dsl)

(defvar *current-llm-config* nil)

(defun load-and-run-script (script-path)
  (format t "~&Loading script from: ~A~%" script-path)
  (handler-case
      (load script-path)
    (error (e)
      (format t "~&Error loading script: ~A~%" e)))) 