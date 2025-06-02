(load "eval_init.scm")

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

;; main

(assert 
  (= 55
     (eval 
       `(begin 
          (define (fib n)
            ,(let->combination
               '(let fib-iter 
                  ((a 1)
                   (b 0)
                   (count n))
                  (if (= count 0)
                    b
                    (fib-iter (+ a b) a (- count 1))))))
          (fib 10)
          ))
     ))
