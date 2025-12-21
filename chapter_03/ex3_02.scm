;; Answer

(define (make-monitored mf)
  (define call 0)
  (lambda (op)
    (cond
      ((eq? op 'how-many-calls?) call)
      (else (set! call (+ call 1)) (mf op)))))

(define s (make-monitored sqrt))

(assert (eq? 10 (s 100)))

(assert (eq? 20 (s 400)))

(assert (eq? 2 (s 'how-many-calls?)))
