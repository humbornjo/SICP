;; Answer

(load "./ex1_37.scm")

(define (tan-cf x k)
  (cont-frac
    (lambda (i)
      (if (= i 1) x (- (* x x))))
    (lambda (i) (- (* i 2) 1))
    k))

(define expected 1.5574)

(define result (* 1.0 (tan-cf 1 10)))

(assert (< (abs (- expected result)) 0.001))
