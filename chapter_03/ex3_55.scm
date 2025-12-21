;; Answer

(load "./eval_init_stream.scm")
(load "./ex3_54.scm")

; My answer

(define (partial-sum s)
  (define (iter ss)
    (cons-stream
      (stream-car ss)
      (iter (add-streams s (stream-cdr ss)))))
  (iter s))

; http://community.schemewiki.org/?sicp-ex-3.55 @huntzhan
;
; what a beautiful def

(define (partial-sums s)
  (add-streams s (cons-stream 0 (partial-sums s))))

(assert (eq? 15 (stream-ref (partial-sum integers) 4)))
