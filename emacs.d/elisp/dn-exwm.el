(defvar dn/exwm--floating-pinned-windows '()
  "Holds the set of pinned window IDs.")

;;;###autoload
(defun dn/exwm-floating-toggle-pinned (&optional id)
  (interactive)
  (when-let ((exwm--floating-frame)
             (window-id (or id exwm--id)))
    (if (seq-contains dn/exwm--floating-pinned-windows window-id)
      (setq dn/exwm--floating-pinned-windows (remq window-id dn/exwm--floating-pinned-windows))
      (push window-id dn/exwm--floating-pinned-windows))))

(defun dn/exwm-floating--on-workspace-switch ()
  (let ((current-monitor (frame-parameter exwm--frame 'exwm-randr-monitor)))
    (dolist (id dn/exwm--floating-pinned-windows)
      (when-let ((buffer (exwm--id->buffer id)))
        (with-current-buffer buffer
          (when (equal current-monitor (frame-parameter exwm--frame 'exwm-randr-monitor))
            (exwm-workspace-move-window exwm-workspace-current-index id)))))))

(defun dn/exwm-floating--on-buffer-killed ()
  (when (derived-mode-p 'exwm-mode)
    (setq dn/exwm--floating-pinned-windows (remq exwm--id dn/exwm--floating-pinned-windows))))

(add-hook 'exwm-workspace-switch-hook #'dn/exwm-floating--on-workspace-switch)
(add-hook 'kill-buffer-hook #'dn/exwm-floating--on-buffer-killed)

(provide 'dn-exwm)
