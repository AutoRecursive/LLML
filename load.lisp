;; 确保 ASDF 和 Quicklisp 正确加载
(require :asdf)

;; 加载 Quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;; 添加当前项目到 ASDF 的搜索路径
(let* ((script-path *load-truename*)
       (project-root (make-pathname :directory (pathname-directory script-path))))
  (push project-root asdf:*central-registry*))

;; 加载依赖
(ql:quickload :dexador)
(ql:quickload :jonathan)
(ql:quickload :alexandria)
(ql:quickload :serapeum)
(ql:quickload :str)
(ql:quickload :babel)

;; 加载系统
(asdf:load-system :llm-dsl :force t)

(format t "~&Successfully loaded all dependencies and the llm-dsl system~%") 