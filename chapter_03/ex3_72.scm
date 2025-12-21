;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_70.scm")
(load "./ex3_67.scm")
(load "./ex3_54.scm")

(define ordered-square
  (weighted-pairs integers integers (lambda (x) (+ (square (car x)) (square (cadr x))))))

(define (square-sum x)
  (+ (square (car x)) (square (cadr x))))

(define (ramen s)
  (let ((x1 (stream-car s))
        (x2 (stream-car (stream-cdr s)))
        (x3 (stream-car (stream-cdr (stream-cdr s)))))
    (if (= (square-sum x1) (square-sum x2) (square-sum x3))
      (cons-stream
        (list x1 x2 x3)
        (ramen (stream-cdr s)))
      (ramen (stream-cdr s)))))

(define ramen-stream (ramen ordered-square))


(define expected-1 (list (list 13 16) (list 8 19) (list 5 20)))

(assert (equal? expected-1 (stream-ref ramen-stream 1)))

(define expected-2 (list (list 15 25) (list 11 27) (list 3 29)))

(assert (equal? expected-2 (stream-ref ramen-stream 5)))
