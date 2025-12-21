;; Answer

; a.

(define (cont-frac n d k)
  (define (iter i)
    (if (= i k)
      (/ (n i) (d i))
      (/ (n i) (+ (d i) (iter  (+ i 1))))))
  (iter 1))

(begin
  (define expected (/ 1 1.618))
  (define result (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10))
  (assert (< (abs (- expected result)) 0.001)))

; b.

(define (cont-frac n d k)
  (define (iter res i)
    (if (= i 0)
      res
      (iter (/ (n i) (+ (d i) res)) (- i 1))))
  (iter (/ (n k) (d k)) (- k 1)))

(begin
  (define expected (/ 1 1.618))
  (define result (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10))
  (assert (< (abs (- expected result)) 0.001)))

