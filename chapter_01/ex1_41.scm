;; Answer

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x) (+ 1 x))

(define expected 21)

(define result (((double (double double)) inc) 5))

(assert (eq? expected result))
