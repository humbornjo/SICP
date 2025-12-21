;; Answer

(load "./eval_init_sym.scm")

(define (augend s)
  (let ((ps (cddr s)))
    (if (= (length ps) 1)
      (car ps)
      (cons '+ ps))))

(define (multiplicand s)
  (let ((ps (cddr s)))
    (if (= (length ps) 1)
      (car ps)
      (cons '* ps))))

; (display (deriv '(* x y (+ x 3)) 'x))
