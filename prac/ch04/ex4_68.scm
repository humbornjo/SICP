; Define rules to implement the reverse operation of Exercise
; 2.18, which returns a list containing the same elements as a
; given list in reverse order. (Hint: Use append-to-form.) Can
; your rules answer both (reverse (1 2 3) ?x) and
; (reverse ?x (1 2 3)) ?


;; Answer

(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))

(rule (reverse (?x1 . ?xs) ?y)
      (and (reverse ?xs ?rxs)
           (append-to-form ?rxs (?x1) ?y)))
