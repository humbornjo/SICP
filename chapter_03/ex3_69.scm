;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_67.scm")
(load "./ex3_54.scm")

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map (lambda (x) (cons (stream-car s) x))
                  (stream-cdr (pairs t u)))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define pythagorean-triples
  (stream-filter
    (lambda (x)
      (let ((i (car x))
            (j (cadr x))
            (k (caddr x)))
        (= (+ (square i) (square j)) (square k))))
    (triples integers integers integers)))

(define expected (list 6 8 10))

(assert (equal? expected (stream-ref pythagorean-triples 1)))
