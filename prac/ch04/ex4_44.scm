; Exercise 2.42 described the “eight-queens puzzle” of placing
; queens on a chessboard so that no two attack each other. Write
; a nondeterministic program to solve this puzzle.

(define (distinct? items)
  (cond ((null? items) #t)
        ((null? (cdr items)) #t)
        ((member (car items) (cdr items)) #f)
        (else (distinct? (cdr items)))))


;; Answer

;; import func an-integer-between
(load "./ex4_35.scm")

(define (ones-amb n)
  (define inner
    (lambda (n N)
      (if (= n 0)
        (list (an-integer-between 1 N))
        (cons (an-integer-between 1 N) (inner (- n 1) N))
        ))
      )
  (inner n n))

(define (eight-queens)
  (define (print-queens queens)
    (define (inner queens n)
      (cond ((null? queens) #t)
            (else
              (display "queen ")
              (display n)
              (display " at ")
              (display (list n (car queens)))
              (newline)
              (print-queens (cdr queens)))
            )
      )
    )
  (define (queen-kills queens)
    (define (inner queens start n)
      (require (< (+ start n) 9))
      (require (not (=
                      (find-n queens start)
                      (find-n queens (+ start n)))))
      (require (not (=
                      (+ (find-n queens start) n)
                      (find-n queens (+ start n)))))
      (require (not (=
                      (- (find-n queens start) n)
                      (find-n queens (+ start n)))))
      )
    (inner queens (an-integer-between 1 8) (an-integer-between 1 8))
    )
  (let ((queens (ones-amb 8)))
    (queen-kills queens)
    (print-queens queens))
  )
