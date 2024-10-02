(define (square x) (* x x))
; exercise 3.1
(define (make-accumulator init)
  (lambda (acc)
    (begin 
      (set! init (+ init acc))
      init)))

(define A (make-accumulator 5))
(A 10)

; exercise 3.2
(define (make-monitored mf)
  (define call 0)
  (lambda (op)
    (cond 
      ((eq? op 'how-many-calls?) call)
      (else (set! call (+ call 1)) (mf op)))))

(define s (make-monitored sqrt))
(s 100)
(s 400)
(s 'how-many-calls?)

; exercise 3.3
(define (make-account balance pass)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (if (eq? p pass) 
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "Unknown request: MAKE-ACCOUNT" m)))
      (error "Incorrect password")))
  dispatch)

(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40)

; exercise 3.4
(define (make-account balance pass)
  (define alarm 0)
  (define (call-the-cops) "Call the cops")
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (if (eq? p pass) 
      (begin 
        (set! alarm 0)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else (error "Unknown request: MAKE-ACCOUNT" m))))
      (lambda (amount) 
        (set! alarm (+ 1 alarm))
        (if (> alarm 7)
          (call-the-cops)
          "Incorrect password"))))
  dispatch)

(begin 
(define accc (make-account 100 'secret-password))
((accc 'secret-password 'withdraw) 40)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50)
((accc 'some-other-password 'deposit) 50))


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

; exericse 3.5
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

(newline)
(display (estimate-integral integral-test 2.0 8.0 4.0 10.0 10000))

; exercise 3.6
; rand cant be a function, otherwise init will be reinit
(define (rand-update x) (random x))
(define random-init 1.0)
(define rand
  (let ((x random-init))
    (define (dispatch mode)
      (cond 
        ((eq? mode 'generate) (set! x (rand-update x)) x)
        ((eq? mode 'reset) (lambda (new-val) (set! x new-val)))
        (else "undefined mode")))
    dispatch))

(newline)
(newline)
(display (rand 'generate))
((rand 'reset) 1.0)

(newline)
(display (rand 'generate))
(newline)
(display (rand 'generate))

; exercise 3.7
(define (make-joint acc pass npass)
  (lambda (p m) 
    (cond 
      ((eq? p npass) (acc pass m))
      (else (acc p m)))))

(define acc (make-account 100 'secret-password))
(newline)
(newline)
(display ((acc 'secret-password 'withdraw) 20))
(define paul-acc (make-joint acc 'secret-password 'rosebud))
(define jack-acc (make-joint paul-acc 'rosebud 'doragon))
(newline)
(display ((jack-acc 'doragon 'withdraw) 20))

; exercise 3.8
(define f 
  (let 
    ((local 0))
    (define (ff x)
      (begin 
        (set! local (- x local))
        local))
    ff))
(newline)
(newline)
(display (+ (f 0) (f 1)))
(newline)
(display (+ (f 1) (f 0)))


