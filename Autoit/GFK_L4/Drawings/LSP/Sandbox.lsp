(defun C:TRC ; = Text Replace for Complete text/mtext strings
  (/ told tnew tss tdata)
  (setq
    told (getstring "\Old text content to be replaced: ")
    tnew (getstring T "\nNew text content to replace it with: ")
    tss (ssget "X" (list (cons 1 told)))
  ); end setq
  (repeat (sslength tss)
    (setq
      tdata (entget (ssname tss 0))
      tdata (subst (cons 1 tnew) (assoc 1 tdata) tdata)
    ); end setq
    (entmod tdata)
    (ssdel (ssname tss 0) tss)
  ); end repeat
); end defun