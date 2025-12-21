;; Answer

(define (deep-reverse x)
  (if (null? (cdr x))
    (if (pair? (car x))
      (list (deep-reverse (car x)))
      x)
    (if (pair? (car x))
      (append (deep-reverse (cdr x)) (list (deep-reverse (car x))))
      (append (deep-reverse (cdr x)) (list (car x))))))

(define x (list (list 1 (list 10 11 12)) (list 3 4)))

(define expected (list (list 4 3) (list (list 12 11 10) 1)))

(assert (equal? expected (deep-reverse x)))
