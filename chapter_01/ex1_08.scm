; Newton’s method for cube roots is based on the fact that if y
; is an approximation to the cube root of x, then a better
; approximation is given by the value
;
; \frac{x/y^2+2y}{3}
;
; Use this formula to implement a cube-root procedure analogous
; to the square-root procedure. (In Section 1.3.4 we will see how
; to implement Newton’s method in general as an abstraction of
; these square-root and cube-root procedures.)

;; Answer

(load "./eval_init.scm")

(define (enough guess prev-guess)
  (if (> guess prev-guess)
    (< (- guess prev-guess) (* prev-guess 1e-2))
    (< (- prev-guess guess) (* guess 1e-2))))

(define (cube-iter guess x)
  (/ (+ (/ x (square guess)) (* 2 guess)) 3))

(define (cube-newton guess x)
  (define (iter guess prev-guess x)
    (if (enough guess prev-guess)
      guess
      (iter (cube-iter guess x) guess x)))
  (iter (cube-iter 1 x) 1 x))

(cube-newton 1 2)
