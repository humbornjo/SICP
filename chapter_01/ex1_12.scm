;; Answer

(define (pascal r c)
  (cond ((> c r) 0)
        ((= c r) 1)
        ((= c 0) 1)
        (else (+ (pascal (- r 1) c) (pascal (- r 1) (- c 1))))))

(assert (eq? 1 (pascal 4 0)))
(assert (eq? 4 (pascal 4 1)))
(assert (eq? 6 (pascal 4 2)))

