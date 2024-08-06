(define (sum term a next b)
  (if (> a b)
    0
    (+ (term a)
       (sum term (next a) next b))))


; exercise 1.30
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (+ (term a) result))))
  (iter a 0))


; exercise 1.31
(define (product term a next b)
  (if (> a b)
    1
    (* (term a)
       (product term (next a) next b))))

(define (product term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (* (term a) result))))
  (iter a 1))

(define (factorial n)
  (define (next x) (+ x 1))
  (define (term x) x)
  (product term 1 next n))

(display (factorial 5)) (newline)


; exercise 1.32
(define (accumulate combiner null-value term a next b) 
  (if (> a b)
    null-value
    (combiner (term a)
       (accumulate combiner null-value term (next a) next b))))

(define (accumulate combiner null-value term a next b) 
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (combiner (term a) result))))
  (iter a null-value))

(define (product term a next b)
  (accumulate * 1 term a next b))

(display (factorial 5)) (newline)

; exercise 1.33
(define (filtered-accumulate combiner filter null-value term a next b) 
  (if (> a b)
    null-value
    (if (filter (term a)) 
      (filtered-accumulate combiner filter null-value term (next a) next b)
      (combiner 
        (term a)
        (filtered-accumulate combiner filter null-value term (next a) next b)))))

;; question a

(begin
  (define (smallest-divisor n) (find-divisor n 2))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))

  (define (divides? a b) (= (remainder b a) 0))
  (define (prime? n) (= n (smallest-divisor n)))

  (define (prime_square a b) 
    (define (next x) 
      (if (< x 2) 
        (+ x 1)
        (if (even? x) (+ x 1) (+ x 2))))
    (filtered-accumulate + prime? 0 square a next b))

  (prime_square 1 5))


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

  (prime_relative 5))
