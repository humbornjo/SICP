;; Answer

(define (product term a next b)
  (if (> a b)
    1
    (* (term a)
       (product term (next a) next b))))

(define (product term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (* (term a) result))))
  (iter a 1))

(define (factorial n)
  (define (next x) (+ x 1))
  (define (term x) x)
  (product term 1 next n))

(assert (eq? 120 (factorial 5)))
