;; Answer

(load "./ex3_18.scm")

(define (python-constant x)
  (define slow x)
  (define fast (cdr x))
  (define (inner s f)
    (if (or (null? s) (null? f) (null? (cdr f)))
      #f
      (if (eq? s f)
        #t
        (inner (cdr s) (cddr f)))))
  (inner slow fast))

(assert (python-constant z))
(assert (not (python-constant (list 'a 'b))))
