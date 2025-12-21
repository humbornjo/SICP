; Ben Bitdiddle tests the lazy list implementation given above by
; evaluating the expression:
;
;   (car '(a b c))
;
; To his surprise, this produces an error. After some thought, he
; realizes that the “lists” obtained by reading in quoted expressions
; are different from the lists manipulated by the new definitions
; of cons, car, and cdr. Modify the evaluator’s treatment of quoted
; expressions so that quoted lists typed at the driver loop will
; produce true lazy lists.

;; Answer

(load "eval_init.scm")

(define (text-of-quotation exp)
  (if (and (not (null? (cdr exp))) (pair? (car (cdr exp))))
    (let*
      ((val (cadr exp))
       (first (car val))
       (rest (cdr val)))
      (cond
        ((null? rest) (eval `(lambda (m) (m ',first '())) the-global-environment))
        ((null? (cdr rest)) (eval `(lambda (m) (m ',first ',rest)) the-global-environment))
        (else (eval `(lambda (m) (m ',first (,(car exp) ,(cdr rest)))) the-global-environment)
              ))
      )
    (cadr exp)
    ))

(load "eval_impl_normal.scm")

;; (driver-loop)
;;
;; ;; L-Eval input:
;; (begin
;;   (define (cons x y)
;;     (lambda (m) (m x y)))
;;   (define (car z)
;;     (z (lambda (p q) p)))
;;   (define (cdr z)
;;     (z (lambda (p q) q))))
;;
;; ;; L-Eval value:
;; ok
;;
;; ;; L-Eval input:
;; (car '(a b c))
;;
;; Error: Unknown procedure type: APPLY: (a b c)

(actual-value
  `(begin
     (define (cons x y)
       (lambda (m) (m x y)))
     (define (car z)
       (z (lambda (p q) p)))
     (define (cdr z)
       (z (lambda (p q) q)))

     (assert (eq? 'a (car '(a))))
     (assert (eq? 'a (car '(a b))))
     (assert (eq? 'a (car '(a b c))))
     ) the-global-environment)
