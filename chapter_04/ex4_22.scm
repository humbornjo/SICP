;; main

(load "eval_init.scm")
(load "eval_impl_separate.scm")

(define (let->combination exp)
  (let ((clauses (cadr exp))
        (body (caddr exp)))
    (let ((vars (map car clauses))
          (vals (map cadr clauses)))
      (cons (make-lambda vars (list body)) vals))))

(define (analyze-let exp)
  (analyze (let->combination exp)))

(assert (eq? 20 ((analyze '(let ((x 2) (y 10)) (* x y))) the-global-environment)))
