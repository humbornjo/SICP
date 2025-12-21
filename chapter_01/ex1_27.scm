;; Answer

(load "./ex1_24.scm")

(define (fermat-test-complete n)
  (define (try-it a)
    (cond ((= a n) #t)
          ((= (expmod a n n) a) (try-it (+ 1 a)))
          (else #f)))
  (try-it 2))

(assert (eq? true (fermat-test-complete 561)))
(assert (eq? true (fermat-test-complete 1105)))
(assert (eq? true (fermat-test-complete 1729)))
(assert (eq? true (fermat-test-complete 2465)))
(assert (eq? true (fermat-test-complete 2821)))
(assert (eq? true (fermat-test-complete 6601)))
(assert (eq? false (fermat-test-complete 6602)))
(assert (eq? false (fermat-test-complete 85230658)))
