(defun copy-everything-with-pos (source-dwg target-dwg x y z)
  (vl-load-com)
  
  (setq source (vla-get-activedocument
                (vlax-get-acad-object)))
  (setq target (vla-open
                (vlax-get-acad-object)
                target-dwg))
  
  (vla-zoomextents source)
  
  (setq model-space (vla-get-modelspace source))
  (setq target-model-space (vla-get-modelspace target))
  
  (setq insertion-point (vlax-3d-point (list x y z)))
  
  (vla-copyobjects model-space target-model-space insertion-point)
  
  (vla-zoomextents target)
  
  (vla-saveas target target-dwg)
  (vla-close target)
  
  (vla-activedocument source))

;; Usage example:
(copy-everything "C:\\path\\to\\source.dwg" "C:\\path\\to\\target.dwg" 0.0 0.0 0.0)
