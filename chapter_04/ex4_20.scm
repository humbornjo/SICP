;; main

;; a
(define (letrec->let letrec_exp)
  (let 
    ((defs (cadr letrec_exp))
     (exps (caddr letrec_exp)))
    (make-let 
      (map (lambda (def) (list (car def)  '*unassigned*)) defs) 
      (sequence->exp
        (append (map (lambda (def) (make-assignment (car def) (cadr def))) 
                     defs) 
                (list exps))))))

;; b

;; if you use a let instead of a define, then there will be two env 
;; frames. 
;; (define (f x y) (define a 10) (+ x y a)) => ⌜    env     ⌝
;;                                               x, y, a=10
;;                                             ⌞            ⌟           
;;
;; (define (f x y)   ============================> ⌜  env1  ⌝ 
;;   (let ((a 10)) (+ x y a))) =>  ⌜  env2  ⌝         x, y  
;;                                    a=10    -->  ⌞        ⌟
;;                                 ⌞        ⌟
;; Actually I am a little confused about this question. If the ex 
;; means use let instead of define, then the env will be like above
;; the only thing could be loose is the var name could be covered.
;; like declear a x var instead of a. (In our impl, if in the same
;; scope, the defined var with same name will be updated)
;; 
;; If it means using let to define some var, and leave the body of
;; let empty. then obviously, the env where the var is defined will
;; not be able to be accessed by the scope where the var is used.
;; 
;; OK, now I know why, the above answer is bullshit. The correct 
;; diagram will be like the same as in the following link:
;; https://github.com/kana/sicp/blob/master/ex-4.20.scm
;;
;; if use normal let, (let ((x=<val_of_x>) (y=<val_of_y>)) <body>)
;; will be: 
;;   ((lambda (x y) <body>) (<val_of_x> <val_of_y>))
;; which will be further be evaluated to a procedure with env:
;;   ((procedure (x y) <body> env) (<val_of_x> <val_of_y>))
;; when <val_of_x> and <val_of_y> are evaluated, the env would be 
;; the env where x and y are not defined. In our case, it would be
;; eval of even? would fail cuz of undefined odd?, and vice versa.
;; While if use letrec, <val_of_x> and <val_of_y> will be substituted
;; by 'unassigned, so the eval of even? and odd? as args would 
;; succeed.
