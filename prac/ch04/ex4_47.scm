;; Louis Reasoner suggests that, since a verb phrase is either a
;; verb or a verb phrase followed by a prepositional phrase, it
;; would be much more straightforward to define the procedure
;; parse-verb-phrase as follows (and similarly for noun phrases):
;;
;; (define (parse-verb-phrase)
;;   (amb (parse-word verbs)
;;        (list 'verb-phrase
;;              (parse-verb-phrase)
;;              (parse-prepositional-phrase))))
;;
;; Does this work? Does the program’s behavior change if we
;; interchange the order of expressions in the amb?


;; Answer

; It wont work, because `parse-word` would consume a input, which
; means, as long as the stream is not exhausted, it will `amb`
; the next alternative. Resulting in endless recursion.
;
; If we interchange the order of operands, it will be indefinitely
; and recursively trapped inside `parse-verb-phrase` on invoking
; `parse-prepositional-phrase` without trying to parse single verb.
