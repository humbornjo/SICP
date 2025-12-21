;; Answer

(load "./ex1_35.scm")
(load "./eval_init_newton.scm")

(define (cubic a b c)
  ( lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(define expected -0.5698)

(define result (newtons-method (cubic 1 2 1) 1))

(assert (< (abs (- expected result)) 0.001))
