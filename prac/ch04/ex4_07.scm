(load "eval_init.scm")

(define (let*->nested-lets exp)
  (define (inner clauses body)
    (if (null? clauses)
      (sequence->exp body)
      (make-let (list (car clauses)) (inner (cdr clauses) body))))
  (inner (cadr exp) (cddr exp)))

;; main

(assert (eq? 7
             (eval
               (let*->nested-lets '(let* ((x 1) (y (+ x 2)) (z (+ y 3))) (+ x z))))))

;; * Explain how a let* expression can be rewritten as a set of nested let expressions

;; - Every let will be derived into a lambda with params and then precedure call, thus
;;   with an env created, which is extended by the params.
;;   In short, each let is called with an env created, enclosing the env of the previous
;;   one. Make it handy to build a nested let expression.


;; * If we have already implemented let (ex 4.6) and we want to extend the evaluator
;;   to handle let*, is it sufficient to add a clause to eval whose action is
;;
;;       (eval (let*->nested-lets exp) env)
;;
;;   or must we explicitly expand let* in terms of non-derived expressions?

;; - It is sufficient.
