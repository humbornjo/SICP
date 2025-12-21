;; Answer

(load "./eval_init.scm")

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

(define test (cons 2 3))

(assert (eq? 2 (car test)))

(assert (eq? 3 (cdr test)))
