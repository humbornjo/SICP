(define (count-change amount) 
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else 
          (+ (cc amount (- kinds-of-coins 1))
             (cc (- amount (first-denomination kinds-of-coins)) 
                 kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 100)

; exercise: 1.11
(define (f n)
  (define (f_iter a b c i)
    (cond ((< n 3) n)
          ((<= n i) a)
          (else (f_iter (+ a (* 2 b) (* 3 c)) a b (+ i 1)))))
  (f_iter 2 1 0 2))

(f 7)

; exercise: 1.12
(define (pascal r c)
  (cond ((> c r) 0)
        ((= c r) 1)
        ((= c 0) 1)
        (else (+ (pascal (- r 1) c) (pascal (- r 1) (- c 1))))
        ))

(pascal 5 2)
