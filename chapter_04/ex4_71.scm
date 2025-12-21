; Louis Reasoner wonders why the simple-query and disjoin
; procedures (Section 4.4.4.2) are implemented using explicit
; delay operations, rather than being defined as follows:
;
; (define (simple-query query-pattern frame-stream)
;   (stream-flatmap
;     (lambda (frame)
;       (stream-append
;         (find-assertions query-pattern frame)
;         (apply-rules query-pattern frame)))
;     frame-stream))
;
; (define (disjoin disjuncts frame-stream)
;   (if (empty-disjunction? disjuncts)
;     the-empty-stream
;     (interleave
;       (qeval (first-disjunct disjuncts)
;              frame-stream)
;       (disjoin (rest-disjuncts disjuncts)
;                frame-stream))))
;
; Can you give examples of queries where these simpler
; definitions would lead to undesirable behavior?


;; Answer

; According to the hint "This postpones looping in some cases" in
; p655, the question becomes the following two:
;   1. will <apply-rules> or <disjoin> introduce undesirable loop?
;   2. why delay can avoid it?
;
; It turns out delay cant avoid the loop. What a waste of time,
; this is the worst exercise in the book, I guess.
;
; The delay only prevent the hanging, but not the loop.
;
; Bullshit "undesirable behavior". "Undesirable behavior" my ass.


(load "eval_init_query.scm")
(load "eval_impl_query.scm")

; ; ; Uncomment the following code to trigger hanging
; ; (define (simple-query query-pattern frame-stream)
; ;   (stream-flatmap
; ;     (lambda (frame)
; ;       (begin
; ;         (stream-append
; ;           (find-assertions query-pattern frame)
; ;           (apply-rules query-pattern frame))
; ;         )
; ;       )
; ;     frame-stream))
;
; ; (assert! (job teacher devin))
; (define assert1 '(assert! (job teacher devin)))
; (if (assertion-to-be-added? assert1)
;   (add-rule-or-assertion! (add-assertion-body assert1))
;   (print "Not an assertion"))
;
; ; (assert! (rule (hasjob ?x ?y) (job ?x ?y)))
; (define rule1 (query-syntax-process '(assert! (rule (hasjob ?x ?y) (job ?x ?y)))))
; (if (assertion-to-be-added? rule1)
;   (add-rule-or-assertion! (add-assertion-body rule1))
;   (print "Not an assertion"))
; ; (assert! (rule (job ?x ?y) (hasjob ?x ?y)))
; (define rule2 (query-syntax-process '(assert! (rule (job ?x ?y) (hasjob ?x ?y)))))
; (if (assertion-to-be-added? rule2)
;   (add-rule-or-assertion! (add-assertion-body rule2))
;   (print "Not an assertion"))
;
; (define test-query (query-syntax-process '(job ?x devin)))
;
; (display-stream
;   (stream-map
;     (lambda (frame)
;       (instantiate test-query frame (lambda (v f)
;                                       (contract-question-mark v))))
;     (simple-query test-query (singleton-stream '()))))
