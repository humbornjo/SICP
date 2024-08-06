; try to find sqrt of 2
; eq to the val of x when x^2 -2 = 0
; g(x) = x^2 - 2
; f(x) = x - (x^2 - 2)/(2x) = 0.5*(x + 2/x)

(define dx 0.00001)
(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (cube x) (* x x x))
((deriv cube) 5)

