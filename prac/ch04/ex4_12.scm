;; Original version of env operations

;; (define (lookup-variable-value var env)
;;   (define (env-loop env)
;;     (define (scan vars vals)
;;       (cond ((null? vars) (env-loop (enclosing-environment env)))
;;             ((eq? var (car vars)) (car vals))
;;             (else (scan (cdr vars) (cdr vals)))))
;;     (if (eq? env the-empty-environment)
;;       (error "Unbound variable" var)
;;       (let ((frame (first-frame env)))
;;         (scan (frame-variables frame)
;;               (frame-values frame)))))
;;   (env-loop env))
;;
;; (define (set-variable-value! var val env)
;;   (define (env-loop env)
;;     (define (scan vars vals)
;;       (cond ((null? vars) (env-loop (enclosing-environment env)))
;;             ((eq? var (car vars)) (set-car! vals val))
;;             (else (scan (cdr vars) (cdr vals)))))
;;     (if (eq? env the-empty-environment)
;;       (error "Unbound variable: SET!" var)
;;       (let ((frame (first-frame env)))
;;         (scan (frame-variables frame)
;;               (frame-values frame)))))
;;   (env-loop env))
;;
;; (define (define-variable! var val env)
;;   (let ((frame (first-frame env)))
;;     (define (scan vars vals)
;;       (cond ((null? vars) (add-binding-to-frame! var val frame))
;;             ((eq? var (car vars)) (set-car! vals val))
;;             (else (scan (cdr vars) (cdr vals)))))
;;     (scan (frame-variables frame) (frame-values frame))))


(define (env-first-frame-vars env) (if (null? env) '() (frame-variables (first-frame env))))
(define (env-first-frame-vals env) (if (null? env) '() (frame-values (first-frame env))))

(define (traverse-environment env var err-msg null-action eq-action)
  (define (scan vars vals env)
    (if (eq? env the-empty-environment)
      (error err-msg)
      (cond ((null? vars) (null-action scan vars vals env))
            ((eq? var (car vars)) (eq-action scan vars vals env))
            (else (scan (cdr vars) (cdr vals) env)))))
  (scan (env-first-frame-vars env) (env-first-frame-vals env) env))

(define (my-lookup-variable-value var env) 
  (traverse-environment 
    env var "Unbound variable"
    (lambda (scan vars vals env) (scan (env-first-frame-vars (enclosing-environment env))
                                       (env-first-frame-vals (enclosing-environment env))
                                       env))
    (lambda (scan vars vals env) (car vals))))

(define (my-set-variable-value! var val env) 
  (traverse-environment 
    env var "Unbound variable: SET!"
    (lambda (scan vars vals env) (scan (env-first-frame-vars (enclosing-environment env))
                                       (env-first-frame-vals (enclosing-environment env))
                                       env))
    (lambda (scan vars vals env) (set-car! vals val))))

(define (my-define-variable! var val env) 
  (traverse-environment 
    env var "Variable already defined"
    (lambda (scan vars vals env) (add-binding-to-frame! var val (first-frame env)))
    (lambda (scan vars vals env) (set-car! vals val))))

;; main 

(load "eval_init.scm")

(define env (extend-environment (list '1 '2 '3) (list 9 8 7) the-empty-environment))

(assert (eq? 9 (my-lookup-variable-value '1 env)))
(assert (eq? 8 (my-lookup-variable-value '2 env)))
(assert (eq? 7 (my-lookup-variable-value '3 env)))

(my-set-variable-value! 2 99 env)
(assert (eq? 99 (my-lookup-variable-value 2 env)))

(my-define-variable! '5 88 env)
(assert (eq? 88 (my-lookup-variable-value 5 env)))
