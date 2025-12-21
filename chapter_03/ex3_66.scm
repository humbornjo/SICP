;; Answer

(load "./eval_init_stream.scm")

; http://community.schemewiki.org/?sicp-ex-3.66
;
; Check my answer @humbornjo and brandon's @brandon.

(define (pos m n)
  (define init (if (= m n) 1 (* 2 (- n m))))
  (define (inner x res)
    (if (= x 1)
      res
      (inner (- x 1) (+ 1 (* 2 res)))))
  (inner m init))

(define (pnum m n)
  (- (pos m n) 1))

(display "(1,   100): ")
(display (pnum 1 100))
(newline)
(display "(99,  100): ")
(display (pnum 99 100))
(newline)
(display "(100, 100): ")
(display (pnum 100 100))
