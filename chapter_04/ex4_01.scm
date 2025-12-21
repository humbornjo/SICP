(load "eval_init.scm")

(define (list-of-values-l2r exps env)
  (if (no-operands? exps)
    '()
    (let ((left (eval (first-operand exps))))
      (cons left (list-of-values-l2r (rest-operands exps) env)))))

(define (list-of-values-r2l exps env)
  (if (no-operands? exps)
    '()
    (let ((right (list-of-values-r2l (rest-operands exps) env)))
      (cons (eval (first-operand exps)) right))))

;; main

(list-of-values-l2r
  '((define a 10)
    (assert (eq? (+ a 10) 20))
    (define a 5))
  '())

(list-of-values-r2l
  '((define a 10)
    (assert (eq? (+ a 10) 15))
    (define a 5))
  '())
