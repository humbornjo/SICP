(define test-env 1)
(define nil '())

(define true 'true)
(define false 'false)

(define apply-in-underlying-scheme apply)

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

(define (make-let seq body) (list 'let seq body))
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
(display "ex 4.13:")
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

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'append append)))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
                              (primitive-procedure-objects)
                              the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define the-global-environment (setup-environment))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
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

(define the-global-environment (setup-environment))
;; (driver-loop)

; ex 4.14

;; when i call the native map, such error popped up
;; Error: call of non-procedure: (primitive #<procedure (scheme#car x)>)

;; (define (list-of-values exps env)
;;   (if (no-operands? exps)
;;     '()
;;     (cons (eval (first-operand exps) env)
;;           (list-of-values (rest-operands exps) env))))

;; when eval (map car (list (cons 1 3))). the native <map> will 
;; use native <apply> on <car> and the rest of the args. however, 
;; the <car> func after eval is not just a procedure, but 
;; (primitive #<procedure (scheme#car x)>).

;; so either impl a map use the apply defined by us, or, try to 
;; eval <car> as native <car> only.

; 4.1.5

; ex 4.15

(define (run-forever) (run-forever))
(define (try p)
  (if (halts? p p) (run-forever) 'halted))

;; observing <try>, 
;; - if <p> is halt on <p>, <try> will run forever
;; - if <p> throw an error or run forever on <p>, return 'halted

;; if <try> halt on <try> (say return 'halt) <try> will run forever
;; if <try> not halt on <try> (say run-forever) <try> will return 'halt 
;; which is contradictory -> such <halt?> not exist

; 4.1.6

; ex 4.16

;; a
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (if (eq? (car vals) '*unassigned*) 
                                    (error "Unassigned variable" var)
                                    (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

;; b, c

;; dont think split the define to unassigned and set is a good way
;; so here i will skip this question
;; refer to http://community.schemewiki.org/?sicp-ex-4.16 @woofy
(define (make-assignment var exp) 
  (list 'set! var exp)) 

(define (scan-out-defines body) 

  (define (collect seq defs exps) 
    (if (null? seq) 
      (cons defs exps) 
      (if (definition? (car seq)) 
        (collect (cdr seq) (cons (car seq) defs) exps) 
        (collect (cdr seq) defs (cons (car seq) exps))))) 

  (let ((pair (collect body '() '()))) 
    (let ((defs (car pair)) (exps (cdr pair))) 
      (make-let (map (lambda (def)  
                       (list (definition-variable def)  
                             '*unassigned*)) 
                     defs) 
                (append  
                  (map (lambda (def)  
                         (make-assignment (definition-variable def) 
                                          (definition-value def))) 
                       defs) 
                  exps)))))

(define (make-procedure parameters body env) 
  (list 'procedure parameters (scan-out-defines body) env))

; ex 4.17

;; when eval <e3>
;; it will be sth like 
;; (let ((var1 *unassigned*))
;;    (set! var1 val1)
;;    <body>)

;; with: let    -> lambda
;;       lambda -> procedure
;; (lambda (var1) ((set! var1 val1) <body>))

;; every time you call "eval-sequence" the env extend one more time
;; "eval-sequence" is called by "compound-procedure"
;; "compound-procedure" is only called when its tag is 'procedure

;; and when you turn a let into a procedure, it will be sealed with
;; that tag, so the env will extend.

;; If we want to avoid extra env frame, then the let should not be
;; spawned. and the easiest way to achieve that is merge the inner 
;; lambda and outter lambda

; ex 4.18

;; to determine if it works, we have to figure out how <let> works
;; let -> lambda -> procedure

;; in let -> lambda, what actually happends is (eval ((lambda) vals))
;; and the vals will be evaluated one by one, so it won't work.

; ex 4.19

;; why it is an issue? when define is performed on a function, it 
;; will finally be converted to a binding like (var, procedure) in 
;; the given env, nothing else. which means it is lazy eval.

;; however, if it is performed on a parameter, then the parameter
;; will be eval immidiately. which will cause dependency error. 

;; I would throw a error, and the simultaneous define will be devised
;; in my impl of intepretor


; 4.20
(display "\nex 4.20:\n")

(define (letrec->let letrec_exp)
  (let 
    ((defs (cadr letrec_exp))
     (exps (caddr letrec_exp)))
    (make-let 
      (map (lambda (def) (list (car def)  '*unassigned*)) defs) 
      (sequence->exp
        (append (map (lambda (def) (make-assignment (car def) (cadr def))) 
                     defs) 
                (list exps))))))

;; b
;; if you use a let instead of a define, then there will be two env 
;; frames. 
;; (define (f x y) (define a 10) (+ x y a)) => ⌜    env     ⌝
;;                                               x, y, a=10
;;                                             ⌞            ⌟           
;;
;; (define (f x y)   ============================> ⌜  env1  ⌝ 
;;   (let ((a 10)) (+ x y a))) =>  ⌜  env2  ⌝         x, y  
;;                                    a=10    -->  ⌞        ⌟
;;                                 ⌞        ⌟
;; Actually I am a little confused about this question. If the ex 
;; means use let instead of define, then the env will be like above
;; the only thing could be loose is the var name could be covered.
;; like declear a x var instead of a. (In our impl, if in the same
;; scope, the defined var with same name will be updated)
;; 
;; If it means using let to define some var, and leave the body of
;; let empty. then obviously, the env where the var is defined will
;; not be able to be accessed by the scope where the var is used.
;; 
;; OK, now I know why, the above answer is bullshit. The correct 
;; diagram will be like the same as in the following link:
;; https://github.com/kana/sicp/blob/master/ex-4.20.scm
;;
;; if use normal let, (let ((x=<val_of_x>) (y=<val_of_y>)) <body>)
;; will be: 
;;   ((lambda (x y) <body>) (<val_of_x> <val_of_y>))
;; which will be further be evaluated to a procedure with env:
;;   ((procedure (x y) <body> env) (<val_of_x> <val_of_y>))
;; when <val_of_x> and <val_of_y> are evaluated, the env would be 
;; the env where x and y are not defined. In our case, it would be
;; eval of even? would fail cuz of undefined odd?, and vice versa.
;; While if use letrec, <val_of_x> and <val_of_y> will be substituted
;; by 'unassigned, so the eval of even? and odd? as args would 
;; succeed.

; ex 4.21
(display "\nex 4.21:\n")

;; a
(define fibo 
  (lambda (n)
    ((lambda (fact) (fact fact n))
     (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))
  )
(assert (= (fibo 10) 3628800))

;; b
(define (f x)
  ((lambda (even? odd?) (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) #t (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) #f (ev? ev? od? (- n 1))))))

(assert (f 10) #t)


