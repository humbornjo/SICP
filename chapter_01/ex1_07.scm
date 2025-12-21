; The good-enough? test used in computing square roots will not
; be very effective for finding the square roots of very small
; numbers. Also, in real computers, arithmetic operations are
; almost always performed with limited precision. This makes our
; test inadequate for very large numbers. Explain these
; statements, with examples showing how the test fails for small
; and large numbers. An alternative strategy for implementing
; good-enough? is to watch how guess changes from one iteration
; to the next and to stop when the change is a very small
; fraction of the guess. Design a square-root procedure that uses
; this kind of end test. Does this work better for small and large
; numbers?

;; Answer

(load "./eval_init.scm")

(define (enough guess prev-guess)
    (if (> guess prev-guess)
      (< (- guess prev-guess) (* prev-guess 1e-2))
      (< (- prev-guess guess) (* guess 1e-2))))

(define (sqrt-newton guess x)
  (define (iter guess prev-guess x)
    (if (enough guess prev-guess)
      guess
      (iter (sqrt-iter guess x) guess x)))
  (iter (sqrt-iter 1 x) 1 x))

(sqrt-newton 1 2.33e100)
(sqrt-newton 1 2.33e-100)

