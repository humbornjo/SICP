;; Answer

(load "./eval_init_stream.scm")

(define (pairs s t)
  (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                t)
    (pairs (stream-cdr s) (stream-cdr t))))

; there is no delay, the pairs will be forever evaluated
