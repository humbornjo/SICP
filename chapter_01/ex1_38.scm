;; Answer

(load "./ex1_37.scm")

(define expected 2.718)

(define result (+ 2 (cont-frac
                 (lambda (i) 1.0)
                 (lambda (i)
                   (if (= (remainder i 3) 2) (* (/ (+ i 1) 3) 2) 1))
                 10)))

(assert (< (abs (- expected result)) 0.001))
