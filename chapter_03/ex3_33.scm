;; Answer

(load "./eval_init_simu.scm")

(define (averager a b c)
  (let ((res (make-connector))
        (par (make-connector)))
    (adder a b res)
    (multiplier c par res)
    (constant 2 par)))
