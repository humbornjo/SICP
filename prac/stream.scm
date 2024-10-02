; WARNING: there is a native delay and force impl in csi, self defined delay and force should be put at the top

(define true #t)
(define false #f)
(define nil '())

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

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
(newline) 

; Infinite streams of pairs
;; (stream-filter
;;   (lambda (pair) (prime? (+ (car pair) (cadr pair))))
;;   int-pairs)
(define (stream-append s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (stream-append (stream-cdr s1) s2))))

(define S (stream-enumerate-interval 0 3))
;; (define S (integers-starting-from 0))
(define T (stream-enumerate-interval 10 14))

; my version of pairs and it is a wrong version (refer to ex 3.68)
(define (permutate-pair s t) 
  (if (or (stream-null? s) (stream-null? t))
    the-empty-stream
    (stream-append 
      (stream-map (lambda (x) (cons x (stream-car t))) s) 
      (permutate-pair (stream-cdr s) (stream-cdr t)))))
;; (display-stream (permutate-pair integers integers))


; official impl
(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (interleave s2 (stream-cdr s1)))))
(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))


; ex 3.66
; http://community.schemewiki.org/?sicp-ex-3.66 check my answer @humbornjo and brandon's @brandon.
(define (pos m n) 
  (define init (if (= m n) 1 (* 2 (- n m))))
  (define (inner x res) 
    (if (= x 1)
      res
      (inner (- x 1) (+ 1 (* 2 res)))))
  (inner m init))

(define (pnum m n)
  (- (pos m n) 1))

(newline) 
(display "*ex 3.66")
(newline) 
(display "ans for (1,   100): ")
(display (pnum 1 100))
(newline) 
(display "ans for (99,  100): ")
(display (pnum 99 100))
(newline) 
(display "ans for (100, 100): ")
(display (pnum 100 100))
(newline) 

; ex 3.67
;; (define (pairs s t)
;;   (cons-stream
;;     (list (stream-car s) (stream-car t))
;;     (interleave
;;       (stream-map (lambda (x) (list (stream-car s) x))
;;                   (stream-cdr t))
;;       (pairs (stream-cdr s) t))))

; ex 3.68
;; (define (pairs s t)
;;   (interleave
;;     (stream-map (lambda (x) (list (stream-car s) x))
;;                 t)
;;     (pairs (stream-cdr s) (stream-cdr t))))

; there is no delay, the pairs will be forever evaluated

; ex 3.69
(define (triples s t u) 
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map (lambda (x) (cons (stream-car s) x))
                  (stream-cdr (pairs t u)))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define pythagorean-triples
  (stream-filter 
    (lambda (x) 
      (let ((i (car x))
            (j (cadr x))
            (k (caddr x)))
        (= (+ (square i) (square j)) (square k))))
    (triples integers integers integers)))

(newline) 
(display "*ex 3.69")
(newline) 
(display "the 2nd pythagorean triples is: ")
(display (stream-ref pythagorean-triples 1))
(newline) 

; ex 3.70
(newline) 
(display "*ex 3.70")
(newline) 

(define (merge-weighted s1 s2 w)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2))
                (s1w (w (stream-car s1)))
                (s2w (w (stream-car s2))))
            (cond ((< s1w s2w)
                   (cons-stream
                     s1car
                     (merge-weighted (stream-cdr s1) s2 w)))
                  (else
                   (cons-stream
                     s2car
                     (merge-weighted s1 (stream-cdr s2) w))))))))

(define (weighted-pairs s t w)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
      (weighted-pairs (stream-cdr s) (stream-cdr t) w)
      w)))
  
;; a
(define stream-a 
  (weighted-pairs integers integers (lambda (x) (+ (car x) (cadr x)))))
(display "(a) the 4th pair is: ")
(display (stream-ref stream-a 3))
(newline) 

;; b
(define nor-div
  (stream-filter
    (lambda (x) (not (divisible? x 2)))
    (stream-filter 
      (lambda (x) (not (divisible? x 3)))
      (stream-filter 
        (lambda (x) (not (divisible? x 5)))
        integers))))

(define stream-b 
  (weighted-pairs nor-div nor-div 
    (lambda (x) 
      (+ (* 2 (car x)) (* 3 (cadr x)) (* 5 (car x) (cadr x))))))
(display "(b) the 4th pair is: ")
(display (stream-ref stream-b 3))
(newline) 

; ex 3.71
(define ordered-cube 
  (weighted-pairs integers integers (lambda (x) (+ (cube (car x)) (cube (cadr x))))))

(define (cube-sum x)
  (+ (cube (car x)) (cube (cadr x))))

(define (ramanujan s)
  (let ((x1 (stream-car s))
        (x2 (stream-car (stream-cdr s))))
    (if (= (cube-sum x1) (cube-sum x2)) 
      (cons-stream 
        (list (stream-car s) (stream-car (stream-cdr s)))
        (ramanujan (stream-cdr s)))
      (ramanujan (stream-cdr s)))))

(define ramanujan-stream (ramanujan ordered-cube))
(newline) 
(display "*ex 3.71")
(newline) 
(display "the 2nd ramanujan pairs are: ")
(display (stream-ref ramanujan-stream 1))
(newline) 
(display "the 6th ramanujan pairs are: ")
(display (stream-ref ramanujan-stream 5))
(newline) 

; ex 3.72
(define ordered-square 
  (weighted-pairs integers integers (lambda (x) (+ (square (car x)) (square (cadr x))))))

(define (square-sum x)
  (+ (square (car x)) (square (cadr x))))

(define (ramen s)
  (let ((x1 (stream-car s))
        (x2 (stream-car (stream-cdr s)))
        (x3 (stream-car (stream-cdr (stream-cdr s)))))
    (if (= (square-sum x1) (square-sum x2) (square-sum x3)) 
      (cons-stream 
        (list x1 x2 x3)
        (ramen (stream-cdr s)))
      (ramen (stream-cdr s)))))

(define ramen-stream (ramen ordered-square))
(newline) 
(display "*ex 3.72")
(newline) 
(display "the 2nd ramen pairs are: ")
(display (stream-ref ramen-stream 1))
(newline) 
(display "the 6th ramen pairs are: ")
(display (stream-ref ramen-stream 5))
(newline) 


; Streams as signals 
(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)

; ex 3.73
(define (RC r c dt) 
  (define (inner s v0) 
    (define is1
      (cons-stream
        v0
        (add-streams is1 (scale-stream s (/ dt c)))))
    (define is2
      (scale-stream s r))
    (add-streams is1 is2))
  inner)

; ex 3.74
;; (define (make-zero-crossings input-stream last-value)
;;   (cons-stream
;;     (sign-change-detector
;;       (stream-car input-stream)
;;       last-value)
;;     (make-zero-crossings
;;       (stream-cdr input-stream)
;;       (stream-car input-stream))))
;; (define zero-crossings
;;   (make-zero-crossings sense-data 0))

;; (define zero-crossings
;;   (stream-map sign-change-detector
;;               sense-data
;;               (cons-stream 0 sense-data)))

; ex 3.75
;; (define (make-zero-crossings input-stream last-value last-avpt) 
;;   (let ((avpt (/ (+ (stream-car input-stream) last-value) 2))) 
;;     (cons-stream (sign-change-detetor avpt last-avpt) 
;;                  (make-zero-crossings (stream-cdr input-stream) 
;;                                       (stream-car input-stream) 
;;                                       avpt)))) 

;; ex 3.76
(define (smooth s)
  (scale-stream 
    (add-streams s (cons-stream 0 s))
    0.5))

(define (make-zero-crossings input-stream) 
  (stream-map sign-change-detetor 
              (smooth input-stream)
              (cons-stream 0 (smooth input-stream))))


; 3.5.4 Streams and Delayed Evaluation
(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (stream-map f y))
  y)

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
      initial-value
      (let ((integrand (force delayed-integrand)))
        (add-streams (scale-stream integrand dt) int))))
  int)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(newline)
(display "e: ")
(display (stream-ref (solve (lambda (y) y)
                   1
                   0.1)
            10))
(newline)

; ex 3.77
(define (integral delayed-integrand initial-value dt)
  (cons-stream
    initial-value
    (let ((integrand (force delayed-integrand)))
      (if (stream-null? integrand)
        the-empty-stream
        (integral (stream-cdr integrand)
                  (+ (* dt (stream-car integrand))
                     initial-value)
                  dt)))))

; ex 3.78
(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-add (scale-stream dy a) (scale-stream y b)))
  y)

; ex 3.79
(define(general-solve-2nd f y0 dy0 dt) 
  (define y (integral (delay dy) y0 dt)) 
  (define dy (integral (delay ddy) dy0 dt)) 
  (define ddy (stream-map f dy y)) 
  y) 
  
; ex 3.80
(define (RLC r l c dt) 
  (define (inner vc0 il0) 
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (stream-map (lambda (x) (/ x (* -1 c))) il))
    (define dil (add-streams (scale-stream vc (/ 1 l)) (scale-stream il (/ r (* -1 l)))))
    (cons vc il))
  inner)

; 3.5.5 Modularity of Functional Programs and Modularity of Objects
(define random-init 1)
(define (rand-update x) (+ 1 x))
(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))
(define random-numbers
  (cons-stream
    random-init
    (stream-map rand-update random-numbers)))

(define (map-successive-pairs f s)
  (cons-stream
    (f (stream-car s) (stream-car (stream-cdr s)))
    (map-successive-pairs f (stream-cdr (stream-cdr s)))))
(define cesaro-stream
  (map-successive-pairs
    (lambda (r1 r2) (= (gcd r1 r2) 1))
    random-numbers))

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
      (monte-carlo
        (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))))

(define (sqrt x)
  (stream-limit (sqrt-stream x) 0.001))
(define pi
  (stream-map
    (lambda (p) (sqrt (/ 6 p)))
    (monte-carlo cesaro-stream 0 0)))

(define (stream-withdraw balance amount-stream)
(cons-stream
balance
(stream-withdraw (- balance (stream-car amount-stream))
(stream-cdr amount-stream))))

(display (stream-ref (stream-withdraw 100 integers) 10))
