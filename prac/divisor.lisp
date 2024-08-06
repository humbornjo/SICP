; exercise 1.21
(define (smallest-divisor n) (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b) (= (remainder b a) 0))

(define (prime? n) (= n (smallest-divisor n)))

(smallest-divisor 199)
(smallest-divisor 1999)
(smallest-divisor 19999)


; exercise 1.22 + 1.23
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (n_prime from to)
  (define (iter n) 
    ;; https://stackoverflow.com/questions/11263359/is-there-a-possibility-of-multiple-statements-inside-a-conditional-statements-b @Ross Larson
    ;; (cond ((< n to) (timed-prime-test n) (iter (+ n 2))))) # equal to below
    (cond ((< n to) 
           (begin 
             (timed-prime-test n) 
             (iter (+ n 2))))))
  (iter (if (odd? from) from (+ from 1))))

 (n_prime 1000000000 1000000022)       ; 1e9 
 (n_prime 100000000000 100000000058)   ; 1e11 

; exercise 1.24
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
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
    (report-prime (- (runtime) start-time))))

(n_prime 1000000000 1000000022)       ; 1e9 
(n_prime 100000000000 100000000058)   ; 1e11 

; exercise 1.27: Carmichael numbers - 561, 1105, 1729, 2465, 2821, and 6601

(define (fermat-test-complete n)
  (define (try-it a)
    (cond ((= a n) #t)
          ((= (expmod a n n) a) (try-it (+ 1 a)))
          (else #f)))
  (try-it 2))
(begin (newline)
  (display (fermat-test-complete 561))(newline)
  (display (fermat-test-complete 1105))(newline)
  (display (fermat-test-complete 1729))(newline)
  (display (fermat-test-complete 2465))(newline)
  (display (fermat-test-complete 2821))(newline)
  (display (fermat-test-complete 6601))(newline)
  (display (fermat-test-complete 6602))(newline)
  (display (fermat-test-complete 85230658)))

; exercise 1.28
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
           (cond ((or (= x 1) (= x (- m 1))) (remainder (square x) m))
                 ((= (remainder (square x) m) 1) 0))
           (else (remainder (square x) m)))) 
        (else 
          (remainder (* base (expmod base (- exp 1) m)) 
                     m)))) 

(miller-rabin 561)
(miller-rabin 43)
