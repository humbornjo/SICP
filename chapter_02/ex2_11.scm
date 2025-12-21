;; Answer

(load "./ex2_07.scm")

(define (pos-interval x)
  (and (> (upper-bound x) 0) (> (lower-bound x) 0)))

(define (neg-interval x)
  (and (< (upper-bound x) 0) (< (lower-bound x) 0)))

(define (span-interval x)
  (and (<= (lower-bound x) 0) (<= 0 (upper-bound x))))

(define (mul-interval x y)
  (let
    ((lox (lower-bound x))
     (hix (upper-bound x))
     (loy (lower-bound y))
     (hiy (upper-bound y)))
    (cond
      ((and (pos-interval x) (pos-interval y)) (make-interval (* lox loy) (* hix hiy)))
      ((and (pos-interval x) (neg-interval y)) (make-interval (* hix loy) (* lox hiy)))
      ((and (pos-interval x) (span-interval y)) (make-interval (* hix loy) (* hix hiy)))
      ((and (neg-interval x) (pos-interval y)) (make-interval (* lox hiy) (* hix loy)))
      ((and (neg-interval x) (neg-interval y)) (make-interval (* hix hiy) (* lox loy)))
      ((and (neg-interval x) (span-interval y)) (make-interval (* lox hiy) (* lox loy)))
      ((and (span-interval x) (pos-interval y)) (make-interval (* lox hiy) (* hix hiy)))
      ((and (span-interval x) (neg-interval y)) (make-interval (* hix loy) (* lox loy)))
      (else
        (let
          ((p1 (* lox loy))
           (p2 (* lox hiy))
           (p3 (* hix loy))
           (p4 (* hix hiy)))
          (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4)))))))

(define x1 (make-interval 2 7))
(define x2 (make-interval -1 1))
(define x3 (make-interval -10 -7))

(begin
  (define test (mul-interval x1 x2))
  (assert (lower-bound test) -2)
  (assert (upper-bound test) 7))

(begin
  (define test (mul-interval x1 x3))
  (assert (lower-bound test) -49)
  (assert (upper-bound test) -20))

(begin
  (define test (mul-interval x2 x3))
  (assert (lower-bound test) -7)
  (assert (upper-bound test) 10))
