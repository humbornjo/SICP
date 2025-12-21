;; Answer

(define x (list 'a 'b))
(define y (list 'c 'd))

(define z (append x y))

(define (append! x y)
  (set-cdr! (last-pair x) y) x)

(define (last-pair x)
  (if (null? (cdr x)) x (last-pair (cdr x))))

(define w (append! x y))

(assert (equal? (list 'b 'c 'd) (cdr x)))
