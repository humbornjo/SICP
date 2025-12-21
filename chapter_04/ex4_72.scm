; Why do disjoin and stream-flatmap interleave the streams rather
; than simply append them? Give examples that illustrate why
; interleaving works beer. (Hint: Why did we use interleave in
; Section 3.5.3?)


;; Answer

; It is to make sure every stream can be processed and displayed,
; even some stream would cause infinite loop. Refer to the
; example below, without interleave, the loop will always trapped
; in the first stream, producing only (job teacher devin).


(load "eval_init_query.scm")
(load "eval_impl_query.scm")

; ; (assert! (job teacher devin))
; (define assert1 '(assert! (job teacher devin)))
; (if (assertion-to-be-added? assert1)
;   (add-rule-or-assertion! (add-assertion-body assert1))
;   (print "Not an assertion"))
;
; ; (assert! (part-time teacher devin))
; (define assert1 '(assert! (part-time programmer devin)))
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
; ; (assert! (rule (job ?x ?y) (part-time ?x ?y)))
; (define rule2 (query-syntax-process '(assert! (rule (job ?x ?y) (part-time ?x ?y)))))
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
