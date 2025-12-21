;; Answer

(load "./eval_init.scm")

(define (repeated f n)
  (if (= n 0)
    (lambda (x) x)
    (compose f (repeated f (- n 1)))))


(define expected 625)

(define result ((repeated square 2) 5))

(assert (eq? expected result))
