; Beginning with the data base and the rules you formulated in
; Exercise 4.63, devise a rule for adding “greats” to a grandson
; relationship. This should enable the system to deduce that Irad
; is the great-grandson of Adam, or that Jabal and Jubal are the
; great-great-great-great-great-grandsons of Adam. (Hint:
; Represent the fact about Irad, for example, as
; ((great grandson) Adam Irad). Write rules that determine if a
; list ends in the word grandson. Use this to express a rule that
; allows one to derive the relationship ((great . ?rel) ?x ?y),
; where ?rel is a list ending in grandson.) Check your rules on
; queries such as ((great grandson) ?g ?ggs) and
; (?relationship Adam Irad).


;; Answer

; (son Adam Cain)
; (son Cain Enoch)
; (son Enoch Irad)
; (son Irad Mehujael)
; (son Mehujael Methushael)
; (son Methushael Lamech)
; (wife Lamech Ada)
; (son Ada Jabal)
; (son Ada Jubal)

; Rules from ex4.63
(rule (son ?W ?S)
      (and (wife ?M ?W)
           (son ?M ?S)))

(rule (grandson ?x ?y)
      (and (son ?x ?z)
           (son ?z ?y)))

; Rule to determine if a list ends with grandson
(rule (end-with-grandson (?x1 . ?xs))
      (or (assert! ?xs (grandson))
          (end-with-grandson ?xs)))

(rule (great-grandson (great . ?rel) ?x ?y)
      (or (and (assert! ?rel (grandson))
               (grandson (son ?x) ?y))
          (great-grandson ?rel (son ?x) ?y)))
