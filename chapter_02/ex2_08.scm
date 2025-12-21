;; Answer

(load "./ex2_07.scm")

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y))
                 (- (upper-bound x) (upper-bound y))))

(define test1 (sub-interval (make-interval 1 2) (make-interval 2 3)))

(assert (lower-bound test1) -1)

(assert (upper-bound test1) -1)
