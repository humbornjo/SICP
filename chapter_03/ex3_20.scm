;; Answer

; http://community.schemewiki.org/?sicp-ex-3.20

(define x (cons 1 2))
(define z (cons x x))

(set-car! (cdr z) 17)
(assert (eq? 17 (car x)))

;         +-----+
;     +--+|-+   |
; z   |* |* |   |
;     +|-+--+   |
;      |        |
;     +--+--+   |
; x   |1 | 2|   |
;     +--+--+   |
;      |        |
;      +--------+
