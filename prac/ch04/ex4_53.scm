; With permanent-set! as described in Exercise 4.51 and if-fail
; as in Exercise 4.52, what will be the result of evaluating
;
; (let ((pairs '()))
;   (if-fail
;     (let ((p (prime-sum-pair '(1 3 5 8)
;                              '(20 35 110))))
;       (permanent-set! pairs (cons p pairs))
;       (amb))
;     pairs))


;; Answer

; ((8 35) (3 110) (3 20))


;; Test

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

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (amb-enumerate lst)
       (if (null? lst)
         (amb)
         (amb (car lst) (amb-enumerate (cdr lst)))))

     (define (prime-sum? pair)
       (prime? (+ (car pair) (cadr pair))))

     (define (prime-sum-pair lst1 lst2)
       (let ((v1 (amb-enumerate lst1)))
         (let ((v2 (amb-enumerate lst2)))
           (require (prime-sum? (list v1 v2)))
           (list v1 v2)
           )
         )
       )

     (let ((pairs '()))
       (if-fail
         (let ((p (prime-sum-pair '(1 3 5 8)
                                  '(20 35 110))))
           (permanent-set! pairs (cons p pairs))
           (amb))
         pairs))
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
        ((if-fail? exp) (analyze-if-fail exp))
        ((let? exp) (analyze-let exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp)))
  )

(define test-got nil)
(define test-want `((8 35) (3 110) (3 20)))

(ambeval test-input
         the-global-environment
         (lambda (val next-alternative)
           (set! test-got val))
         (lambda ()
           (display "Glorious Death"))
         )

(assert (equal? test-got test-want))
