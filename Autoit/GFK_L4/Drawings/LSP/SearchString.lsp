(defun c:SearchString ()
  (setq searchStr (getstring "\nEnter the string to search: "))
  (setq counter 0)
  (setq totalEnt 0)
  
  (vlax-for ent (vla-get-entities (vla-get-activedocument (vlax-get-acad-object))))
    (setq text (vla-get-textstring ent))
    (setq found (vl-string-search searchStr text))
    (if found
        (setq counter (+ counter 1))
    )
    (setq totalEnt (+ totalEnt 1))
  )
  
  (if (/= totalEnt 0)
      (progn
        (princ (strcat "\nString found " (itoa counter) " times in the drawing."))
      )
      (princ "\nNo entities found in the drawing.")
  )
  
  (princ)
)
