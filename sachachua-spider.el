(setq a (url-get-content-from-html "http://sachachua.com/blog/2016/07/2016-07-18-emacs-news/"))
(setq a (url-get-content-from-html "http://sachachua.com/blog/2016/07/weekly-review-week-ending-july-15-2016/"))

(bs-get-text (bs-find a "div" '((class . "^navigation$"))))

(defun sachachua-spider-get-title (data)
  (cdr (bs-get-attr (bs-get-subnode (bs-find data "div" '((class . "^post$")))
                                    "h2" "a")
                    "title")))
;; (sachachua-spider-get-title a)

(defun sachachua-spider-get-entry (data)
  (with-temp-buffer
    (shr-insert-document (bs-find data "div" '((class . "^entry$"))))
    (buffer-string)))
;; (sachachua-spider-get-entry a)

(defun sachachua-spider-get-pre-post-url (data)
  (cdr (bs-get-attr (bs-get-subnode
                     (bs-find data "div" '((class . "^navigation$")))
                     "a")
                    'href)))
;; (sachachua-spider-get-pre-post-url a)


(defun sachachua-spider (start-url)
  (while start-url
    (message "saving %s" start-url)
    (let* ((data (bs-get-node-from-html start-url))
           (title (sachachua-spider-get-title data))
           (entry (sachachua-spider-get-entry data))
           (pre-url (sachachua-spider-get-pre-post-url data))
           (filename (format "posts/%s.txt" title)))
      (setq start-url pre-url)
      (unless (file-exists-p (file-name-directory filename))
        (make-directory (file-name-directory filename)))
      (with-temp-file filename
        (insert entry)))))


(sachachua-spider  "http://sachachua.com/blog/2016/07/2016-07-18-emacs-news/")
