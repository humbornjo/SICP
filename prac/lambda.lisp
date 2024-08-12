; exercise 1.35
(define tolerance 0.001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))


(begin 
  (* 1.0 (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1))
)

; exercise 1.36
(define (vfixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (newline)
    (display (* 1.0 guess)) 
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))

(begin 
  (* 1.0 (vfixed-point (lambda (x) (/ (log 1000) (log x))) 10))
)


; exercise 1.37
;; a
(define (cont-frac n d k)
  (define (iter i)
    (if (= i k)
      (/ (n i) (d i))
      (/ (n i) (+ (d i) (iter  (+ i 1))))))
  (iter 1))

(begin
  (newline)
  (display "Expect: ") (display (/ 1 1.618))
  (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10)
)

;; b
(define (cont-frac n d k)
  (define (iter res i)
    (if (= i 0)
      res
      (iter (/ (n i) (+ (d i) res)) (- i 1))))
  (iter (/ (n k) (d k)) (- k 1)))

(begin
  (newline)
  (display "Expect: ") (display (/ 1 1.618))
  (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10)
)

; exercise 1.38
(begin
  (+ 2 (cont-frac 
    (lambda (i) 1.0)
    (lambda (i) 
      (if (= (remainder i 3) 2) (* (/ (+ i 1) 3) 2) 1)) 
    10
  ))
)


; exercise 1.39
(define (tan-cf x k) 
  (cont-frac 
    (lambda (i) 
      (if (= i 1) x (- (* x x))))
    (lambda (i) (- (* i 2) 1))
    k))

(begin (* 1.0 (tan-cf 1 10)))
