;; Answer

(load "./ex3_05.scm")

; rand cant be a function, otherwise init will be reinit

(define (rand-update x) (random x))

(define random-init 1.0)
(define rand
  (let ((x random-init))
    (define (dispatch mode)
      (cond
        ((eq? mode 'generate) (set! x (rand-update x)) x)
        ((eq? mode 'reset) (lambda (new-val) (set! x new-val)))
        (else "undefined mode")))
    dispatch))

; (display (rand 'generate))
; ((rand 'reset) 1.0)
; (newline)
; (display (rand 'generate))
; (newline)
; (display (rand 'generate))
