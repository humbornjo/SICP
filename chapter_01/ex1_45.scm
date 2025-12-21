;; Answer

(load "./eval_init_newton.scm")
(load "./ex1_35.scm")
(load "./ex1_43.scm")

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
    1.0))

(define expected 4.3267)

(define result (nthrt 81 3))

(assert (< (abs (- expected result)) 0.001))
