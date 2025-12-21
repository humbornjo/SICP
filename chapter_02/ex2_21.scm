;; Answer

(load "./eval_init.scm")

(define (square-list items)
  (if (null? items)
    '()
    (cons (square (car items)) (square-list (cdr items)))))
(square-list (list 1 2 3 4))

(define (square-list items)
  (map (lambda (x) (* x x)) items))

(assert (equal? (list 1 4 9 16) (square-list (list 1 2 3 4))))
