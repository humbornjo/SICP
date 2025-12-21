; Define rules to implement the last-pair operation of Exercise
; 2.17, which returns a list containing the last element of a
; nonempty list. Check your rules on queries such as
; (last-pair (3) ?x), (last-pair (1 2 3) ?x) and
; (last-pair (2 ?x) (3)). Do your rules work correctly on queries
; such as (last-pair ?x (3)) ?


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-last-pair
  (query-syntax-process
    '(rule (last-pair (?x . ?y) (?x))
           (lisp-value null? ?y))))

(add-rule-or-assertion! rule-last-pair)

(define test-input-1 '(last-pair (3) ?x))

(define test-query-1 (query-syntax-process test-input-1))

(define test-expected-1 '((last-pair (3) (3))))

(assert (equal? test-expected-1
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-1 frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-1 (singleton-stream '()))))))

(define rule-last-pair
  (query-syntax-process
    '(rule (last-pair (?x . ?y) ?z)
           (last-pair ?y ?z))))

(add-rule-or-assertion! rule-last-pair)

(define test-input-2 '(last-pair (1 2 3) ?x))

(define test-query-2 (query-syntax-process test-input-2))

(define test-expected-2 '((last-pair (1 2 3) (3))))

(assert (equal? test-expected-2
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-2 frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-2 (singleton-stream '()))))))

(define rule-last-pair
  (query-syntax-process
    '(rule (last-pair (?x . ?y) (?x . ?y))
           (and (lisp-value null? ?x)
                (lisp-value null? ?y)))))

(add-rule-or-assertion! rule-last-pair)


; ; Indefinitely search for ?y, which is actually nil.
; ;
; ; (last-pair ?x (3)) will not work until first arg contains no
; ; (?x . ?y) structure.
;
; (define test-input-3 '(last-pair ?x (3)))
;
; (define test-query-3 (query-syntax-process test-input-3))
;
; (define test-expected-3 '((last-pair (3) (3))))
;
; (assert (equal? test-expected-3
;                 (collect-stream
;                   (stream-map
;                     (lambda (frame)
;                       (instantiate test-query-3 frame (lambda (v f)
;                                                         (contract-question-mark v))))
;                     (qeval test-query-3 (singleton-stream '()))))))
