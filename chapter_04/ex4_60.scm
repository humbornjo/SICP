; By giving the query
;
; (lives-near ?person (Hacker Alyssa P))
;
; Alyssa P. Hacker is able to find people who live near her, with
; whom she can ride to work. On the other hand, when she tries to
; find all pairs of people who live near each other by querying
;
; (lives-near ?person-1 ?person-2)
;
; she notices that each pair of people who live near each other
; is listed twice; for example,
;
; (lives-near (Hacker Alyssa P) (Fect Cy D))
; (lives-near (Fect Cy D) (Hacker Alyssa P))
;
; Why does this happen? Is there a way to find a list of people
; who live near each other, in which each pair appears only once?
; Explain.


;; Answer

; There are two ideas
; 1. dedup the pair results
; 2. prevent the dup pair at the very beginning <-

; I do not think of a way to dedup the pair results, but prevent
; the dup pair can always be accomplished by constructing a
; partial-ordered relation.

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-lives-near
  (query-syntax-process
    '(rule (lives-near ?person-1 ?person-2)
           (and (address ?person-1 (?town . ?rest-1))
                (address ?person-2 (?town . ?rest-2))
                (not (same ?person-1 ?person-2))))))

(add-rule-or-assertion! rule-lives-near)


(define rule-live-near-but
  (query-syntax-process
    '(rule (lives-near-but ?person-1 ?person-2)
           (and (lives-near ?person-1 ?person-2)
                (lisp-value (lambda (x y)
                              (string<? (symbol->string (car x)) (symbol->string (car y))))
                            ?person-1
                            ?person-2)))))

(add-rule-or-assertion! rule-live-near-but)

(define test-input '(lives-near-but ?person-1 (Hacker Alyssa P)))

(define test-query (query-syntax-process test-input))

(define test-expected
  '((lives-near-but (Fect Cy D) (Hacker Alyssa P))))

(assert (equal? test-expected (collect-stream
                                (stream-map
                                  (lambda (frame)
                                    (instantiate test-query frame (lambda (v f)
                                                                    (contract-question-mark v))))
                                  (qeval test-query (singleton-stream '()))))))
