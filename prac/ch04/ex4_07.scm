(define (let*? exp) (tagged-list? exp 'let*))

(define (make-let seq body) (list 'let seq body))

(define (let*->nested-lets exp)
  (define (inner clauses body)
    (if (null? clauses)
      (sequence->exp body)
      (make-let (list (car clauses)) (list (inner (cdr clauses) body)))))
  (inner (cadr exp) (cddr exp)))

(eval (let*->nested-lets '(let* ((x 1) (y 2)) x y)))

;; The good part about derived form is that the env is easy to track.
