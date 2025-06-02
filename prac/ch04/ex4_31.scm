; The approach taken in this section is somewhat unpleasant,
; because it makes an incompatible change to Scheme. It might be
; nicer to implement lazy evaluation as an upward-compatible
; extension, that is, so that ordinary Scheme programs will work
; as before. We can do this by extending the syntax of procedure
; declarations to let the user control whether or not arguments
; are to be delayed. While we’re at it, we may as well also give
; the user the choice between delaying with and without memoization.
; For example, the definition
;
; (define (f a (b lazy) c (d lazy-memo))
;   ...)
;
; would define f to be a procedure of four arguments, where the
; first and third arguments are evaluated when the procedure is
; called, the second argument is delayed, and the fourth argument
; is both delayed and memoized. us, ordinary procedure definitions
; will produce the same behavior as ordinary Scheme, while adding
; the lazy-memo declaration to each parameter of every compound
; procedure will produce the behavior of the lazy evaluator
; defined in this section. Design and implement the changes
; required to produce such an extension to Scheme. You will have
; to implement new syntax procedures to handle the new syntax for
; define. You must also arrange for eval or apply to determine
; when arguments are to be delayed, and to force or delay arguments
; accordingly, and you must arrange for forcing to memoize or
; not, as appropriate.


;; Answer

(load "init_util.scm")
(load "eval_normalmemo.scm")

(define procedure-parameters
  (lambda (procedure)
    (map (lambda (param)
           (if (pair? param)
             (car param)
             param))
         (cadr procedure))))

(define list-of-delayed-args
  (lambda (pats exps env)
    (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand pats) (first-operand exps) env)
            (list-of-delayed-args (rest-operands pats) (rest-operands exps) env)
            ))))

(define (thunk-memo? obj) (tagged-list? obj 'thunk-memo))

(define (force-it obj)
  (cond ((thunk? obj)
         (actual-value (thunk-exp obj) (thunk-env obj)))
        ((thunk-memo? obj)
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

(define (lazy? obj)
  (or (and (pair? obj) (eq? (cadr obj) 'lazy))
      (and (pair? obj) (eq? (cadr obj) 'lazy-memo))))

(define (lazy-memo? obj)
  (and (pair? obj) (eq? (cadr obj) 'lazy-memo)))

(define (delay-it pat exp env)
  (cond ((lazy? pat)
         (if (lazy-memo? pat)
           (list 'thunk-memo exp env)
           (list 'thunk exp env))
         )
        (else exp))
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
             (list-of-delayed-args (cadr procedure) arguments env)
             (procedure-environment procedure))))
        (else
          (error
            "Unknown procedure type: APPLY" procedure))))

(assert (eq?
          20
          (eval `(begin
                   (define (f condition (regular lazy) (exception lazy) (extra lazy-memo))
                     (if condition
                       (+ regular extra)
                       (* exception extra)))
                   (f #f (/ 1 0) 10 2)
                   ) the-global-environment)))

(assert (eq?
          12
          (eval `(begin
                   (define (f condition (regular lazy) (exception lazy) (extra lazy-memo))
                     (if condition
                       (+ regular extra)
                       (* exception extra)))
                   (f #t 10 (/ 1 0) 2)
                   ) the-global-environment)))

