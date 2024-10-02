;; main

(load "eval_init.scm")

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

;; (define env (extend-environment `(1) `(*unassigned*) the-empty-environment))
;; (lookup-variable-value '1 env)

;; b

(load "eval_impl_metacircular.scm")

(define (scan-out-defines body) 
  (define (collect seq defs exps) 
    (if (null? seq) 
      (cons defs exps) 
      (if (definition? (car seq)) 
        (collect (cdr seq) (cons (car seq) defs) exps) 
        (collect (cdr seq) defs (cons (car seq) exps))))) 
  (let ((pair (collect body '() '()))) 
    (let ((defs (car pair)) (exps (cdr pair))) 
      (make-let (map (lambda (def) `(,(definition-variable def) '*unassigned*)) 
                     defs) 
                (make-begin (append  
                              (map (lambda (def)  
                                     (make-assignment (definition-variable def) 
                                                      (definition-value def))) 
                                   defs) 
                              exps))))))

(define body `((define x 1)
               (define y 2)
               (define z 3)
               (+ x y z)))

(assert (eq? 6 (eval (scan-out-defines body) the-global-environment)))

;; c

;; Install scan-out-defines in the interpreter, either in make-procedure or 
;; in procedure-body (see Section 4.1.3). Which place is better? Why?

;; It depends, <make-procedure> is good when you have a lot compound-procedure
;; to apply while little lambda to define. <procedure-body> is good when you 
;; have a lot of lambda to define, and little compound-procedure to apply.

(define (make-procedure parameters body env) 
  (list 'procedure parameters (scan-out-defines body) env))

(define (procedure-body proc) (scan-out-defines (caddr proc)))
