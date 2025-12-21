;; Answer

(define (fringe items)
  (if (null? items)
    '()
    (if (pair? (car items))
      (append (fringe (car items)) (fringe (cdr items)))
      (cons (car items) (fringe (cdr items))))))

(define x (list (list 4 5) (list 1 2 3)))

(define expected (list 4 5 1 2 3))

(assert (equal? expected (fringe x)))
