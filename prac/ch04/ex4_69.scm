; Beginning with the data base and the rules you formulated in
; Exercise 4.63, devise a rule for adding “greats” to a grandson
; relationship. This should enable the system to deduce that Irad
; is the great-grandson of Adam, or that Jabal and Jubal are the
; great-great-great-great-great-grandsons of Adam. (Hint:
; Represent the fact about Irad, for example, as
; ((great grandson) Adam Irad). Write rules that determine if a
; list ends in the word grandson. Use this to express a rule that
; allows one to derive the relationship ((great . ?rel) ?x ?y),
; where ?rel is a list ending in grandson.) Check your rules on
; queries such as ((great grandson) ?g ?ggs) and
; (?relationship Adam Irad).


;; Answer

(load "./ex4_63.scm")

(define rule-end-with-grandson
  (query-syntax-process
    '(rule (end-with-grandson (?x1 . ?xs))
           (or (and
                 (lisp-value null? ?xs)
                 (same ?x1 grandson))
               (end-with-grandson ?xs)))))

(add-rule-or-assertion! rule-end-with-grandson)

(define rule-great-grandson
  (query-syntax-process
    '(rule ((grandson) ?g ?gs)
           (grandson ?g ?gs))))

(add-rule-or-assertion! rule-great-grandson)

(define rule-great-grandson
  (query-syntax-process
    '(rule ((great . ?end) ?g ?gs)
           (and (son ?g ?f)
                (?end ?f ?gs)
                (end-with-grandson ?end)))))

(add-rule-or-assertion! rule-great-grandson)


(define test-input-1 '((great grandson) ?g ?ggs))

(define test-query-1 (query-syntax-process test-input-1))

(define test-expected-1
  '(((great grandson) Mehujael Jubal)
    ((great grandson) Irad Lamech)
    ((great grandson) Mehujael Jabal)
    ((great grandson) Enoch Methushael)
    ((great grandson) Cain Mehujael)
    ((great grandson) Adam Irad)))

(assert (equal? test-expected-1
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-1 frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-1 (singleton-stream '()))))))


(define test-input-2 '(?rel Adam Irad))

(define test-query-2 (query-syntax-process test-input-2))

(define test-expected-2 '(((great grandson) Adam Irad)))

(assert (equal? test-expected-2
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-2 frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-2 (singleton-stream '()))))))
