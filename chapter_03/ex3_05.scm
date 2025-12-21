;; Answer

; monte-carol

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))
(define (cesaro-test)
  (= (gcd (rand) (rand)) 1))
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1)
                 (+ trials-passed 1)))
          (else
            (iter (- trials-remaining 1)
                  trials-passed))))
  (iter trials 0))

; random from https://stackoverflow.com/questions/14674165/scheme-generate-random

(define random
  (let ((a 69069) (c 1) (m (expt 2 32)) (seed 20000530))
    (lambda new-seed
      (if (pair? new-seed)
        (set! seed (car new-seed))
        (set! seed (modulo (+ (* seed a) c) m)))
      (/ seed m))))

(define (randf . args)
  (cond ((= (length args) 1)
         (* (random) (car args)))
        ((= (length args) 2)
         (+ (car args) (* (random) (- (cadr args) (car args)))))
        (else (error 'randint "usage: (randint [lo] hi)"))))

(define (random-in-range low high)
  (+ low (randf (- high low))))

(define (integral-test x y)
  (< (+ (expt (- x 5) 2) (expt (- y 7) 2)) 9))

(define (estimate-integral P x1 x2 y1 y2 trials)
  (define (inner-test) (P (random-in-range x1 x2) (random-in-range y1 y2)))
  (* (monte-carlo trials inner-test) 4 1.0))

; (display (estimate-integral integral-test 2.0 8.0 4.0 10.0 10000))
