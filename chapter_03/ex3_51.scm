;; Answer

(load "./eval_init_stream.scm")

(define (show x)
  (display-line x)
  x)

(define x
  (stream-map show
              (stream-enumerate-interval 0 10)))

; (display "ref 5: ")
; (display (stream-ref x 5))
; (newline)
; (display "ref 7: ")
; (display (stream-ref x 7))
