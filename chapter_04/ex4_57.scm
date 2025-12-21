; Define a rule that says that person 1 can replace person 2 if
; either person 1 does the same job as person 2 or someone who
; does person 1’s job can also do person 2’s job, and if person 1
; and person 2 are not the same person. Using your rule, give
; queries that find the following:
;
; a. all people who can replace Cy D. Fect;
; b. all people who can replace someone who is being paid
;    more than they are, together with the two salaries.


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-can-replace
  (query-syntax-process
    '(rule (can-replace ?person1 ?person2)
           (and (or (and (job ?person1 ?job1)
                         (job ?person2 ?job2)
                         (same ?job1 ?job2))
                    (and (job ?person1 ?job1)
                         (job ?person2 ?job2)
                         (can-do-job ?job1 ?job2)))
                (not (same ?person1 ?person2))))))

(add-rule-or-assertion! rule-can-replace)

; a.
(define test-input-a '(can-replace ?x (Fect Cy D)))

(define test-query-a (query-syntax-process test-input-a))

(define test-expected-a
  '((can-replace (Bitdiddle Ben) (Fect Cy D))
    (can-replace (Hacker Alyssa P) (Fect Cy D))))

(assert (equal? test-expected-a
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-a frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-a (singleton-stream '()))))))

; b.
(define test-input-b
  '(and (can-replace ?x ?y)
        (salary ?x ?amt_x)
        (salary ?y ?amt_y)
        (lisp-value < ?amt_x ?amt_y)))

(define test-query-b (query-syntax-process test-input-b))

(define test-expected-b
  '((and (can-replace (Aull DeWitt) (Warbucks Oliver))
         (salary (Aull DeWitt) 25000)
         (salary (Warbucks Oliver) 150000)
         (lisp-value < 25000 150000))
    (and (can-replace (Fect Cy D) (Hacker Alyssa P))
         (salary (Fect Cy D) 35000)
         (salary (Hacker Alyssa P) 40000)
         (lisp-value < 35000 40000))))

(assert (equal? test-expected-b
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-b frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-b (singleton-stream '()))))))
