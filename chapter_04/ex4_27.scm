; Suppose we type in the following definitions to the lazy evaluator:
; (define count 0)
; (define (id x) (set! count (+ count 1)) x)

; Give the missing values in the following sequence of interactions,
; and explain your answers.

; (define w (id (id 10)))
; ;;; L-Eval input:
; count
; ;;; L-Eval value:
; ⟨response⟩      => 1
; ;;; L-Eval input:
; w
; ;;; L-Eval value:
; ⟨response⟩      => 10
; ;;; L-Eval input:
; count
; ;;; L-Eval value:
; ⟨response⟩      => 2

;; Explain
;;
;; (define count 0)
;;   => env:
;;        count = 0
;; (define (id x) (set! count (+ count 1)) x)
;;   => env:
;;        count = 0
;;        id    = ('procedure (x) (set! count (+ count 1)) x)
;; (define w (id (id 10)))
;;   => w is a symbol, so eval (id (id 10))
;;      operator: id, operands: (id 10)
;;      operator is forced by <actual-value>
;;      which emits the eval to precedure body of id
;;      (eval (set! count (+ count 1)) env) makes count++
;;      (eval x env) lead to the thunk list which has no effect
;;      and the arguments (id 10) is delayed by thunk
;;
;;      env:
;;        count = 1
;;        id    = ('procedure (x) (set! count (+ count 1)) x)
;;        ---
;;        w     = ('thunk (id 10) env)
;; count
;;   => 1
;; w
;;   => (actual-value w env)
;;      -> (force-it ('thunk (id 10) env))
;;      -> (eval (id 10) env)
;;      -> 10 | makes count++
;; count
;;   => 2

;; test
(load "eval_init.scm")
(load "eval_impl_normal.scm")

(assert (eq?
          1
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define w (id (id 10)))
                           count
                           ) the-global-environment)))

(assert (eq?
          10
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define w (id (id 10)))
                           count
                           w
                           ) the-global-environment)))

(assert (eq?
          12
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define w (id (id 10)))
                           count
                           (+ w count) ; use + to trigger lazy eval of w
                           ) the-global-environment)))
