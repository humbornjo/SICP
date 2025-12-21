;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_70.scm")
(load "./ex3_67.scm")
(load "./ex3_54.scm")

(define ordered-cube
  (weighted-pairs integers integers (lambda (x) (+ (cube (car x)) (cube (cadr x))))))

(define (cube-sum x)
  (+ (cube (car x)) (cube (cadr x))))

(define (ramanujan s)
  (let ((x1 (stream-car s))
        (x2 (stream-car (stream-cdr s))))
    (if (= (cube-sum x1) (cube-sum x2))
      (cons-stream
        (list (stream-car s) (stream-car (stream-cdr s)))
        (ramanujan (stream-cdr s)))
      (ramanujan (stream-cdr s)))))

(define ramanujan-stream (ramanujan ordered-cube))

(define expected-1 (list (list 9 15) (list 2 16)))

(assert (equal? expected-1 (stream-ref ramanujan-stream 1)))

(define expected-2 (list (list 15 33) (list 2 34)))

(assert (equal? expected-2 (stream-ref ramanujan-stream 5)))
