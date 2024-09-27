; WARNING: there is a native delay and force impl in csi, self defined delay and force should be put at the top

(define true #t)
(define false #f)
(define nil '())

(define (square x)
  (* x x))

(define (prime? x) 
  (define (test divisor) 
    (cond ((> (* divisor divisor) x) true) 
          ((= 0 (remainder x divisor)) false) 
          (else (test (+ divisor 1))))) 
  (test 2))

(define (memo-proc proc)
  (let ((already-run? false) (result false))
    (lambda ()
      (if (not already-run?)
        (begin (set! result proc)
               (set! already-run? true)
               result)
        result))))

;;; in scheme lisp, all the args will be evaluated instantly
;;; the only way to implement `delay` is using macro
;;; the definition in book is but a psudo code snippet
;;; use define-syntax to utilize macro in csi

;; (define (cons-stream a b) 
;;   (cons a (delay b)))
;; (define delay memo-proc)
;; (define-syntax delay (syntax-rules () ((delay proc) (lambda () proc))))
(define-syntax delay (syntax-rules () ((delay proc) ((memo-proc (lambda () proc))))))
(define-syntax cons-stream (syntax-rules () ((cons-stream a b) (cons a (delay b)))))
(define (force delayed-object) (delayed-object))

(define stream-null? null?)
(define the-empty-stream nil)

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc s)
  (if (stream-null? s)
    the-empty-stream
    (cons-stream (proc (stream-car s))
                 (stream-map proc (stream-cdr s)))))
(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin (proc (stream-car s))
           (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x) (newline) (display x))


(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter
                        pred
                        (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-filterprime? stream)
  (stream-filter prime? stream))

(display "the prime after 10007 is: ")
(display (stream-car
  (stream-cdr
    (stream-filterprime?
                   (stream-enumerate-interval
                     10000 10013)))))
(newline)

; ex 3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
    the-empty-stream
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map
             (cons proc (map stream-cdr argstreams))))))

; ex 3.51
(define (show x)
  (display-line x)
  x)

(display "*ex 3.51")
(newline)
(display "show enumerate -")
(define x
  (stream-map show
              (stream-enumerate-interval 0 10)))
(newline)
(display "ref 5: ")
(display (stream-ref x 5))
(newline)
(display "ref 7: ")
(display (stream-ref x 7))
(newline) 

; ex 3.52
(newline) 
(display "*ex 3.52")
(newline) 
(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)
(define seq
  (stream-map accum
              (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0))
                 seq))
(newline) 
(display "ref 7: ")
(display (stream-ref y 7))
(display-stream z)
(newline) 

; Infinite Streams
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))
(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))

(newline)
(display "the 100th number cant div by 7: ")
(display (stream-ref no-sevens 100))
(newline)

(define (fibgen a b) (cons-stream a (fibgen b (+ a b))))
(define fibs (fibgen 0 1))

(define (sieve stream)
  (cons-stream
    (stream-car stream)
    (sieve (stream-filter
             (lambda (x)
               (not (divisible? x (stream-car stream))))
             (stream-cdr stream)))))
(define primes (sieve (integers-starting-from 2)))
(display "the 50th prime is: ")
(display (stream-ref primes 50))

;; (define ss (integers-starting-from 2))
;; (define (mprime ss) 
;;   (cons-stream 
;;     (stream-car ss)
;;     (mprime 
;;       (stream-filter 
;;         (lambda (x) 
;;           (not (divisible? x (stream-car ss))))
;;         (stream-cdr ss)))))
;;
;; (newline)
;; (display "my 50th prime is: ")
;; (display (stream-ref (mprime ss) 50))

(define ones (cons-stream 1 ones))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define integers
  (cons-stream 1 (add-streams ones integers)))
(newline)
(display "the 50th integer is: ")
(display (stream-ref integers 50))

(define fibs
  (cons-stream
    0
    (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))
(define double (cons-stream 1 (scale-stream double 2)))

(define primes
  (cons-stream
    2
    (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
          ((divisible? n (stream-car ps)) false)
          (else (iter (stream-cdr ps)))))
  (iter primes))

; ex 3.53
;; 1, 2, 4, 8, 2^n
(newline) 

; ex 3.54
(define (mul-streams s1 s2) (stream-map * s1 s2))
(define factorials
  (cons-stream 1 (mul-streams (stream-cdr integers) factorials)))

(newline) 
(display "*ex 3.54")
(newline) 
(display "the 5th factorial 5! is: ")
(display (stream-ref factorials 4)) 
(newline) 

; ex 3.55
;; my answer
(define (partial-sum s) 
  (define (iter ss)
    (cons-stream 
      (stream-car ss) 
      (iter (add-streams s (stream-cdr ss)))))
  (iter s))

;; http://community.schemewiki.org/?sicp-ex-3.55 @huntzhan
;; what a beautiful def
(define (partial-sums s) 
  (add-streams s (cons-stream 0 (partial-sums s))))

(newline) 
(display "*ex 3.55")
(newline)
(display "the 5th add sum is: ")
(display (stream-ref (partial-sum integers) 4))
(newline) 

; ex 3.56
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2)))
            (cond ((< s1car s2car)
                   (cons-stream
                     s1car
                     (merge (stream-cdr s1) s2)))
                  ((> s1car s2car)
                   (cons-stream
                     s2car
                     (merge s1 (stream-cdr s2))))
                  (else
                    (cons-stream
                      s1car
                      (merge (stream-cdr s1)
                             (stream-cdr s2)))))))))

(define S (cons-stream 1 (merge (scale-stream S 2) (merge (scale-stream S 3) (scale-stream S 5)))))

(newline) 
(display "*ex 3.56")
(newline)
(display "the 6th hamming number is: ")
(display (stream-ref S 5))
(newline)

; ex 3.57
;; (define fibs
;;   (cons-stream
;;     0
;;     (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

;; the num of addition is the number of add-streams
;; for any fib number other than the first two, 
;; num_add(n) = num_add(n-1) + num_add(n-2) + 1
;; fib(3) = 1, num_add(3) = 0+1
;; fib(4) = 2, num_add(4) = 1+0+1
;; fib(5) = 3, num_add(5) = 1+2+1
;; which is greater than golden ratio exp


; ex 3.58
;; (define (expand num den radix)
;;   (cons-stream
;;     (quotient (* num radix) den)
;;     (expand (remainder (* num radix) den) den radix)))

;; (expand 1 7 10): 1, 4, 2, 8, 5, 7, loop

; ec 3.59
;; a
(define (integrate-series s) 
  (stream-map / s integers))

;; b
(define exp-series (cons-stream 1 (integrate-series exp-series)))

(define cosine-series (cons-stream 1 (scale-stream sine-series -1)))
(define sine-series (cons-stream 0 cosine-series))

; ex 3.60
(define (mul-series s1 s2) 
  (cons-stream (* (stream-car s1) (stream-car s2)) 
               (add-streams 
                 (scale-stream (stream-cdr s2) (stream-car s1)) 
                 (mul-series (stream-cdr s1) s2))))

; ex 3.61
(define (invert-unit-series s)
  (cons-stream 
    1 
    (scale-stream 
      (mul-series (stream-cdr s) (invert-unit-series s)) 
      -1)))

; ex 3.62
(define (div-series s1 s2)
  (mul-series s1 (invert-unit-series s2)))

(define tangent-series (div-series sine-series cosine-series))


; Exploiting the Stream Paradigm
(define (average x y) (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)
;; (display-stream (sqrt-stream 2))

(define (pi-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))
(define pi-stream
  (scale-stream (partial-sums (pi-summands 1)) 4))
;; (display-stream pi-stream)


(define (euler-transform s)
  (let ((s0 (stream-ref s 0)) ; Sn 1
        (s1 (stream-ref s 1)) ; Sn
        (s2 (stream-ref s 2))) ; Sn+1
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))
;; (display-stream (euler-transform pi-stream))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))
(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))
;; (display-stream (accelerated-sequence euler-transform pi-stream))

; ex 3.63
(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)

(define (sqrt-stream x)
  (cons-stream 
    1.0 
    (stream-map (lambda (guess) (sqrt-improve guess x))
      (sqrt-stream x))))

;; each time we call (sqrt-stream x), it create a env point to the global env
;; however, when refer to guesses, always the obj in the same env (if memo is enabled)
;; that says, louis's will keep construct the same stream each time call stream-cdr

; ex 3.64
(define (stream-limit s tolerance)
  (let 
    ((s0 (stream-car s))
     (s1 (stream-car (stream-cdr s))))
    (if (< (abs (- s0 s1)) tolerance)
      s1
      (stream-limit (stream-cdr s) tolerance))))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(newline) 
(display "*ex 3.64")
(newline)
(display "the sqrt of 99 is: ")
(display (sqrt 99 0.00001))
(newline)

; ex 3.65
(define (log2-summends n)
    (cons-stream 
      (/ 1.0 n)
      (scale-stream (log2-summends (+ 1 n)) -1)))

(define log2-stream
  (partial-sum (log2-summends 1)))
(newline) 
(display "*ex 3.65")
(newline) 
(display (stream-limit (accelerated-sequence euler-transform log2-stream) 0.00000001))


; Infinite streams of pairs
(stream-filter
  (lambda (pair) (prime? (+ (car pair) (cadr pair))))
  int-pairs)
