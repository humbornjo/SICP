; ex 3.39
;; 101: P1 sets x to 100 and then P2 increments x to 101.
;; 121: P2 increments x to 11 and then P1 sets x to x * x.
;; 110: P2 changes x from 10 to 11 between the two times that P1 accesses the value of x during the evaluation of (* x x).
;; 11: P2 accesses x, then P1 sets x to 100, then P2 sets x.
;; 100: P1 accesses x (twice), then P2 sets x to 11, then P1 sets x.

;; remained:
;; 100
;; 121
;; 101
;; 11

; ex 3.42
;; it is safe and it is just like 
;; original:
;;   if mutex.lock: 
;;     deposit/withdraw
;; Ben Bitdiddl:
;;   ; pre-defined protected_deposit/withdraw = if mutex.lock: deposit/withdraw
;;   protected_deposit/withdraw
;; where mutex is used to control the concurrency

; ex 3.44
;; louis is wrong

; ex 3.45
;; when you call serialized-exchange
;; both account need to be locked until finish 
;; but if you lock each procedure at the very beginning
;; it will be:
;;  try mutex1.lock
;;    try mutex2.lock
;;      exchange:
;;        ; withdraw and deposit in exchange
;;        protected_withdraw <- try mutex1.lock
;;        protected_deposit  <- try mutex2.lock

; Implementing serializers

(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))

(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
               (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))

(define (clear! cell) (set-car! cell false))
(define (test-and-set! cell)
  (if (car cell) true (begin (set-car! cell true) false)))

; ex 3.47
;; a
(define (make-semaphore slot)
  (let ((mutex (make-mutex))
        (num 0))
    (define (acquire)
      (mutex 'acquire)
      (cond ((= num slot) (mutex 'release) (acquire))
            ((< num slot) (set! num (+ 1 num)) (mutex 'release))))
    (define (release)
      (mutex 'acquire)
      (set! num (- num 1))
      (mutex 'release))
    (define (the-semaphore s)
      (cond ((eq? s 'acquire) (acquire)) ; retry
            ((eq? s 'release) (release))))
    the-semaphore))

;; b
(define (make-semaphore slot)
  (let ((cell (list false))
        (num 0))
    (define (acquire)
      (if (test-and-set! cell)
        (cond ((= num slot) (clear! cell) (acquire))
              ((< num slot) (set! num (+ 1 num)) (clear! cell)))
        (acquire)))
    (define (release)
      (if (test-and-set! cell)
        (begin (set! num (- num 1)) (clear! cell))
        (release)))
    (define (the-semaphore s)
      (cond ((eq? s 'acquire) (acquire)) ; retry
            ((eq? s 'release) (release))))
    the-semaphore))



