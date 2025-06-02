;; The evaluators in Section 4.1 and Section 4.2 do not determine
;; what order operands are evaluated in. We will see that the amb
;; evaluator evaluates them from left to right. Explain why our
;; parsing program wouldn’t work if the operands were evaluated
;; in some other order.


;; Answer

; In `(list 'sentence (parse-noun-phrase) (parse-verb-phrase))`,
; if `parse-verb-phrase` is evaluated before `parse-noun-phrase`,
; parser would consume token for verb phrase before noun phrase.
