; try to find sqrt of 2
; eq to the val of x when x^2 -2 = 0
; g(x) = x^2 - 2
; f(x) = x - (x^2 - 2)/(2x) = 0.5*(x + 2/x)

(define dx 0.00001)
(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (cube x) (* x x x))
((deriv cube) 5)


(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define dx 0.00001)

(define (cube x) (* x x x))
((deriv cube) 5)

(define (newton-transform g)
  (lambda (x) (- x (/ (g x) ((deriv g) x)))))
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define (sqrt x)
  (newtons-method
    (lambda (y) 
      (- (square y) x)) 
    1.0))

; exercise 1.40
(define (cubic a b c)
  ( lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

; exercise 1.41
(define (double f) 
  (lambda (x) (f (f x))))
  
(define (inc x) (+ 1 x))
(((double (double double)) inc) 5)


; exercise 1.42
(define (compose f g) 
  (lambda (x) (f (g x)) ))

((compose square inc) 6)

; exercise 1.43
(define (repeated f n)
  (if (= n 0)
    (lambda (x) x)
    (compose f (repeated f (- n 1)))))

((repeated square 2) 5) 

; exercise 1.44 *** funcking important
(define (smooth f)
  (lambda (x) (/ (+ (f (+ x dx)) (f x) (f (- x dx))) 3)))

(define (smoothing f n)
  ((repeated smooth n) f))
  
((smoothing square 10) 2)

; exercise 1.45
(define tolerance 0.00001)
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

(define (average x y) 
  (* 0.5 (+ x y)))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (log2 x) (/ (log x) (log 2)))

(define (nth x n)
  (if (= n 0)
    1
    (* x (nth x (- n 1)))))

(define (nthrt x n)
  (fixed-point 
    ((repeated 
       average-damp 
       (floor (log2 n))) 
     (lambda (y) (/ x (nth y (- n 1))))) 
    1))

(nthrt 81 3)

; exercise 1.46
(define (iterative-improve ok next)
  (lambda (x) 
    (if (ok x) 
      x
      ((iterative-improve ok next) (next x)))))

(begin
 (newline)
 (display "sqrt impl")
 (define (sqrt x)
   (define (next xx) 
     (* 0.5 (+ xx (/ x xx))))
   (define (ok xx) 
     (< (abs (- x (square xx))) tolerance))
   ((iterative-improve ok next) x))

 (newline)
 (sqrt 8))

(begin
  (newline)
  (display "fixed-point impl")
  (define (fixed-point f x)
    (define (ok xx) 
      (< (abs (- xx (f xx))) tolerance))
    ((iterative-improve ok f) x))

  (newline)
  (fixed-point cos 1.0))
