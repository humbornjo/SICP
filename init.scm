(define nil '())

(define true #t)
(define false #f)

(define (double x) (+ x x))
(define (halve x) (/ x 2))
(define (average x y) (/ (+ x y) 2))

(define (square x) (* x x))
(define (cube x) (* x x x))

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
