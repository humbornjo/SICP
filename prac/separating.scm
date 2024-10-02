;; top level primitives
(define true #t)
(define false #f)

(define (tagged-list? exp tag)
  (if (pair? exp) 
    (eq? (car exp) tag)
    false))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;; separate eval into analyze and evaluation
(define (eval exp env) ((analyze exp) env))

(define (analyze exp)
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
        ((application? exp) (analyze-application exp))
        (else (error "Unknown expression type: ANALYZE" exp))))


;; analyzer
(define (analyze-self-evaluating exp)
  (lambda (env) exp))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env) qval)))

(define (analyze-variable exp)
  (lambda (env) (lookup-variable-value exp env)))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env)
      (set-variable-value! var (vproc env) env)
      'ok)))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
        (vproc (analyze (definition-value exp))))
    (lambda (env)
      (define-variable! var (vproc env) env)
      'ok)))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env) (if (true? (pproc env))
                    (cproc env)
                    (aproc env)))))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env) (make-procedure vars bproc env))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
      first-proc
      (loop (sequentially first-proc (car rest-procs))
            (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs) (error "Empty sequence: ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application
        (fproc env)
        (map (lambda (aproc) (aproc env))
             aprocs)))))
(define (execute-application proc args)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure proc args))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment
            (procedure-parameters proc)
            args
            (procedure-environment proc))))
        (else
          (error "Unknown procedure type: EXECUTE-APPLICATION"
                 proc))))

;; type identifier
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (variable? exp) (symbol? exp))

(define (assignment? exp) (tagged-list? exp 'set!))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
    (cadr exp)
    (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
    (caddr exp)
    (make-lambda (cdadr exp)   ; extract the args in (define <var arg1 arg2 ...> <body>)
                 (cddr exp)))) ; extract the body in (define <var arg1 arg2 ...> <body>)

(define (if? exp) (tagged-list? exp 'if))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (begin? exp) (tagged-list? exp 'begin))

(define (cond? exp) (tagged-list? exp 'cond))

(define (application? exp) (pair? exp))

;; 4.22
(define (let->combination exp)
  (let ((clauses (cadr exp))
        (body (caddr exp)))
    (let ((vars (map car clauses))
          (vals (map cadr clauses)))
      (cons (make-lambda vars body) vals))))

(define (let? exp) (tagged-list? exp 'let))
(define (let-variables exp) (map car(cadr exp)))
(define (let-values exp) (map cadr(cadr exp)))
(define (let-body exp) (caddr exp))
(define (analyze-let exp)
  (define (let->combination exp)
    (let ((clauses (cadr exp))
          (body (caddr exp)))
      (let ((vars (map car clauses))
            (vals (map cadr clauses)))
        (cons (make-lambda vars body) vals))))
  (analyze (let->combination exp)))

;; ex 4.23

;; What work will the execution procedure produced by Alyssa’s program do? 
;; - it will produce the same result as the original version, but delay the 
;;   analyze to the execution stage.

;; What about the execution procedure produced by the program in the text above? 
;; - it will execute proc one by one, and analyze next proc on finish each proc.

;; How do the two versions compare for a sequence with two expressions?
;; - there will be remaining part of analyze in execution in Alyssa’s version.




;; main
(display (analyze-sequence '((define x 1) (define y 2) (+ x y))))
