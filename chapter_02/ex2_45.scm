;; Answer

(define (split bh1 bh2)
  (lambda (painter n)
    (if (= n 0)
      painter
      (let ((smaller ((split bh1 bh2) painter (- n 1))))
        (bh1 painter (bh2 smaller smaller))))))

