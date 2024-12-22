(defun ensure-project-loaded ()
  (let* ((script-path *load-truename*)
         (project-root (make-pathname :directory (pathname-directory script-path)))
         (system-path project-root))
    
    (format t "~&Loading project from: ~A~%" system-path)
    (push system-path asdf:*central-registry*)
    
    (handler-case
        (progn
          (asdf:compile-system :llm-dsl :force t)
          (asdf:load-system :llm-dsl :force t)
          (format t "~&Successfully loaded llm-dsl system~%"))
      (error (c)
        (format t "~&Failed to load system: ~A~%" c)
        (sb-ext:quit :unix-status 1)))))

(ensure-project-loaded) 