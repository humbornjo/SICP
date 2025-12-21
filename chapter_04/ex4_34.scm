; Modify the driver loop for the evaluator so that lazy pairs and
; lists will print in some reasonable way. (What are you going to
; do about infinite lists?) You may also need to modify the
; representation of lazy pairs so that the evaluator can identify
; them in order to print them.


;; Answer

(load "eval_init.scm")
(load "eval_impl_normal_memo.scm")

; object might be a lazy pair expression
(define (user-print object)
  (cond
    ((compound-procedure? object)
     (display (list 'compound-procedure
                    (procedure-parameters object)
                    (procedure-body object)
                    '<procedure-env>)))
    ((slacker? object) (print-slacker object))
    (else (display object))))

(actual-value
  `(begin
     (define cons-native cons)
     (define car-native car)
     (define cdr-native cdr)

     (define (cons x y)
       (cons-native 'slacker (lambda (m) (m  x y))))
     (define (car z)
       ((cdr-native z) (lambda (p q) p)))
     (define (cdr z)
       ((cdr-native z) (lambda (p q) q)))

     (define (print-slacker obj)
       (begin
         (display "#slacker ")
         (display (car obj))
         (if (not (null? (car (cdr obj))))
           (begin
             (display " ")
             (display (car (cdr obj)))
             (if (not (null? (car (cdr (cdr obj)))))
               (display " ...\n"))
             ))
         ))

     (define list-exp (cons 'a (cons 'b (cons 'c (cons 'd '())))))
     (assert (eq? 'slacker (car-native list-exp)))
     ; (print-slacker list-exp) ; will print #slacker a b ...
     ) the-global-environment)
