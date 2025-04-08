(defpackage :nix-cl-user
  (:use :cl))
(in-package :nix-cl-user)

(require "asdf")

(handler-case
    (progn
      (asdf:load-system "@pname@")
      (uiop:quit 0))
  (error (e)
    (format *error-output* "Error: ~A~%" e)
    (uiop:quit 1)))
