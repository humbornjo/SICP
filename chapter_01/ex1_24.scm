;; Answer

(import (chicken time))
(import (chicken random))

(load "./eval_init.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
           (square (expmod base (/ exp 2) m))
           m))
        (else
          (remainder
            (* base (expmod base (- exp 1) m))
            m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (pseudo-random-integer (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
    (report-prime (- (cpu-time) start-time))))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (cpu-time)))
; (define (start-prime-test n start-time)
;   (if (prime? n)
;     (report-prime (- (cpu-time) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes from to)
  (define (iter n)
    (cond ((< n to)
           (timed-prime-test n)
           (iter (+ n 1)))))
  (iter from))
