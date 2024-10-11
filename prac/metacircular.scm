(define test-env 1)
(define nil '())

(define true 'true)
(define false 'false)

; 4.1.1
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp)
                                       (lambda-body exp)
                                       env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
          (error "Unknown expression type: EVAL" exp))))

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

; ex 4.1
(define (list-of-values-l2r exps env) 
  (if (no-operands? exps)
    '()
    (let ((left (eval (first-operand exps) env)))
      (cons left (list-of-values (rest-operands exps) env)))))

(define (list-of-values-r2l exps env) 
  (if (no-operands? exps)
    '()
    (let ((right (list-of-values (rest-operands exps) env)))
      (cons (eval (first-operand exps) env) right))))

; 4.1.2
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))
(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq? (car exp) tag)
    false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
    (cadr exp)
    (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
    (caddr exp)
    (make-lambda (cdadr exp) ; formal parameters
                 (cddr exp)))) ; body

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
    (cadddr exp)
    'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
    'false ; no else clause
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error "ELSE clause isn't last: COND->IF"
                 clauses))
        (make-if (cond-predicate first)
                 (sequence->exp (cond-actions first))
                 (expand-clauses rest))))))

; ex 4.2
;; a

;; (define (eval exp env)
;;   (cond ((self-evaluating? exp) exp)
;;         ((variable? exp) (lookup-variable-value exp env))
;;         ((quoted? exp) (text-of-quotation exp))
;;      -> ((application? exp)
;;      |   (apply (eval (operator exp) env)
;;      |          (list-of-values (operands exp) env)))
;;      |  ((assignment? exp) (eval-assignment exp env))
;;      |  ((definition? exp) (eval-definition exp env))
;;      |  ((if? exp) (eval-if exp env))
;;      |  ((lambda? exp) (make-procedure (lambda-parameters exp)
;;      |                                 (lambda-body exp)
;;      |                                 env))
;;      |  ((begin? exp)
;;      |   (eval-sequence (begin-actions exp) env))
;;      |  ((cond? exp) (eval (cond->if exp) env))
;;      - 
;;         (else
;;           (error "Unknown expression type: EVAL" exp))))

;; if louis move application before assignment and definition
;; (define x 3) will be inteperated as application

;; b

;; (define (application? exp) (tagged-list? exp 'call))
;; (define (operator exp) (cadr exp))
;; (define (operands exp) (cddr exp))

; ex 4.3

;; http://community.schemewiki.org/?sicp-ex-4.3
;; check ans by @meteorgan

; ex 4.4

(define (and? exp) (tagged-list? exp 'and))
(define (or? exp) (tagged-list? exp 'or))

;; special form
(define (eval-and exp env)
  (define (inner seq env prev)
    (cond ((null? seq) prev)
          ((not (true? (eval (car seq) env))) 'false)
          (else (inner (cdr seq) env (eval (car seq) env)))))
  (inner (cdr exp) env 'true))

(define (eval-or exp env)
  (define (inner seq env prev)
    (cond ((null? (car seq)) prev)
          ((true? (eval (car seq) env)) 'true)
          (else (inner (cdr seq) env (eval (car seq) env)))))
  (inner (cdr exp) env 'false))

;; derived form 
(define (and->if exp) (expand-and (cdr exp) 'true))
(define (expand-and seq prev)
  (if (null? seq) 
    prev
    (let ((first (car seq))
          (rest (cdr seq)))
      (make-if first
               (expand-and rest (eval first env))
               'false))))

(define (or->if exp) (expand-or (cdr exp) 'false))
(define (expand-or seq prev)
  (if (null? seq) 
    prev
    (let ((first (car seq))
          (rest (cdr seq)))
      (make-if first
               (expand-and rest (eval first env))
               'true))))

; ex 4.5

(define (expand-clauses clauses)
  (if (null? clauses)
    'false ; no else clause
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error "ELSE clause isn't last: COND->IF" clauses))
        (make-if (cond-predicate first)
                 (if (eq? '=> (cadr first)) 
                   ((caddr first) (cond-predicate first))
                   (sequence->exp (cond-actions first)))
                 (expand-clauses rest))))))

; ex 4.6

(define (let->combination exp)
  (let ((clauses (cadr exp))
        (body (caddr exp)))
    (let ((vars (map car clauses))
          (vals (map cadr clauses)))
      (cons (make-lambda vars body) vals))))

(define (let? exp) (tagged-list? exp 'let))

(define (eval exp env)
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

; ex 4.7

(define (make-let seq body) (cons 'let (cons seq body)))
(define (let*->nested-lets exp)
  (define (inner clauses body)
    (if (null? clauses)
      (sequence->exp body)
      (make-let (list (car clauses)) (list (inner (cdr clauses) body)))))
  (inner (cadr exp) (cddr exp)))

(display "ex 4.7:")
(newline)
(display (let*->nested-lets '(let* ((x 1) (y 2)) x y)))
(newline)

;; if non-drived trans is applied, the env state will be very hard to follow

; ex 4.8

(define (named-let? expr) (and (let? expr) (symbol? (cadr expr))))
(define (make-definition func args body) (list 'define (cons func args) body))

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
        (cons (make-lambda vars body) vals)))))

(newline)
(display "ex 4.8:")
(newline)
(display (let->combination '(let a ((k 10)) (+ 1 a k))))
(newline)

; ex 4.9

;; suppose impl c style for loop which
;; for init condition step: exp
;; (for init condition step exp)

;; example: (for ((a 10)) (< a 20) (lambda (x) (+ x 1)) (begine (display a) (newline)))

(define (for->combination exp)
  (let* ((actions (cdr exp))
         (args (cadr exp))
         (var (list (car args)))
         (val (list (cadr args)))
         (condition (cadr actions))
         (step (caddr actions))
         (body (cadddr actions)))
    (sequence->exp (list (make-definition 
                           'while-ref 
                           var
                           (make-if 
                             condition 
                             (sequence->exp (list body (list 'while-ref step))) 
                             'nil))
                         (cons 'while-ref val)))))

(newline)
(display "ex 4.9:")
(newline)
(display (for->combination 
           '(for (a 10) (< a 20) (+ a 1) (begin (display a) (newline)))))
(newline)

;; ;; try run the output procedure
;; (begin 
;;   (define (while-ref a) 
;;     (if (< a 20) (begin (begin (display a) (newline)) (while-ref (+ a 1))) nil))
;;   (while-ref 10))


; 4.1.3

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;! Operations on Environments

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
    (cons (make-frame vars vals) base-env)
    (if (< (length vars) (length vals))
      (error "Too many arguments supplied" vars vals)
      (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable: SET!" var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

; ex 4.11

;; env -> { pairs, enclosing_env }

(define (make-frame variables values)
  (cons 'pairs (map cons variables values)))
(define (frame-variables frame) (map car (cdr frame)))
(define (frame-values frame) (map cdr (cdr frame)))
(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val) (cdr frame))))

(newline)
(display "ex 4.11:")
(define f (make-frame (list 1 2 3) (list 9 8 7)))
(newline)
(display "frame: ")
(display f)
(newline)
(display "frame vars: ")
(display (frame-variables f))
(newline)
(display "frame vars: ")
(display (frame-values f))
(add-binding-to-frame! 4 10 f)
(newline)
(display "add (4, 10) frame: ")
(display f)
(newline)
(display f)
(newline)

; ex 4.12

;; http://community.schemewiki.org/?sicp-ex-4.12 @woofy

; ex 4.13

;; consider when we need to unbound a definition

;; seems only when we need to refer to the def in
;; the enclosing frame 

;; e.g. eval impl in the book is not complete yet
;;      so test should be performed with native eval

;; so I believe only the def in curr frame need to 
;; be cleared

(define (make-unbound! var env)
  (define (scan pairs prev)
    (cond ((null? pairs)
           (error "Unbound variable: DO NOTHING!" var))
          ((eq? var (caar pairs)) (set-cdr! prev (cdr pairs)))
          (else (scan (cdr pairs) pairs))))
  (if (eq? env the-empty-environment)
    (error "Unbound variable: DO NOTHING!" var)
    (let ((frame (first-frame env)))
      (scan (cdr frame) frame))))

(define the-empty-environment '())
(define (first-frame env) (car env))

(newline)
(display "ex 4.11:")
(newline)
(display f)
(newline)
(make-unbound! 4 (cons f '()))
(display f)
(newline)
(make-unbound! 3 (cons f '()))
(display f)
(newline)

; 4.1.4


