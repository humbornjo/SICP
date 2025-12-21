;; Answer

(import (chicken time))

(load "./ex1_21.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (cpu-time)))
(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (cpu-time) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes from to)
  (define (iter n)
    (cond ((< n to)
           (timed-prime-test n)
           (iter (+ n 1)))))
  (iter from))
