;; Answer

(load "./eval_init.scm")

(define (miller-rabin n)
  (miller-rabin-test 2 n))

(define (miller-rabin-test a n)
  (cond ((= a n) true)
        ((= (expmod a (- n 1) n) 1) (miller-rabin-test (+ a 1) n))
        (else false)))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (let ((x (expmod base (/ exp 2) m)))
           (cond ((or (= x 1) (= x (- m 1)))
                  (remainder (square x) m))
                 ((= (remainder (square x) m) 1)
                  0)
                 (else (remainder (square x) m)))))
        (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

(assert (eq? false (miller-rabin 561)))
(assert (eq? true (miller-rabin 43)))
