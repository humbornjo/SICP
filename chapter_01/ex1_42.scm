;; Answer

(load "./eval_init.scm")
(load "./ex1_41.scm")

(define (compose f g) (lambda (x) (f (g x)) ))

(define expected 49)

(define result ((compose square inc) 6))

(assert (eq? expected result))
