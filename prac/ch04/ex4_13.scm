(define (make-unbound! var env)
  (define (scan curr-vars curr-vals prev-vars prev-vals)
    (cond ((null? curr-vars) (error "Unbound variable: DO NOTHING!" var))
          ((eq? var (car curr-vars)) (if (eq? prev-vars '())
                                       (set-car! prev-vals (cdr curr-vars))
                                       (set-cdr! prev-vars (cdr curr-vars)))
                                     (set-cdr! prev-vals (cdr curr-vals)))
          (else (scan (cdr curr-vars) (cdr curr-vals) curr-vars curr-vals))))
  (if (eq? env the-empty-environment)
    (error "Unbound variable: DO NOTHING!" var)
    (let* ((frame (first-frame env))
           (vars (frame-variables frame))
           (vals (frame-values frame)))
      (scan vars vals '() frame))))

;; main

;; consider when we need to unbound a definition seems only when we need to refer to 
;; the def in the enclosing frame.

;; e.g. eval impl in the book is not complete yet so test should be performed with
;; native eval. So I believe only the def in curr frame need to be cleared.


(load "eval_init.scm")

(define env (extend-environment `(1 2 3) (list 9 8 7) the-empty-environment))
(make-unbound! '3 env)
(assert (equal? env (extend-environment `(1 2) (list 9 8) the-empty-environment)))
