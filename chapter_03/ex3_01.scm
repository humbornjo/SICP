;; Answer

(define (make-accumulator init)
  (lambda (acc)
    (begin
      (set! init (+ init acc))
      init)))

(define A (make-accumulator 5))

(assert (eq? 15 (A 10)))
