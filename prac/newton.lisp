(define diff 0.0001)

(define (avg x y) (* (+ x y) 0.5))
(define (square x) (* x x))
(define (cube x) (* x x x))
(define (abs x) (if (< x 0) (- x) x))

(define (sqrt_iter guess x) 
  (avg guess (/ x guess)))

; exercise 1.6: http://community.schemewiki.org/?sicp-ex-1.6
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
    (else else-clause)))

; exercise 1.7
(define (sqrt_enough guess x)
  (< (abs (- (square guess) x)) (* x 1e-2)))

(define (sqrt_newton guess x) 
  (if (sqrt_enough guess x) 
    guess
    (sqrt_newton (sqrt_iter guess x) x)
  ))

(sqrt_newton 1 1e-127)

; exercise 1.8
(define (cbrt x) 
  (define (cbrt_enough guess)
    (< (abs (- (cube guess) x)) (* x 1e-2)))
  (define (cbrt_iter guess) 
    (/ (+ (/ x (square guess)) (* 2 guess)) 3))
  (define (cbrt_newton guess)
    (if (cbrt_enough guess) 
      (* guess 1.0)
      (cbrt_newton (cbrt_iter guess))))
  (cbrt_newton 1))

(cbrt 2)
