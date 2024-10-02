; Louis Reasoner mistakenly deletes the outranked-by rule
; (Section 4.4.1) from the data base. When he realizes this, he
; quickly reinstalls it. Unfortunately, he makes a slight change
; in the rule, and types it in as
;
; (rule (outranked-by ?staff-person ?boss)
;       (or (supervisor ?staff-person ?boss)
;           (and (outranked-by ?middle-manager ?boss)
;                (supervisor ?staff-person
;                            ?middle-manager))))
;
; Just after Louis types this information into the system, DeWitt
; Aull comes by to find out who outranks Ben Bitdiddle. He issues
; the query
;
; (outranked-by (Bitdiddle Ben) ?who)
;
; After answering, the system goes into an infinite loop.
; Explain why.


;; Answer

; Original rule:
;
; (rule (outranked-by ?staff-person ?boss)
;       (or (supervisor ?staff-person ?boss)
;           (and (supervisor ?staff-person ?middle-manager)
;                (outranked-by ?middle-manager ?boss))))
;
; The clause order changes. And the `or` syntax would not affect
; the clauses results, so only the second cluase of `or` syntax
; would be discussed.
;
; In effect, `staff-person` is bound to `Bitdiddle Ben`. Then the
; Interpreter eval hte rule body, the first clause of `or` syntax
; is just eval-ed, the second, however, when first eval-ed, bind
; to no value, thus produce no new frame. And the Interpreter
; eval `(outranked-by ?middle-manager ?boss)` with exactly the
; same frame as before, but even worse - not any bindings for any
; the input params of rule. There the infinite loop begins.
;
; When rule is with the original clause order, the Interpreter
; first eval `(supervisor ?staff-person ?middle-manager)` with
; `staff-person` is bound to `Bitdiddle Ben` and `middle-manager`,
; which will produce a series of frame that satisfy the assertion,
; these frames (with `middle-manager` bounded) will be passed to
; `(outranked-by ?middle-manager ?boss)`, narrow down the search
; space, and finally produce the answer.
