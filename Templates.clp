(deftemplate individual
  (slot id)
  (slot sex))

(deftemplate trait
    (slot name)
    (slot type)
    (slot location))

; Family relationships
(deftemplate isparent
    (slot parent)
    (slot child))

(deftemplate hasphenotype
    (slot individual)
    (slot trait))
