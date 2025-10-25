(load "../init.scm")
(load "../ch03/eval_init_stream.scm")
(load "../ch03/eval_init_table.scm")
(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define test-query (query-syntax-process '(job ?x devin)))


(newline)
(print "Query: ")
(newline)
(print test-query)
(newline)

(define assert1 '(assert! (job teacher devin)))

(if (assertion-to-be-added? assert1)
  (add-rule-or-assertion! (add-assertion-body assert1))
  (print "Not an assertion"))

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
    (lambda (frame)
      (begin
        (newline)
        (print "Rules:")
        (newline)
        (print query-pattern)
        (newline)
        (fetch-rules query-pattern frame)
        (newline)
        (stream-append
          (find-assertions query-pattern frame)
          (delay (apply-rules query-pattern frame)))
        )
      )
    frame-stream))


(define rule1 (query-syntax-process '(assert! (rule (hasjob ?x ?y) (job ?x ?y)))))
(if (assertion-to-be-added? rule1)
  (add-rule-or-assertion! (add-assertion-body rule1))
  (print "Not an assertion"))

(define rule2 (query-syntax-process '(assert! (rule (job ?x ?y) (hasjob ?x ?y)))))
(if (assertion-to-be-added? rule2)
  (add-rule-or-assertion! (add-assertion-body rule2))
  (print "Not an assertion"))

(display-stream
  (stream-map
    (lambda (frame)
      (newline)
      (print "Frame: ")
      (print frame)
      (newline)
      (instantiate test-query frame (lambda (v f)
                                      (newline)
                                      (print "Contracting: ")
                                      (print (contract-question-mark v))
                                      (newline)
                                      (contract-question-mark v))))
    (simple-query test-query (singleton-stream '()))))



; (newline)
; (print "Contracting: ")
; (newline)
; (print (contract-question-mark '((? x) ? y)))


; (query-driver-loop)
; (newline)
; (display-stream (stream-map (lambda (rule)
;                               (begin (print (rename-variables-in rule))
;                               (rename-variables-in rule)))
;                             (get-all-rules)))


