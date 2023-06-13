(in-package :magischeschwein)

(defun shout/handler (cmd)
  (let ((args (mapcar #'string-upcase (clingon:command-arguments cmd)))
        (user (clingon:getopt cmd :user)))
    (format T "HEY, ~A!~%" user)
    (format T "~A!~%" (clingon:join-list args #\SPACE))))

(defun shout/command ()
  (clingon:make-command
    :name "shout"
    :description "shouts back things you write"
    :usage "[options] [arguments ...]"
    :handler #'shout/handler))

(defun top-level/options ()
  "Creates and returns the options for the top-level command"
  (list
   (clingon:make-option
    :counter
    :description "verbosity level"
    :short-name #\v
    :long-name "verbose"
    :key :verbose)
   (clingon:make-option
    :string
    :description "user to greet"
    :short-name #\u
    :long-name "user"
    :initial-value "stranger"
    :env-vars '("USER")
    :key :user)))

(defun top-level/handler (cmd)
  (let ((args (clingon:command-arguments cmd))
        (user (clingon:getopt cmd :user))
        (verbose (clingon:getopt cmd :verbose)))
    (format T "Hello, ~A!~%" user)
    (format T "The current verbosity level is set to ~A~%" verbose)
    (format T "You have provided ~A arguments~%" (length args))
    (format T "Bye!~%")))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "FIXME"
    :version "0.0.1"
    :license "GNU GPL v3"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-v] [-u <USER>]"
    :options (top-level/options)
    :handler #'top-level/handler
    :sub-commands (list (shout/command))))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
