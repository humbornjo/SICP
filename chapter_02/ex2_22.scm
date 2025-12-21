;; Answer

(load "./eval_init.scm")

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons answer
                  (square (car things))))))
  (iter items nil))

; List in lisp is like [scalar, list] rather [list, scalar]

(assert (not (equal? (list 1 4 9 16) (square-list (list 1 2 3 4)))))
