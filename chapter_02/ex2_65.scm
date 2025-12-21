;; Answer

(load "../init.scm")
(load "./ex2_59.scm")
(load "./ex2_63.scm")
(load "./ex2_64.scm")

(define (union-set-n s1 s2)
  (list->tree (union-set (tree->list-1 s1) (tree->list-1 s2))))

(define (intersection-set-n s1 s2)
  (list->tree (intersection-set (tree->list-1 s1) (tree->list-1 s2))))

(define l1 '(1 3 5 7 10 14 15 20 31 50 51 53 55 57 59 61 63 65))
(define l2 '(1 3 5 8 10 24 25 30 41 50 52 54 56 58 60 62 64 66))

(define t1 (list->tree l1))
(define t2 (list->tree l2))

; (display (intersection-set-n t1 t2))
;
; (display (union-set-n t1 t2))
