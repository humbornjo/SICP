(load "../init.scm")

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

(define (parse-sentence)
  (list 'sentence
        (parse-noun-phrase)
        (parse-word verbs)))

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend
           (list 'noun-phrase
                 noun-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
           (list 'verb-phrase
                 verb-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

(define (parse-sentence)
  (list 'sentence (parse-noun-phrase) (parse-verb-phrase)))

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))


(define apply-in-underlying-scheme apply)

(define (make-let seq body) (list 'let seq body))
(define (make-begin seq) (cons 'begin seq))
(define (make-lambda parameters body) (cons 'lambda (cons parameters body)))
(define (make-definition func args body) (list 'define (cons func args) body))
(define (make-if predicate consequent alternative) (list 'if predicate consequent alternative))
(define (make-frame variables values) (cons variables values))
(define (make-assignment var exp) (list 'set! var exp))
(define (make-procedure parameters body env) (list 'procedure parameters body env))

(define (cond-clauses exp) (cdr exp))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (variable? exp) (symbol? exp))
(define (application? exp) (pair? exp))
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        ((boolean? exp) true)
        (else false)))
(define (tagged-list? exp tag) (if (pair? exp) (eq? (car exp) tag) false))
(define (if? exp) (tagged-list? exp 'if))
(define (let? exp) (tagged-list? exp 'let))
(define (let*? exp) (tagged-list? exp 'let*))
(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-else-clause? clause) (eq? (cond-predicate clause) 'else))
(define (begin? exp) (tagged-list? exp 'begin))
(define (quoted? exp) (tagged-list? exp 'quote))
(define (lambda? exp) (tagged-list? exp 'lambda))
(define (assignment? exp) (tagged-list? exp 'set!))
(define (definition? exp) (tagged-list? exp 'define))
(define (compound-procedure? exp) (tagged-list? exp 'procedure))
(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (amb? exp) (tagged-list? exp 'amb))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (text-of-quotation exp) (cadr exp))

(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
    false ; no else clause
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

(define (procedure-parameters exp) (cadr exp))
(define (procedure-body exp) (caddr exp))
(define (procedure-environment exp) (cadddr exp))

(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp) (if (not (null? (cdddr exp)))
                               (cadddr exp)
                               false))

(define (let-clauses exp) (cadr exp))
(define (let-clause-var clause) (car clause))
(define (let-clause-value-exp clause) (cadr clause))
(define (let-body exp) (cddr exp))
(define (let->combination let-exp)
  (define vars (map let-clause-var (let-clauses let-exp)))
  (define value-exps (map let-clause-value-exp (let-clauses let-exp)))
  (cons
    (make-lambda vars (let-body let-exp))
    value-exps))
(define (let*->nested-lets exp)
  (define (inner clauses body)
    (if (null? clauses)
      (sequence->exp body)
      (make-let (list (car clauses)) (inner (cdr clauses) body))))
  (inner (cadr exp) (cddr exp)))

(define (amb-choices exp) (cdr exp))
(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))

(define (begin-actions exp) (cdr exp))

(define (definition-variable exp)
  (if (symbol? (cadr exp)) (cadr exp) (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
    (caddr exp)
    (make-lambda (cdadr exp) (cddr exp))))

(define the-empty-environment '())
(define (first-frame env) (car env))
(define (enclosing-environment env) (cdr env))
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


(define assert
  (lambda (p)
    (if (not p)
      (error "Assert failed\n")))
  )


(define (or-local a b)
  (if a a b))

(define (and-local a b)
  (if a b a))

(define (xor-local a b)
  (or-local (and-local a (not b))
            (and-local (not a) b)))

(define (distinct? items)
  (cond ((null? items) #t)
        ((null? (cdr items)) #t)
        ((member (car items) (cdr items)) #f)
        (else (distinct? (cdr items)))))

(define (square x) (* x x))
(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

(define primitive-procedures
  (list (list 'eq? eq?)
        (list 'car car)
        (list 'not not)
        (list 'cdr cdr)
        (list 'cadr cadr)
        (list 'list list)
        (list 'cons cons)
        (list 'null? null?)
        (list 'odd? odd?)
        (list 'even? even?)
        (list 'error error)
        (list 'assert assert)
        (list 'append append)
        (list 'display display)
        (list 'member member)
        (list 'memq memq)
        (list 'abs abs)
        (list '+ +)
        (list '* *)
        (list '- -)
        (list '= =)
        (list '> >)
        (list '< <)
        (list '<= <=)
        (list '>= >=)
        (list 'not not)
        (list 'or or-local)
        (list 'and and-local)
        (list 'xor xor-local)
        (list 'prime? prime?)
        (list 'distinct? distinct?)
        ))
(define (primitive-implementation proc) (cadr proc))
(define (primitive-procedure-names) (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))

(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
                              (primitive-procedure-objects)
                              the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define the-global-environment (setup-environment))

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

(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
        (try-again)
        (begin
          (newline) (display ";;; Starting a new problem ")
          (ambeval
            input
            the-global-environment
            ;; ambeval success
            (lambda (val next-alternative)
              (announce-output output-prompt)
              (user-print val)
              (internal-loop next-alternative))
            ;; ambeval failure
            (lambda ()
              (announce-output
                ";;; There are no more values of")
              (user-print input)
              (driver-loop)))))))
  (internal-loop
    (lambda ()
      (newline) (display ";;; There is no current problem")
      (driver-loop))))
