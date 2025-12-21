;; Answer

(load "./eval_init_stream.scm")

(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)

(define (sqrt-stream x)
  (cons-stream
    1.0
    (stream-map (lambda (guess) (sqrt-improve guess x))
                (sqrt-stream x))))

; Each time we call (sqrt-stream x), it create a env point to the
; global env however, when refer to guesses, always the obj in
; the same env (if memo is enabled) that says, louis's will keep
; construct the same stream each time call stream-cdr.
