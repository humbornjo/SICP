(define diff 0.0001)

(define (avg x y) (* (+ x y) 0.5))

(define (abs x) (if (< x 0) (- x) x))

(define (sqrt_iter guess x) 
  (avg guess (/ x guess))
)

(define (sqrt_newton guess x) 
  (if (< (abs (- (* guess guess) x)) diff) 
    guess
    (sqrt_newton (sqrt_iter guess x) x)
  )
)

(sqrt_newton 1 2)


