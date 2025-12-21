(load "eval_init.scm")

(define (expand-clauses clauses)
  (if (null? clauses)
    false
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (begin
        (if (cond-else-clause? first)
          ; in else clause
          (if (null? rest)
            (sequence->exp (cond-actions first))
            (error "ELSE clause isn't last: COND->IF" clauses))
          ; <condition> '=> <exp> | <condition> <exp>
          (make-if (cond-predicate first)
                   (if (eq? '=> (cadr first))
                     (list (caddr first) (cond-predicate first))
                     (sequence->exp (cond-actions first)))
                   (expand-clauses rest)))))))

;; main

(assert (eq? 2
             (eval (expand-clauses
                     '(((assoc 'b '((a 1) (b 2))) => cadr) (else false))))))
