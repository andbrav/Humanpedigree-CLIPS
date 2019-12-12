; IF there is an affected individual with non affected parents
; THEN the trait is recessive

(defrule recessive
 ?trait<-(trait (name ?t1)(type nil))
 (hasphenotype (individual ?id1) (trait ?t1))
 (isparent (parent ?id2) (child ?id1))
 (not (hasphenotype (individual ?id2) (trait ?t1)))
 (isparent (parent ?id3) (child ?id1))
 (not (hasphenotype (individual ?id3) (trait ?t1)))
 (test (neq ?id2 ?id3))
=>
 (modify  ?trait (type "Recessive"))
 (printout t ?id1 " has " ?t1 " but her/his parents " ?id2 " and " ?id3 " do not => " ?t1 " is recessive" crlf))


; IF the trait is recessive AND all affected females have affected fathers AND affected females pass the trait to all their sons
; THEN the trait is recessive and x-linked
(defrule recessive-xlinked
 ?trait<-(trait (name ?t1)(type Recessive) (location nil))
 (forall (and (individual (id ?id1) (sex Female))
              (hasphenotype (individual ?id3) (trait ?t1))
              (isparent (parent ?id2) (child ?id1))
              (individual (id ?id2) (sex Male))
         )
         (hasphenotype (individual ?id2) (trait ?t1))
 )
 (forall (and (individual (id ?id3) (sex Female))
              (hasphenotype (individual ?id3) (trait ?t1))
              (isparent (parent ?id3) (child ?id4))
              (individual (id ?id4) (sex Male))
         )
         (hasphenotype (individual ?id4) (trait ?t1))
 )
 =>
 (modify  ?trait  (location "X-linked"))
 (printout t "All females affected by " ?t1 " have affected fathers and affected females pass the trait to all their sons and the trait is recessive => " ?t1 " is recessive and x-linked" crlf))


; IF the trait is recessive AND (there is affected females with unaffected fathers OR affected sons with unaffected mothers)
;THEN the trait is recessive and autosomal
(defrule recessive-autosomal
 ?trait<-(trait (name ?t1)(type Recessive) (location nil))
 (or (and (individual (id ?id1) (sex Female))
          (hasphenotype (individual ?id1) (trait ?t1))
          (isparent (parent ?id2) (child ?id1))
          (individual (id ?id2) (sex "Male"))
          (not (hasphenotype (individual ?id2) (trait ?t1)))
     )
     (and (individual (id ?id3) (sex Female))
          (hasphenotype (individual ?id3) (trait ?t1))
          (isparent (parent ?id3) (child ?id4))
          (individual (id ?id4) (sex Male))
          (not (hasphenotype (individual ?id4) (trait ?t1)))
     )
 )
 =>
 (modify  ?trait (location "Autosomal"))
 (printout t "There is females affected with " ?t1 " with unaffected fathers and unaffected males with affected mothers and " ?t1 " is recessive => " ?t1 " is recessive and autosomal" crlf))



 ; IF every affected individual has at least one parent affected
 ; THEN the trait is dominant
(defrule dominant
 ?trait<-(trait (name ?t1)(type nil))
 (forall (and (hasphenotype (individual ?id1) (trait ?t1))
              (isparent (parent ?id2) (child ?id1))
              (isparent (parent ?id3) (child ?id1))
              (test (neq ?id2 ?id3))
         )
         (or  (hasphenotype (individual ?id2) (trait ?t1))
              (hasphenotype (individual ?id3) (trait ?t1))
         )
 )
=>
 (modify ?trait (name ?t1) (type Dominant))
 (printout t "Every individual(with parents) with " ?t1 " has at least one of her/his parents with " ?t1 " => " ?t1 " is dominant" crlf))

; IF the trait is dominant AND every affected male has an affected mother AND all daughters of affected fathers are affected
; THEN the trait is dominant and X-linked
(defrule dominant-xlinked
 ?trait<-(trait (name ?t1) (type Dominant) (location nil))
 (forall (and (individual (id ?id1) (sex Male))
              (hasphenotype (individual ?id1) (trait ?t1))
              (isparent (parent ?id2) (child ?id1))
              (individual (id ?id2) (sex Female))
         )
         (hasphenotype (individual ?id2) (trait ?t1))
 )
 (forall (and (individual (id ?id3) (sex Male))
              (hasphenotype (individual ?id3) (trait ?t1))
              (isparent (parent ?id3) (child ?id4))
              (individual (id ?id4) (sex Female))
          )
         (hasphenotype (individual ?id4) (trait ?t1))
 )
 =>
 (modify   ?trait (location X-linked))
 (printout t "All male(with parents) affected by " ?t1 " have affected mother and all daughters of affected males are also affected => " ?t1 " is dominant and X linked" crlf))


; IF the trait is dominant AND there is an affected Male with affected father but unaffected mother AND there is an affected female
; THEN the trait is dominant and autosomal
(defrule dominant-autosomal1
 ?trait<-(trait (name ?t1) (type Dominant) (location nil))
 (individual (id ?id1) (sex Male))
 (hasphenotype (individual ?id1) (trait ?t1))
 (isparent (parent ?id2) (child ?id1))
 (isparent (parent ?id3) (child ?id1))
 (individual (id ?id2) (sex Male))
 (hasphenotype (individual ?id2) (trait ?t1))
 (individual (id ?id3) (sex Female))
 (not (hasphenotype (individual ?id3) (trait ?t1)))
 (individual (id ?id4) (sex Female))
 (hasphenotype (individual ?id4) (trait ?t1))
 =>
 (modify ?trait (location Autosomal))
 (printout t "There is a male " ?id1 " with " ?t1 " with an affected father " ?id2 " and no affected mother " ?id3 " (so it cant be X-linked) and there is affected females e.g " ?id4 "(so it cant be Y-linked) => " ?t1" is dominant and autosomal" crlf))


; IF the trait is dominant AND there is an unaffected Female with an affected father AND there is an affected female
; THEN the trait is dominant and autosomal
(defrule dominant-autosomal2
 ?trait<-(trait  (name ?t1) (type Dominant) (location nil))
 (individual (id ?id1) (sex Female))
 (not (hasphenotype (individual ?id1) (trait ?t1)))
 (isparent (parent ?id2) (child ?id1))
 (individual (id ?id2) (sex Male))
 (hasphenotype (individual ?id2) (trait ?t1))
 (individual (id ?id3) (sex Female))
 (hasphenotype (individual ?id3) (trait ?t1))
 =>
 (modify   ?trait (location Autosomal))
 (printout t "There is a female " ?id1 " without " ?t1 " with an affected father " ?id2 " and there is affected females eg. " ?id3 " (so it cant be neither X-linked or Y-linked) => " ?t1 " is dominant and autosomal" crlf))


; IF the trait is dominant AND there is only unaffected Females AND every affected male has only affected sons
; THEN the trait is Y-linked
(defrule dominant-ylinked
 ?trait<-(trait (name ?t1)(type Dominant) (location nil))
 (forall (individual (id ?id1) (sex Female))
         (not (hasphenotype (individual ?id1) (trait ?t1)))
 )
 (forall (and (individual (id ?id2) (sex Male))
              (hasphenotype (individual ?id2) (trait ?t1))
              (isparent (parent ?id2) (child ?id3))
         )
         (individual (id ?id3) (sex Male))
         (hasphenotype (individual ?id3) (trait ?t1))
 )
 =>
 (modify   ?trait (location Y-linked))
 (printout t "There is only males affected by " ?t1 " and affected males have only affected sons => " ?t1 " is Y-linked" crlf))
