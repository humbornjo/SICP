;; Implement a new special form ramb that is like amb except that
;; it searches alternatives in a random order, rather than from
;; left to right. Show how this can help with Alyssa’s problem in
;; Exercise 4.49.

;; Answer

(define (analyze-ramb exp)
  (begin
    (if DEBUG
      (begin
        (display "calling eval: ")
        (display exp)
        (newline)))
    (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
          ((quoted? exp) (analyze-quoted exp))
          ((variable? exp) (analyze-variable exp))
          ((assignment? exp) (analyze-assignment exp))
          ((definition? exp) (analyze-definition exp))
          ((if? exp) (analyze-if exp))
          ((let? exp) (analyze-let exp))
          ((lambda? exp) (analyze-lambda exp))
          ((begin? exp) (analyze-sequence (begin-actions exp)))
          ((cond? exp) (analyze (cond->if exp)))
          ((ramb? exp) (analyze-ramb exp))
          ((application? exp) (analyze-application exp))
          (else (error "Unknown expression type: ANALYZE" exp))))
  )

(define (shuffle lst)
  (if (null? lst)
    lst
    (let ((rest (shuffle (cdr lst))))
      (if (zero? (random 2))
        (cons (car lst) rest)
        (cons (car rest) (cons (car lst) (cdr rest))))))
  )

(define (analyze-ramb exp)
  (let ((cprocs (shuffle (map analyze (amb-choices exp)))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
          (fail)
          ((car choices)
           env
           succeed
           (lambda () (try-next (cdr choices))))))
      (try-next cprocs))))


;; Test

(define test-input
  `(ramb "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(load "eval_init_amb.scm")
(load "eval_separate_amb.scm")

(define analyze analyze-ramb)

(ambeval test-input
         the-global-environment
         (lambda (val next-alternative)
           (display val)
           (display " ")
           )
         (lambda () "Glorious Death"))

