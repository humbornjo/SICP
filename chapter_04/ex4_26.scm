; load init_util for function like make-lambda, etc.
(load "eval_init.scm")

(define (unless->if unless-exp)
  (let*
    ((condition (cadr unless-exp))
    (usual-value (caddr unless-exp))
    (exceptional-value (cadddr unless-exp))
    (usual-lambda (make-lambda `() (list usual-value)))
    (exceptional-lambda (make-lambda `() (list exceptional-value))))
  `(,(make-if condition usual-lambda exceptional-lambda))
  ))

(define unless-exp
  '(unless #t 1 (/ 1 0)))

(assert  (equal? 1 (eval (unless->if unless-exp))))

;; sure, we can implement unless by deriving it into a if statement
;; but what's the point, but it can never be use in a high order function
;; like map.

;; just imagine you try to do things like
;;
;;       (define high-order-function
;;         (lambda (fn a b)
;;            (fn (symbol? a) a (/ a b))
;;         ))
;;
;; which is illeagel when fn=unless, a=1, b=0 if unless is a syntax - you
;; can't find it in the env frames

;; Example for "unless is good as a procedure":
;;   as is stated above, just make up a high order function like that.
