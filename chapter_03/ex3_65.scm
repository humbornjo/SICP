;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_55.scm")

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(define (euler-transform s)
  (let ((s0 (stream-ref s 0)) ; Sn 1
        (s1 (stream-ref s 1)) ; Sn
        (s2 (stream-ref s 2))) ; Sn+1
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(define (log2-summends n)
    (cons-stream
      (/ 1.0 n)
      (scale-stream (log2-summends (+ 1 n)) -1)))

(define log2-stream
  (partial-sum (log2-summends 1)))

(define expected 0.69315)

(define result (stream-limit (accelerated-sequence euler-transform log2-stream) 0.00000001))

(assert (< (abs (- expected result))))
