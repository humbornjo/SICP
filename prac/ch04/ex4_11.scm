;; env -> { pairs, enclosing_env }

(define (make-frame variables values)
  (cons 'pairs (map cons variables values)))
(define (frame-variables frame) (map car (cdr frame)))
(define (frame-values frame) (map cdr (cdr frame)))
(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val) (cdr frame))))

(assert (make-frame (list 1 2 3) (list 9 8 7)) 
        (list (cons 1 9) (cons 2 8) (cons 3 7)))
