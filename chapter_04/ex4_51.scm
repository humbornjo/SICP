; Implement a new kind of assignment called permanent-set! that
; is not undone upon failure. For example, we can choose two
; distinct elements from a list and count the number of trials
; required to make a successful choice as follows:
;
; (define count 0)
; (let ((x (an-element-of '(a b c)))
;       (y (an-element-of '(a b c))))
;   (permanent-set! count (+ count 1))
;   (require (not (eq? x y)))
;   (list x y count))
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; (a b 2)
; ;;; Amb-Eval input:
; try-again
; ;;; Amb-Eval value:
; (a c 3)
;
; What values would have been displayed if we had used set! here
; rather than permanent-set! ?


;; Answer

; The value of count would be 2 if use set!

(define (assignment-permanent? exp) (tagged-list? exp 'permanent-set!))

(define (analyze-assignment-permanent exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2) ; *1*
               (set-variable-value! var val env)
               (succeed 'ok
                        (lambda () ; *2*
                          (fail2))))
             fail))))

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((assignment-permanent? exp) (analyze-assignment-permanent exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((let? exp) (analyze-let exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp)))
  )

;; Test

(define (ambeval-permanent exp env succeed fail)
  ((analyze exp) env succeed fail))

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))
     (define count 0)

     (define x (amb 1 2 3))
     (permanent-set! count (+ count 1))

     (require (= x 3))
     count
     )
  )

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((assignment-permanent? exp) (analyze-assignment-permanent exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((let? exp) (analyze-let exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp)))
  )

(define test-got nil)
(define test-want 3)

(ambeval-permanent test-input
                   the-global-environment
                   (lambda (val next-alternative)
                     (set! test-got val))
                   (lambda ()
                     (display "Glorious Death"))
                   )

(assert (equal? test-got test-want))
