; eval uses actual-value rather than eval to evaluate the operator
; before passing it to apply, in order to force the value of the
; operator. Give an example that demonstrates the need for this
; forcing.

;; Explain
;;
;; the question is essentially about whether the operator could
;; be thunk or not. Or further, could primitive operator be delayed?
;;
;; <delay-it> is only used in <list-of-delayed-args> in <apply>
;;
;; 1. primitive operator
;;   ('thunk (+) env)
;;   not seemingly possible
;; 2. compound operator
;;   ('thunk (func1 x y) env)
;;   see the pass below, as long as we dont trigger the primitive
;;   operator eval, thunk will be spawned and ruins the eval.
;;
;; In a word, the key point is that when the compound application
;; opperator's params is not coupled with the primitive operator,
;; thunk will be spawned, which cant be resolved by eval.

(load "eval_init.scm")
(load "eval_impl_normal.scm")

;; uncomment the following to see the expected error
; (define (eval exp env)
;   (begin
;     (if DEBUG
;       (begin
;       (display "calling eval: ")
;       (display exp)
;       (newline)))
;     (cond ((self-evaluating? exp) exp)
;           ((variable? exp) (lookup-variable-value exp env))
;           ((quoted? exp) (text-of-quotation exp))
;           ((assignment? exp) (eval-assignment exp env))
;           ((definition? exp) (eval-definition exp env))
;           ((if? exp) (eval-if exp env))
;           ((lambda? exp) (make-procedure (lambda-parameters exp)
;                                          (lambda-body exp)
;                                          env))
;           ((let? exp) (eval (let->combination exp) env))
;           ((begin? exp)
;            (eval-sequence (begin-actions exp) env))
;           ((cond? exp) (eval (cond->if exp) env))
;           ((application? exp)
;            (apply (eval (operator exp) env)   ; changed here
;                   (operands exp)
;                   env))
;           (else
;             (error "Unknown expression type: EVAL" exp))))
;   )

(assert (eq?
          5
          (eval
            `(begin
               (define add (lambda (x y) (+ x y)))
               (define (pass x) x)
               ((pass add) 2 3))
            the-global-environment)))


