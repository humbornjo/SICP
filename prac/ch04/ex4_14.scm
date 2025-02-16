;; main 

;; when i call the native map, such error popped up
;; Error: call of non-procedure: (primitive #<procedure (scheme#car x)>)

;; (define (list-of-values exps env)
;;   (if (no-operands? exps)
;;     '()
;;     (cons (eval (first-operand exps) env)
;;           (list-of-values (rest-operands exps) env))))

;; when eval (map car (list (cons 1 3))). the native <map> will use native <apply>
;; on <car> and the rest of the args. however, the <car> func after eval is not 
;; just a procedure, but (primitive #<procedure (scheme#car x)>).

;; so either impl a map use the apply defined by us, or, try to eval <car> as native
;; <car> only.

