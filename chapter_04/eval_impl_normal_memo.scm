(define DEBUG #f)

;; introducing <let->combination>
(define (named-let? expr) (and (let? expr) (symbol? (cadr expr))))
(define (let->combination exp)
  (if (named-let? exp)
    (let ((func (cadr exp))
          (clauses (caddr exp))
          (body (cadddr exp)))
      (let ((vars (map car clauses))
            (vals (map cadr clauses)))
        (sequence->exp
          (list (make-definition func vars body) (cons func vals)))))
    (let ((clauses (cadr exp))
          (body (caddr exp)))
      (let ((vars (map car clauses))
            (vals (map cadr clauses)))
        (cons (make-lambda vars (list body)) vals)))))

(define (eval exp env)
  (begin
    (if DEBUG
      (begin
      (display "calling eval: ")
      (display exp)
      (newline)))
    (cond ((self-evaluating? exp) exp)
          ((variable? exp) (lookup-variable-value exp env))
          ((quoted? exp) (text-of-quotation exp))
          ((assignment? exp) (eval-assignment exp env))
          ((definition? exp) (eval-definition exp env))
          ((if? exp) (eval-if exp env))
          ((lambda? exp) (make-procedure (lambda-parameters exp)
                                         (lambda-body exp)
                                         env))
          ((let? exp) (eval (let->combination exp) env))
          ((begin? exp)
           (eval-sequence (begin-actions exp) env))
          ((cond? exp) (eval (cond->if exp) env))
          ((application? exp)
           (apply (actual-value (operator exp) env)
                  (operands exp)
                  env))
          (else
            (error "Unknown expression type: EVAL" exp))))
  )

(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
           procedure
           (list-of-arg-values arguments env)))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             (list-of-delayed-args arguments env)
             (procedure-environment procedure))))
        (else
          (error
            "Unknown procedure type: APPLY" procedure))))

; eval parameters
(define (list-of-values exps env)
  (if (no-operands? exps)
    '()
    (cons (eval (first-operand exps) env)
          (list-of-values (rest-operands exps) env))))

; eval conditions
(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
    (eval (if-consequent exp) env)
    (eval (if-alternative exp) env)))

; eval sequence of expression
(define (eval-sequence exps env)
  (cond ((last-exp? exps)
         (eval (first-exp exps) env))
        (else
          (eval (first-exp exps) env)
          (eval-sequence (rest-exps exps) env))))

; eval assignment
(define (eval-assignment exp env)
  (begin
    (if DEBUG
      (begin
        (display "calling eval-assignment: ")
        (display exp)
        (newline)))
    (set-variable-value! (assignment-variable exp)
                         (eval (assignment-value exp) env)
                         env)
    'ok))

; eval definition
(define (eval-definition exp env)
  (begin
    (if DEBUG
      (begin
        (display "calling eval-assignment: ")
        (display exp)
        (newline)))
    (define-variable! (definition-variable exp)
                      (eval (definition-value exp) env)
                      env)
    'ok))

; normal-order specific
(define (actual-value exp env)
  (force-it (eval exp env)))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
    '()
    (cons (actual-value (first-operand exps) env)
          (list-of-arg-values (rest-operands exps) env)
          )))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
    '()
    (cons (delay-it (first-operand exps) env)
          (list-of-delayed-args (rest-operands exps) env)
          )))

; force-it with memory
(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))
(define (thunk-value evaluated-thunk)
  (cadr evaluated-thunk))
(define (force-it obj)
  (cond ((thunk? obj)
         (let ((result (actual-value (thunk-exp obj)
                                     (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj)
                     result) ; replace exp with its value
           (set-cdr! (cdr obj)
                     '()) ; forget unneeded env
           result))
        ((evaluated-thunk? obj) (thunk-value obj))
        (else obj)))

(define (delay-it exp env) (list 'thunk exp env))
(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define input-prompt ";; L-Eval input:")
(define output-prompt ";; L-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
    (display (list 'compound-procedure
                   (procedure-parameters object)
                   (procedure-body object)
                   '<procedure-env>))
    (display object)))



