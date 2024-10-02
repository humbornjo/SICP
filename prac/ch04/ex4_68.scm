; Define rules to implement the reverse operation of Exercise
; 2.18, which returns a list containing the same elements as a
; given list in reverse order. (Hint: Use append-to-form.) Can
; your rules answer both (reverse (1 2 3) ?x) and
; (reverse ?x (1 2 3)) ?


;; Answer

; My answer can not handle both, because the stop condition is
; (append-to-form () ?y ?y), which can only be triggered by
; (reverse ?x (1 2 3)) with my solution.

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-append-to-form
  (query-syntax-process
    '(rule (append-to-form () ?y ?y))))

(add-rule-or-assertion! rule-append-to-form)

(define rule-append-to-form
  (query-syntax-process
    '(rule (append-to-form (?u . ?v) ?y (?u . ?z))
           (append-to-form ?v ?y ?z))))

(add-rule-or-assertion! rule-append-to-form)

(define rule-reverse
  (query-syntax-process
    '(rule (reverse ?x ?x)
           (same ?x (?xx . ())))))

(add-rule-or-assertion! rule-reverse)

(define rule-reverse
  (query-syntax-process
    '(rule (reverse (?x1 . ?xs) ?y)
           (and (append-to-form ?rxs (?x1) ?y)
                (reverse ?xs ?rxs)))))

(add-rule-or-assertion! rule-reverse)

(define test-input '(reverse ?x (1 2 3)))

(define test-query (query-syntax-process test-input))

(define test-expected
  '((reverse (3 2 1) (1 2 3))))

(assert (equal? test-expected
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query frame (lambda (v f)
                                                      (contract-question-mark v))))
                    (qeval test-query (singleton-stream '()))))))
