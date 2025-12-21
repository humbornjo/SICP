; Implement a new construct called if-fail that permits the user
; to catch the failure of an expression. if-fail takes two
; expressions. It evaluates the first expression as usual and
; returns as usual if the evaluation succeeds. If the evaluation
; fails, however, the value of the second expression is
; returned, as in the following example:
;
; ;;; Amb-Eval input:
; (if-fail (let ((x (an-element-of '(1 3 5))))
;            (require (even? x))
;            x)
;          'all-odd)
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; all-odd
; ;;; Amb-Eval input:
; (if-fail (let ((x (an-element-of '(1 3 5 8))))
;            (require (even? x))
;            x)
;          'all-odd)
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; 8


;; Answer

(define (if-fail? exp) (tagged-list? exp 'if-fail))

(define (if-fail-success exp) (cadr exp))

(define (if-fail-failure exp) (caddr exp))

(define (analyze-if-fail exp)
  (let ((routine (analyze (if-fail-success exp)))
        (fail-ret (analyze (if-fail-failure exp))))
    (lambda (env succeed fail)
      (routine env
               (lambda (result fail2)
                 (succeed result fail2))
               (lambda ()
                 (fail-ret env succeed fail) fail))
      )))

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((if-fail? exp) (analyze-if-fail exp))
        ((let? exp) (analyze-let exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp)))
  )

;; Test

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((if-fail? exp) (analyze-if-fail exp))
        ((let? exp) (analyze-let exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp)))
  )


(define test-input-1
  `(begin
     (define (require predicate) (if (not predicate) (amb)))
     (define (an-element-of lst)
       (if (null? lst)
         (amb)
         (amb (car lst) (an-element-of (cdr lst)))))
     (if-fail (let ((x (an-element-of '(1 3 5))))
           (require (even? x))
           x)
         'all-odd)
     )
  )
(define test-got-1 nil)
(define test-want-1 `(all-odd))
(ambeval test-input-1
         the-global-environment
         (lambda (val next-alternative)
           (set! test-got-1 (cons val test-got-1))
           (next-alternative))
         (lambda ()
           (display "Glorious Death")))
(assert (equal? test-got-1 test-want-1))

(define test-input-2
  `(begin
     (define (require predicate) (if (not predicate) (amb)))
     (define (an-element-of lst)
       (if (null? lst)
         (amb)
         (amb (car lst) (an-element-of (cdr lst)))))
     (if-fail (let ((x (an-element-of '(1 3 5 8))))
           (require (even? x))
           x)
         'all-odd)
     )
  )
(define test-got-2 nil)
(define test-want-2 (list 'all-odd 8))
(ambeval test-input-2
         the-global-environment
         (lambda (val next-alternative)
           (set! test-got-2 (cons val test-got-2))
           (next-alternative))
         (lambda ()
           (display "Glorious Death")))
(assert (equal? test-got-2 test-want-2))

