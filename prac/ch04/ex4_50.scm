; Implement a new special form ramb that is like amb except that
; it searches alternatives in a random order, rather than from
; left to right. Show how this can help with Alyssa’s problem in
; Exercise 4.49.

;; Answer

(define (analyze-ramb exp)
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
        (else (error "Unknown expression type: ANALYZE" exp)))
  )

; random is imported for `pseudo-random-integer`
; https://wiki.call-cc.org/man/5/Module%20(chicken%20random)#pseudo-random-integer
(import (chicken random))
(define (shuffle lst)
  (cond ((null? lst) lst)
        ((null? (cdr lst)) lst)
        (else
          (let ((rest (shuffle (cdr lst))))
            (if (zero? (pseudo-random-integer 2))
              (cons (car lst) rest)
              (cons (car rest) (cons (car lst) (cdr rest)))))
          )
        )
  )

(define (ramb? exp) (eq? (car exp) 'ramb))

(define (ramb-choices exp) (cdr exp))

(define (analyze-ramb exp)
  (let ((cprocs (shuffle (map analyze (ramb-choices exp)))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
          (fail)
          ((car choices)
           env
           succeed
           (lambda () (try-next (cdr choices))))))
      (try-next cprocs))))


;; Test (theoretically 1/2^10 chance of failure)

(define test-input `(ramb '1 '2 '3 '4 '5 '6 '7 '8 '9 '10))

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define (ambeval exp env succeed fail)
  ((analyze-ramb exp) env succeed fail))


(define curr -1)

(define test-got #f)
(define test-want #t)

(ambeval test-input
         the-global-environment
         (lambda (val next-alternative)
           (if (= -1 curr)
             (set! curr val)
             (if (< val curr)
               (set! test-got #t)
               (set! curr val)
               )
             )
           (next-alternative))
         (lambda () "Glorious Death"))

(assert (equal? test-got test-want))
