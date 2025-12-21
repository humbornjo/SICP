;; Answer

(define (same-parity . x)
  (define (same-parity-list xx)
    (cond
      ((null? xx) xx)
      ((null? (cdr xx)) xx)
      (else
        (if
          (= (remainder (+ (car xx) (cadr xx)) 2) 0)
          (cons (car xx) (same-parity-list (cdr xx)))
          (same-parity-list (cons (car xx) (cdr (cdr xx))))))))
  (same-parity-list x))

(assert (equal? (list 1 3 5 7) (same-parity 1 2 3 4 5 6 7)))
(assert (equal? (list 2 4 6) (same-parity 2 3 4 5 6 7)))
