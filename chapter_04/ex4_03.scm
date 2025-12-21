; Rewrite eval so that the dispatch is done in data-directed
; style. Compare this with the data-directed differentiation
; procedure of Exercise 2.73. (You may use the car of a compound
; expression as the type of the expression, as is appropriate for
; the syntax implemented in this section.)

;; Answer

; Original eval

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

; data-directed eval
;
; The implementation is omitted, below is a prototype satisfies
; the description of the exercise. For the cond that can not be
; checked with car, we can add some more if clause (or just
; leave it outside the data-directed table)

(load "../chapter_03/eval_init_table.scm")

(define (tag exp)
  (if (pair? exp)
    (car exp) nil))

(define (eval exp env)
  (let ((proc (get (tag exp) 'eval)))
    (if proc
      (proc exp env)
      (error "Unknown expression type: EVAL" exp))))
