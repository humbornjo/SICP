;; Answer

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

; a.

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

; b.

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
