; Define a rule that says that a person is a “big shot” in a
; division if the person works in the division but does not have
; a supervisor who works in the division.


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-can-replace
  (query-syntax-process
    '(rule (is-big-shot ?person)
      (and (job ?person (?division . ?x))
           (supervisor ?person ?supervisor)
           (not (job ?supervisor (?division . ?y)))))))

(add-rule-or-assertion! rule-can-replace)

(define test-input '(is-big-shot ?x))

(define test-query (query-syntax-process test-input))

(define test-expected
  '((is-big-shot (Scrooge Eben))
    (is-big-shot (Bitdiddle Ben))))

(assert (equal? test-expected
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query frame (lambda (v f)
                                                      (contract-question-mark v))))
                    (qeval test-query (singleton-stream '()))))))

