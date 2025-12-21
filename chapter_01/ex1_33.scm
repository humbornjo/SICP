;; Answer

(load "./eval_init.scm")

(define (filtered-accumulate combiner filter null-value term a next b)
  (if (> a b)
    null-value
    (if (filter (term a))
      (filtered-accumulate combiner filter null-value term (next a) next b)
      (combiner
        (term a)
        (filtered-accumulate combiner filter null-value term (next a) next b)))))

; a.

(load "./ex1_21.scm")

(begin
  (define (prime_square a b)
    (define (next x)
      (if (<= x 2)
        (+ x 1)
        (if (even? x) (+ x 1) (+ x 2))))
    (filtered-accumulate + prime? 0 square a next b))

  (assert (eq? 38 (prime_square 1 5))))

; b.

(begin
  (define (gcd a b)
    (if (= b 0)
      a
      (gcd b (remainder a b))))
  (define (prime_relative b)
    (define (reltive? a)
      (not (= (gcd a b) 1)))
    (define (next x) (+ x 1))
    (define (term x) x)
    (filtered-accumulate * reltive? 1 term 1 next (- b 1)))

  (assert (eq? 24 (prime_relative 5))))
