;; Answer

(load "./eval_init_stream.scm")

(define fibs
  (cons-stream
    0
    (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

; The num of addition is the number of add-streams
; for any fib number other than the first two,
; num_add(n) = num_add(n-1) + num_add(n-2) + 1
;
; fib(3) = 1, num_add(3) = 0+1
; fib(4) = 2, num_add(4) = 1+0+1
; fib(5) = 3, num_add(5) = 1+2+1
;
; Which is greater than golden ratio exp
