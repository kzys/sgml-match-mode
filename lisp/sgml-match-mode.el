(require 'easy-mmode)
(easy-mmode-define-minor-mode
 sgml-match-mode "" nil " ></" nil)

(defvar sgml-match-show-timer
  (run-with-idle-timer 0.2 t 'sgml-match-show-on-idle))

(defvar sgml-match-overlay (make-overlay 0 0))

(defun sgml-match-show-on-idle ()
  (if sgml-match-mode
      (sgml-match-show-element)))

(defun sgml-match-overlay-move ()
  (let* ((context (car (sgml-get-context)))
         (s (sgml-tag-start context))
         (e (sgml-tag-end context)))
    (cond
     ((and
       (pos-visible-in-window-p s)
       (pos-visible-in-window-p e))
      (move-overlay sgml-match-overlay s e (current-buffer))
      (overlay-put sgml-match-overlay 'face 'highlight))
     (t
      (message "%s" (buffer-substring s e))))))

(defun sgml-match-overlay-hide ()
  (overlay-put sgml-match-overlay 'face nil))

(defun sgml-match-show-element ()
  (save-excursion
    (if (eq (car (sgml-lexical-context)) 'tag)
        (let* ((context (car (save-excursion (sgml-get-context))))
               (type (sgml-tag-type context)))
          (cond ((eq type 'open)
                 (sgml-skip-tag-forward 1)
                 (backward-char 1)
                 (sgml-match-overlay-move))
                ((eq type 'close)
                 (sgml-skip-tag-backward 1)
                 (forward-char 1)
                 (sgml-match-overlay-move))
                (t
                 (sgml-match-overlay-hide))) )
      (sgml-match-overlay-hide))))

(provide 'sgml-match-mode)
