;; Answer

(load "../init.scm")

(define (* a b)
  (cond ((= b 0) 0)
        ((even? b) (double (* a (halve b))))
        (else (+ a (* a (- b 1))))))

(assert (eq? 12 (* 3 4)))
