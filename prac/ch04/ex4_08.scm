(define (named-let? expr) (and (let? expr) (symbol? (cadr expr))))

(define (let->combination exp)
  (if (named-let? exp) 
    (let ((func (cadr exp))
          (clauses (caddr exp))
          (body (cadddr exp)))
      (let ((vars (map car clauses))
            (vals (map cadr clauses)))
        (sequence->exp
          (list (make-definition func vars body) (cons func vals)))))
    (let ((clauses (cadr exp))
          (body (caddr exp)))
      (let ((vars (map car clauses))
            (vals (map cadr clauses)))
        (cons (make-lambda vars body) vals)))))

(display (let->combination '(let a ((k 10)) (+ 1 a k))))
