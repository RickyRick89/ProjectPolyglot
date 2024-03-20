(defun c:FindAndReplace (/ oldStr newStr count)
  (setq oldStr (getstring "\nEnter the string to find: "))
  (setq newStr (getstring "\nEnter the replacement string: "))
  (setq count 0)

  (if (and oldStr newStr)
    (progn
      (setq ss (ssget '((0 . "*TEXT"))))
      (setq i 0)

      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq txt (cdr (assoc 1 (entget ent))))

        (if (wcmatch txt (strcat "*" oldStr "*"))
          (progn
            (setq newTxt (vl-string-translate oldStr newStr txt))
            (entmod (subst (cons 1 newTxt) (assoc 1 (entget ent)) (entget ent)))
            (setq count (1+ count))
          )
        )

        (setq i (1+ i))
      )

      (princ (strcat "\nString replaced successfully! " (itoa count) " instances found."))
    )
    (princ "\nInvalid input. Please try again.")
  )
  
  (princ)
)
