;; Answer

(load "./eval_init_stream.scm")

(define (smooth s)
  (scale-stream
    (add-streams s (cons-stream 0 s))
    0.5))

(define (make-zero-crossings input-stream)
  (stream-map sign-change-detetor
              (smooth input-stream)
              (cons-stream 0 (smooth input-stream))))

