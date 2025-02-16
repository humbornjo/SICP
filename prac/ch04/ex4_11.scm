(define (make-frame variables values) (cons 'pairs (map cons variables values)))
(define (frame-variables frame) (map car (cdr frame)))
(define (frame-values frame) (map cdr (cdr frame)))
(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val) (cdr frame))))


;; main 

(define frame (make-frame (list 1 2 3) (list 9 8 7)))
(assert (equal? (frame-variables frame) (list 1 2 3)))
(assert (equal? (frame-values frame) (list 9 8 7)))

