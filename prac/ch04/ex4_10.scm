;; triplet operator in c

(define (if? exp)
  (cond ((tagged-list? exp 'if) #t)
        ((and (not (null? cdr exp))
              (eq? (cadr exp) '?)
              (not (null? cddr exp))
              (not (null? cdddr exp))
              (eq? (cadddr exp) ':)))
        (else #f)))

(assert (if? '((eq? x y) ? (+ x y) : (* x y))))
