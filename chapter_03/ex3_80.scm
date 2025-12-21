;; Answer

(load "./eval_init_stream.scm")

(define (RLC r l c dt)
  (define (inner vc0 il0)
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (stream-map (lambda (x) (/ x (* -1 c))) il))
    (define dil (add-streams (scale-stream vc (/ 1 l)) (scale-stream il (/ r (* -1 l)))))
    (cons vc il))
  inner)
