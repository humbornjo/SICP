;; Answer

(load "./eval_init.scm")
(load "./ex1_35.scm")

(define (iterative-improve ok next)
  (lambda (x)
    (if (ok x)
      x
      ((iterative-improve ok next) (next x)))))

(begin
  (define (sqrt x)
    (define (next xx)
      (* 0.5 (+ xx (/ x xx))))
    (define (ok xx)
      (< (abs (- x (square xx))) tolerance))
    ((iterative-improve ok next) x))

  (define expected 2.8284)

  (define result (sqrt 8))

  (assert (< (abs (- expected result)) 0.001)))

(begin
  (define (fixed-point f x)
    (define (ok xx)
      (< (abs (- xx (f xx))) tolerance))
    ((iterative-improve ok f) x))

  (define expected 0.7390851332)

  (define result (fixed-point cos 1.0))

  (assert (< (abs (- expected result)) 0.001)))

