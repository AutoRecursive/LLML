(load (merge-pathnames "load.lisp" *load-truename*))

(in-package :llm-dsl)

(defun main ()
  (let ((args sb-ext:*posix-argv*))
    (format t "~&Arguments: ~S~%" args)
    (if (< (length args) 2)
        (format t "~&Usage: ~A <script-file>~%" (first args))
        (progn
          (format t "~&Loading script: ~A~%" (second args))
          (load-and-run-script (second args))))))

(when *load-truename*
  (main))