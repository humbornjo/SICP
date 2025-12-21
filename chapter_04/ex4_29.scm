; Exhibit a program that you would expect to run much more slowly
; without memoization than with memoization. Also, consider the
; following interaction, where the id procedure is defined as in
; Exercise 4.27 and count starts at 0:

; (define (square x) (* x x))
; ;;; L-Eval input:
; (square (id 10))
; ;;; L-Eval value:
; ⟨response⟩
; ;;; L-Eval input:
; count
; ;;; L-Eval value:
; ⟨response⟩

; Give the responses both when the evaluator memoizes and when it
; does not.

; (define count 0)
; (define (id x) (set! count (+ count 1)) x)

;; Program
(define urmom
  (lambda (x cnt)  ; when cnt is really big, memo would be useful
    (if (= cnt 0)
      x
      (urmom (* x x) (- cnt 1)))))

;; non-memorized

; (define (square x) (* x x))
; ;;; L-Eval input:
; (square (id 10))
; ;;; L-Eval value:
; ⟨response⟩        => 100
; ;;; L-Eval input:
; count
; ;;; L-Eval value:
; ⟨response⟩        => 2

;; memorized

; (define (square x) (* x x))
; ;;; L-Eval input:
; (square (id 10))
; ;;; L-Eval value:
; ⟨response⟩        => 100
; ;;; L-Eval input:
; count
; ;;; L-Eval value:
; ⟨response⟩        => 1


;; Test
(load "eval_init.scm")

;; non-memorized
(load "eval_impl_normal.scm")

(assert (eq?
          100
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define (square x) (* x x))
                           (square (id 10))
                           ) the-global-environment)))

(assert (eq?
          102
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define (square x) (* x x))
                           (+ (square (id 10)) count)
                           ) the-global-environment)))


;; memorized
(load "eval_impl_normal_memo.scm")
(assert (eq?
          100
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define (square x) (* x x))
                           (square (id 10))
                           ) the-global-environment)))

(assert (eq?
          101
          (actual-value `(begin
                           (define count 0)
                           (define (id x) (set! count (+ count 1)) x)
                           (define (square x) (* x x))
                           (+ (square (id 10)) count)
                           ) the-global-environment)))
