;; Answer

(load "../chapter_03/ex3_12.scm")

(define (make-cycle x)
  (set-cdr! (last-pair x) x) x)

(define z (make-cycle (list 'a 'b 'c)))

; [a, *]->[b, *]->[c, *]->[a, *]-> ...
;
; (display (last-pair z)) ; it hangs
