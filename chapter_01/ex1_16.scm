;; Answer

(define (fast-expt b n)
  (define (iter _a _b _n)
    (cond ((= _n 0) _a)
          ((even? _n) (iter _a (* _b _b) (/ _n 2)))
          (else (iter (* _a _b) _b (- _n 1)))))
  (iter 1 b n))

(assert (eq? 1024 (fast-expt 2 10)))
