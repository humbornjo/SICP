;; Answer

(load "./ex1_35.scm")

(define (vfixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    ; (newline)
    ; (display (* 1.0 guess))
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))


(define result (* 1.0 (vfixed-point (lambda (x) (/ (log 1000) (log x))) 10)))

(define expected 4.556)

(assert (< (abs (- expected result)) 0.001))
