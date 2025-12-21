;; Answer

(load "./eval_init_stream.scm")

(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix)))

; (expand 1 7 10): 1, 4, 2, 8, 5, 7, loop
