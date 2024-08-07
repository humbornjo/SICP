(define (halve x) (/ x 2))
(define (double x) (+ x x))
(define (even x) (= (remainder x 2) 0))

; exercise 1.19
(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a 
                   b
                   (+ (* p p) (* q q)) ; compute p′
                   (+ (* 2 p q) (* q q)) ; compute q′
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(fib 10)

; exercise 1.16
(define (fast_expt b n)
  (define (iter _a _b _n)
    (cond ((= _n 0) _a)
          ((even _n) (iter _a (* _b _b) (/ _n 2)))
          (else (iter (* _a _b) _b (- _n 1)))))
  (iter 1 b n))

(fast_expt 2 10)
(fast_expt 3 9)


; exercise 1.17
(define (* a b)
  (cond ((= b 0) 0)
        ((even b) (double (* a (halve b))))
        (else (+ a (* a (- b 1))))))

(* 3 4)

; exercise 1.18
(define (* a b)
  (define (iter _sum _a _b) 
    (cond ((= _b 0) _sum)
          ((even _b) (iter _sum (double _a) (halve _b)))
          (else (iter (+ _a _sum) a (- _b 1)))))
  (iter 0 a b))

(* 3 4)

