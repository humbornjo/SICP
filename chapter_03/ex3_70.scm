;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_67.scm")
(load "./ex3_54.scm")

(define (merge-weighted s1 s2 w)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2))
                (s1w (w (stream-car s1)))
                (s2w (w (stream-car s2))))
            (cond ((< s1w s2w)
                   (cons-stream
                     s1car
                     (merge-weighted (stream-cdr s1) s2 w)))
                  (else
                    (cons-stream
                      s2car
                      (merge-weighted s1 (stream-cdr s2) w))))))))

(define (weighted-pairs s t w)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
      (weighted-pairs (stream-cdr s) (stream-cdr t) w)
      w)))

; a.

(define stream-a
  (weighted-pairs integers integers (lambda (x) (+ (car x) (cadr x)))))

(define expected-a (list 1 3))

(assert (equal? expected-a (stream-ref stream-a 3)))

; b.

(define nor-div
  (stream-filter
    (lambda (x) (not (divisible? x 2)))
    (stream-filter
      (lambda (x) (not (divisible? x 3)))
      (stream-filter
        (lambda (x) (not (divisible? x 5)))
        integers))))

(define stream-b
  (weighted-pairs nor-div nor-div
                  (lambda (x)
                    (+ (* 2 (car x)) (* 3 (cadr x)) (* 5 (car x) (cadr x))))))

(define expected-b (list 1 13))

(assert (equal? expected-b (stream-ref stream-b 3)))
