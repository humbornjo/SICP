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
           (apply (eval (operator exp) env)
                  (list-of-values (operands exp) env)))
          (else
            (error "Unknown expression type: EVAL" exp))))
  )

(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
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
  (if (true? (eval (if-predicate exp) env))
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
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)

; eval definition
(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)



