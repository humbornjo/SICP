;; Answer

(load "../init.scm")

(define (* a b)
  (define (iter _sum _a _b)
    (cond ((= _b 0) _sum)
          ((even? _b) (iter _sum (double _a) (halve _b)))
          (else (iter (+ _a _sum) a (- _b 1)))))
  (iter 0 a b))

(assert (eq? 12 (* 3 4)))
