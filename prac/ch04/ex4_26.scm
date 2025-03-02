;; main

(load "init_util.scm")

(define (unless->if exp)
  (let 
    ((exp-cond (cadr exp))
     (exp-then (caddr exp))
     (exp-exception (cadddr exp)))
    (make-if exp-cond exp-exception exp-then)
    ))

(assert 
  (= 120 
     (eval 
       `(begin
          (define (factorial n)
            ,(unless->if '(unless (= n 1)
                            (* n (factorial (- n 1)))
                            1)))
          (factorial 5)
          ))
     ))

;; give an example of a situation where it might be useful 
;; to have unless available as a procedure, rather than as a 
;; special form.
;;
;; (map unless conditions consequents exceptions)
