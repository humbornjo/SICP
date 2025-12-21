;; Answer

(load "./eval_init.scm")

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))))

(assert (equal? (list 34) (last-pair (list 23 72 149 34))))
