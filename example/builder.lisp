(defpackage :nix-cl-user
  (:use :cl))
(in-package :nix-cl-user)

(require :asdf)
(asdf:load-system "@pname@")
