;; Answer

(load "./eval_init_newton.scm")
(load "./ex1_43.scm")

; *** funcking important

(define (smooth f)
  (lambda (x) (/ (+ (f (+ x dx)) (f x) (f (- x dx))) 3)))

(define (smoothing f n) ((repeated smooth n) f))

(define expected 4)

(define result ((smoothing square 10) 2))

(assert (< (abs (- expected result)) 0.001))
