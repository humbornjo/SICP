; When we implemented the Lisp evaluator in Section 4.1, we saw
; how to use local environments to avoid name conflicts between
; the parameters of procedures. For example, in evaluating
;
; (define (square x) (* x x))
; (define (sum-of-squares x y)
;   (+ (square x) (square y)))
; (sum-of-squares 3 4)
;
; there is no confusion between the x in square and the x in
; sum-of-squares, because we evaluate the body of each procedure
; in an environment that is specially constructed to contain
; bindings for the local variables. In the query system, we used
; a different strategy to avoid name conflicts in applying rules.
; Each time we apply a rule we rename the variables with new
; names that are guaranteed to be unique. The analogous strategy
; for the Lisp evaluator would be to do away with local
; environments and simply rename the variables in the body of a
; procedure each time we apply the procedure.
;
; Implement for the query language a rule-application method that
; uses environments rather than renaming. See if you can build on
; your environment structure to create constructs in the query
; language for dealing with large systems, such as the rule
; analog of block-structured procedures. Can you relate any of
; this to the problem of making deductions in a context (e.g.,
; "If I supposed that P were true, then I would be able to deduce
; A and B.”) as a method of problem solving? (This problem is
; open-ended. A good answer is probably worth a Ph.D.)

;; Answer

; A very intuitive idea is give each rule a namespace, which is
; the conclusion name of rule, building a table structure.
;
; For the nested env, just use the nested tables.
;
; UNITABLE:
; {
;   "rules": <TABLE <STRING, UNITABLE>>,
;
;   "(? x)": <VALUE_X>,
;   "(? y)": <VALUE_Y>,
;   ...
; }
;
; This naturally enchants the evaluator with the ability of
; deducing That is, when a query exec successfully (non 'failed).
; we iterate over the env, all the rules exists in the env whose
; variables are all bound would be the outputs of deduction.
;
; However, I'm pretty sure this idea is not gonna earn me a Ph.D.
; Since the intermediate output is still a lot and lookup
; overhead is non-negligible.
