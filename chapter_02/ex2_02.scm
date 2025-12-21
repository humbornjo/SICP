;; Answer

(load "./eval_init.scm")

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ", ")
  (display (y-point p))
  (display ")"))

(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment seg) (car seg))
(define (end-segment seg) (cdr seg))

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (midpoint-segment seg)
  (make-point
    (/ (+ (x-point (start-segment seg)) (x-point (end-segment seg))) 2)
    (/ (+ (y-point (start-segment seg)) (y-point (end-segment seg))) 2)))

(define seg (make-segment (make-point 2 3) (make-point 10 15)))

(define point (midpoint-segment seg))

(assert (eq? 6 (x-point point)))

(assert (eq? 9 (y-point point)))

