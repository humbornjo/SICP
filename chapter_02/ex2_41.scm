;; Answer

(load "./ex2_40.scm")

; http://community.schemewiki.org/?sicp-ex-2.41 @Woofy's ans is good

(define (sum-of-two n s)
  (filter
    (lambda (x) (= s (+ (car x) (cadr x))))
    (unique-pair n)))

(define (sum-of-three n s)
  (flatmap
    (lambda (x)
      (map
        (lambda (xx) (append (list x) xx))
        (sum-of-two (- x 1) (- s x))))
    (enumerate-interval 1 n)))

; (display (sum-of-three 10 15))
