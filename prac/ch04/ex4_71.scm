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
; 1. How delay could postpones looping.
; 2. What undesirable behavior could occur without postponing.

; 1. Anything got "delayed" becomes a promise in Scheme
;    primitives. It will be evaluated when forced. So the only
;    difference is that the non-delayed (apply-rules ...) might
;    introduce infinite loop.
;
;    Say we apply two rules:
;    - (rule (job ?x ?y) (work ?x ?z))
;    - (rule (work ?x ?y) (job ?x ?z))





