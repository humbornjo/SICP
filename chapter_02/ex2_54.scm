;; Answer

(define (equal? l1 l2)
  (cond
    ((and (null? l1) (null? l2)) #t)
    ((and (pair? l1) (pair? l2))
     (and (eq? (car l1) (car l2)) (equal? (cdr l1) (cdr l2))))
    (else #f)))

(assert (equal? '(this is a list) '(this is a list)))
(assert (not (equal? '(this is a list) '(this (is a) list))))
