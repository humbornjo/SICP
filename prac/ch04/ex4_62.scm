; Define rules to implement the last-pair operation of Exercise
; 2.17, which returns a list containing the last element of a
; nonempty list. Check your rules on queries such as
; (last-pair (3) ?x), (last-pair (1 2 3) ?x) and
; (last-pair (2 ?x) (3)). Do your rules work correctly on queries
; such as (last-pair ?x (3)) ?


;; Answer

; A last-pair is:
; 1. the list itself if there is only one elem in the list
; 2. the last-pair of the rest of the list otherwise

(rule (last-pair ?y ?y)
      (lisp-value null? (lisp-value cdr ?x)))

(rule (last-pair ?x ?y)
      (and (not (lisp-value null? (lisp-value cdr ?x)))
           (last-pair (lisp-value cdr ?x) ?y)))

