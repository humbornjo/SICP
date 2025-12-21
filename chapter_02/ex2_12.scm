;; Answer

(load "./ex2_07.scm")

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c p)
  (let
    ((w (abs (* c (/ p 100.0)))))
    (make-interval (- c w) (+ c w))))

(define (percent i)
  (abs (* 100(/ (width i) (center i)))))

(begin
  (define i (make-center-percent 10 0.5))
  (define j (make-center-percent 10 0.4))

  (assert (percent i) 50.0)
  (assert (width i) 5.0)
  (assert (center i) 10.0)

  (assert (percent j) 40.0)
  (assert (width j) 4.0)
  (assert (center j) 10.0))
