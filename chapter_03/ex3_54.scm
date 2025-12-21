;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_50.scm")

(define (add-streams s1 s2) (stream-map + s1 s2))

(define (mul-streams s1 s2) (stream-map * s1 s2))

(define factorials
  (cons-stream 1 (mul-streams (stream-cdr integers) factorials)))

(assert (eq? 120 (stream-ref factorials 4)))
