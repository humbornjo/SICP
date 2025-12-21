;; Answer

(load "./ex3_04.scm")

(define (make-joint acc pass npass)
  (lambda (p m)
    (cond
      ((eq? p npass) (acc pass m))
      (else (acc p m)))))

(define acc (make-account 100 'secret-password))
(assert (eq? 80 ((acc 'secret-password 'withdraw) 20)))

(define paul-acc (make-joint acc 'secret-password 'rosebud))
(define jack-acc (make-joint paul-acc 'rosebud 'doragon))

(assert (eq? 60 ((jack-acc 'doragon 'withdraw) 20)))
