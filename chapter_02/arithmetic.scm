
(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))
(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))
(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (numer x) (car x))
(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

; exercise 2.1
(define (make-rat n d)
  (let ((g (gcd n d)))
    (if (< d 0)
      (cons (/ (* -1 n) g) (/ (* -1 d) g))
      (cons (/ n g) (/ d g)))))

(define one-third (make-rat -1 -3))
(define n-one-half (make-rat -1 2))
(print-rat (add-rat n-one-half one-third))

; exercise 2.2
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment seg) (car seg))
(define (end-segment seg) (cdr seg))

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (midpoint-segment seg) 
  (make-point 
    (/ (+ (x-point (start-segment seg)) (x-point (end-segment seg))) 2)
    (/ (+ (y-point (start-segment seg)) (y-point (end-segment seg))) 2)))

(define seg (make-segment (make-point 2 3) (make-point 10 15))) 
(print-point (midpoint-segment seg)) 

; 

(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1: CONS" m))))
  dispatch)
(define (car z) (z 0))
(define (cdr z) (z 1))

; exercise 2.4
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))

; exercise 2.5
(define (cons x y)
  (* (expt 2 x) (expt 3 y)))
(define (car x)
  (depow x 2))
(define (cdr x)
  (depow x 3))

(define (depow x b) 
  (define (iter e)
    (if (= (remainder x (expt b e)) 0)
      (iter (+ e 1))
      (- e 1)))
  (iter 1))

(define test (cons 11 17)) 
(car test) 
(cdr test)

; exercise 2.6
(define zero (lambda (f) (lambda (x) x)))
(define one  (lambda (f) (lambda (x) (f x))))
(define two  (lambda (f) (lambda (x) (f (f x)))))
(define + )
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(((add-1 one) cube) 2)

(define (add a b) 
  (lambda (f) 
    (lambda (x) 
      ((a f) ((b f) x)))))

(((add two one) log) 2)



