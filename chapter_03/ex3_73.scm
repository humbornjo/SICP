;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_70.scm")
(load "./ex3_67.scm")
(load "./ex3_54.scm")

(define (RC r c dt)
  (define (inner s v0)
    (define is1
      (cons-stream
        v0
        (add-streams is1 (scale-stream s (/ dt c)))))
    (define is2
      (scale-stream s r))
    (add-streams is1 is2))
  inner)
