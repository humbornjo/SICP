; (define (eval-sequence exps env)
;   (cond ((last-exp? exps) (eval (first-exp exps) env))
;         (else (actual-value (first-exp exps) env)
;               (eval-sequence (rest-exps exps) env))))

;; a
;;
;; Ben Bitdiddle thinks Cy is wrong. He shows Cy the for-each
;; procedure described in Exercise 2.23, which gives an important
;; example of a sequence with side effects:
;;
;; (define (for-each proc items)
;;   (if (null? items)
;;     'done
;;     (begin (proc (car items))
;;            (for-each proc (cdr items)))))
;;
;; He claims that the evaluator in the text (with the original
;; eval-sequence) handles this correctly:
;;
;; ;;; L-Eval input:
;; (for-each (lambda (x) (newline) (display x))
;;           (list 57 321 88))
;; 57
;; 321
;; 88
;; ;;; L-Eval value:
;; done
;;
;; Explain why Ben is right about the behavior of for-each.

;; Explain
;;
;; To clearify, it's of vital to understand when the eval-sequence
;; will be called. The eval-sequence occurs in apply.
;; And for the for-each precedure,
;;   * items in "if (null? items)" is forced by primitive null?
;;   * proc in "(proc (car items))" is forced by being operator
;;   * items in "(proc (car items))" is forced by primitive car


;; b
;;
;; Cy agrees that Ben is right about the for-each example, but
;; says that that’s not the kind of program he was thinking about
;; when he proposed his change to eval-sequence. He defines the
;; following two procedures in the lazy evaluator:
;;
;; (define (p1 x)
;;   (set! x (cons x '(2)))
;;   x)
;; (define (p2 x)
;;   (define (p e)
;;     e
;;     x)
;;   (p (set! x (cons x '(2)))))
;;
;; What are the values of (p1 1) and (p2 1) with the original
;; eval-sequence? What would the values be with Cy’s proposed
;; change to eval-sequence?

;; (p1 1)
;;   * original => (1 . (2))
;;   * proposed => (1 . (2))
;;
;; (p2 1)
;;   * original => 1
;;   * proposed => (1 . (2))

;; Explain
;;
;; (p2 1) with original eval-sequence
;; => (p (set! x (cons x '(2))))
;; => ('thunk (set! x (cons x '(2))) env) # eval thunk, do nothing
;;    1


;; c
;;
;; Cy also points out that changing eval-sequence as he proposes
;; does not affect the behavior of the example in part a. Explain
;; why this is true.

;; Explain
;;
;; Cuz the for-each procedure only has one clause.


;; d
;;
;; How do you think sequences ought to be treated in the lazy
;; evaluator? Do you like Cy’s approach, the approach in the text,
;; or some other approach?
;;

;; Explain
;;
;; I think Cy's approch is fine, but it will cause inconsistency
;; when the invokation and usage is separated. Which will lead to
;; hell of debugging.
;;
;; Like in ex4.27
;;
;; (define w (id (id 10)))
;; w
;;
;; If we produce other expr in between these two lines that involves
;; the side effect var, say, count. Then the context will be mixed
;; up.
;; I dont think there is a fix under the current arch. So Cy's is
;; fine overall.
