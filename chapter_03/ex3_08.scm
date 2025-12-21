;; Answer

(define f
  (let
    ((local 0))
    (define (ff x)
      (begin
        (set! local (- x local))
        local))
    ff))

(assert (eq? 1 (+ (f 0) (f 1))))
(assert (eq? 0 (+ (f 1) (f 0))))
