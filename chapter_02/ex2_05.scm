;; Answer

(load "./eval_init.scm")

(define (cons x y)
  (* (expt 2 x) (expt 3 y)))

(define (car x)
  (depow x 2))

(define (cdr x)
  (depow x 3))

(define (depow x b)
  (define (iter e)
    (if (= (remainder x (expt b e)) 0)
      (iter (+ e 1))
      (- e 1)))
  (iter 1))

(define test (cons 11 17))

(assert (eq? 11 (car test)))

(assert (eq? 17 (cdr test)))
