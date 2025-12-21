;; Answer

(load "./eval_init.scm")

(define (make-rat n d)
  (let ((g (gcd n d)))
    (if (< d 0)
      (cons (/ (* -1 n) g) (/ (* -1 d) g))
      (cons (/ n g) (/ d g)))))

(begin
  (define rat (make-rat 1 -2))
  (assert (eq? -1 (numer rat)))
  (assert (eq? 2 (denom rat))))

(begin
  (define rat (make-rat -1 2))
  (assert (eq? -1 (numer rat)))
  (assert (eq? 2 (denom rat))))

(begin
  (define rat (make-rat -1 -2))
  (assert (eq? 1 (numer rat)))
  (assert (eq? 2 (denom rat))))
