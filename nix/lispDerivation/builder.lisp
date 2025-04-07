(defpackage :nix-cl-user
  (:use :cl))
(in-package :nix-cl-user)

(require "asdf")

(handler-case
    (progn
      (asdf:load-system "@pname@")
      (ext:quit 0))
  (error (e)
    (format *error-output* "Error: ~A~%" e)
    (ext:quit 1)))
