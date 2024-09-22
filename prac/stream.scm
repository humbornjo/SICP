; WARNING: there is a native delay and force impl in csi, self defined delay and force should be put at the top

(define true #t)
(define false #f)
(define nil '())

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
        (begin (set! result (proc))
               (set! already-run? true)
               result)
        result))))

(define (delay proc) (memo-proc (lambda () proc)))
(define (delay proc) (lambda () proc))
(define (force delayed-object) (delayed-object))

(define (cons-stream a b) 
  (cons a (delay b)))

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
(newline)
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
    the-empty-stream
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map
             (cons proc (map stream-cdr argstreams))))))

; ex 3.51
(define (stream-map proc s)
  (if (stream-null? s)
    (begin  (display "reachend") the-empty-stream )
    (cons-stream (proc (stream-car s))
                 (stream-map proc (stream-cdr s)))))

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
;; wont change because memory only preverse (curr, next) and iter_num, not affecing sum
(newline) 



