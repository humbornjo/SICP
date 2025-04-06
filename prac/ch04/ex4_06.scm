(load "init_util.scm")


(define (let->combination exp)
  (let ((clauses (cadr exp))
        (body (caddr exp)))
    (let ((vars (map car clauses))
          (vals (map cadr clauses)))
      (cons (make-lambda vars (list body)) vals))))

;; main

(assert (eq? (eval 
               (let->combination '(let ((x 1) (y 2)) (+ x y)))
               )
             3))
