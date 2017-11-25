;;;; base.lisp --- main entry point into nEXT

(in-package :next)

(defun start ()
  (ensure-directories-exist (uiop:physicalize-pathname "~/.next.d/"))
  (initialize-bookmark-db)
  (initialize-default-key-bindings)
  (interface:initialize)
  (interface:start)
  ;; create the default buffers
  (setf *minibuffer*
	(make-instance 'buffer :name "minibuffer" :mode (minibuffer-mode)))
  (set-visible-active-buffer (generate-new-buffer "default" (document-mode)))
  ;; load the user configuration if it exists
  (load "~/.next.d/init.lisp" :if-does-not-exist nil))

(defun initialize-default-key-bindings ()
  (define-key global-map (kbd "C-x C-c")
    #'interface:kill)
  (define-key global-map (kbd "C-x b")
    (:input-complete *minibuffer* switch-buffer buffer-complete))
  (define-key global-map (kbd "C-x k")
    (:input-complete *minibuffer* delete-buffer buffer-complete))
  (define-key global-map (kbd "M-l")
    (:input *minibuffer* set-url-new-buffer))
  (define-key global-map (kbd "S-b k")
    (:input-complete *minibuffer* bookmark-delete bookmark-complete))
  (define-key minibuffer-mode-map (kbd "")
    #'(lambda () (return-input (mode *minibuffer*))))
  (define-key minibuffer-mode-map (kbd "C-g")
    #'(lambda () (cancel-input (mode *minibuffer*))))
  (define-key minibuffer-mode-map (kbd "Escape")
    #'(lambda () (cancel-input (mode *minibuffer*))))
  (define-key document-mode-map (kbd "M-f")
    (:input-complete *minibuffer* history-forwards-query history-fowards-query-complete))
  (define-key document-mode-map (kbd "M-b")
    #'history-backwards)
  (define-key document-mode-map (kbd "C-g")
    (:input *minibuffer* go-anchor :setup #'setup-anchor :cleanup #'remove-link-hints))
  (define-key document-mode-map (kbd "M-g")
    (:input *minibuffer* go-anchor-new-buffer :setup #'setup-anchor :cleanup #'remove-link-hints))
  (define-key document-mode-map (kbd "S-g")
    (:input *minibuffer* go-anchor-new-buffer-focus :setup #'setup-anchor))
  (define-key document-mode-map (kbd "C-f")
    #'history-forwards)
  (define-key document-mode-map (kbd "C-b")
    #'history-backwards)
  (define-key document-mode-map (kbd "C-p")
    #'scroll-up)
  (define-key document-mode-map (kbd "C-n")
    #'scroll-down)
  (define-key document-mode-map (kbd "C-l")
    (:input *minibuffer* set-url :setup #'setup-url))
  (define-key document-mode-map (kbd "S-b o")
    (:input-complete *minibuffer* set-url bookmark-complete))
  (define-key document-mode-map (kbd "S-b s")
    #'bookmark-current-page)
  (define-key document-mode-map (kbd "C-[")
    #'switch-buffer-previous)
  (define-key document-mode-map (kbd "C-]")
    #'switch-buffer-next)
  (define-key global-map (kbd "C-w")
    #'delete-active-buffer)
  (define-key minibuffer-mode-map (kbd "C-n")
    #'interface:minibuffer-select-next)
  (define-key minibuffer-mode-map (kbd "C-p")
    #'interface:minibuffer-select-previous))
