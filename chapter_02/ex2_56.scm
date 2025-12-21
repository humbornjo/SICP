;; Answer

(define (exponentiation? x) (and (pair? x) (eq? (car x) '**)))

(define (base p) (cadr p))

(define (exponent p) (caddr p))

(define (make-exponentiation m1 m2) (list '** m1 m2))
