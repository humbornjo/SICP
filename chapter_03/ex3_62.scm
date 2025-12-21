;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_59.scm")
(load "./ex3_60.scm")
(load "./ex3_61.scm")

(define (div-series s1 s2)
  (mul-series s1 (invert-unit-series s2)))

(define tangent-series (div-series sine-series cosine-series))
