;; Answer

(define (reverse x)
  (if (null? (cdr x))
    x
    (append (reverse (cdr x)) (list (car x)))))

(assert (equal? (list 25 16 9 4 1) (reverse (list 1 4 9 16 25))))
