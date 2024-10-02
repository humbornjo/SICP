; Cy D. Fect, looking forward to the day when he will rise in the
; organization, gives a query to find all the wheels (using the
; wheel rule of Section 4.4.1):
;
; (wheel ?who)
;
; To his surprise, the system responds
;
; ;;; Query results:
; (wheel (Warbucks Oliver))
; (wheel (Bitdiddle Ben))
; (wheel (Warbucks Oliver))
; (wheel (Warbucks Oliver))
; (wheel (Warbucks Oliver))
;
; Why is Oliver Warbucks listed four times?


;; Answer

; Rule:
;
; (rule (wheel ?person)
;       (and (supervisor ?middle-manager ?person)
;            (supervisor ?x ?middle-manager)))
;
; There are:
;
; (supervisor (Hacker Alyssa P) (Bitdiddle Ben))
; (supervisor (Fect Cy D) (Bitdiddle Ben))
; (supervisor (Tweakit Lem E) (Bitdiddle Ben))
; (supervisor (Reasoner Louis) (Hacker Alyssa P))
; (supervisor (Bitdiddle Ben) (Warbucks Oliver))
; (supervisor (Scrooge Eben) (Warbucks Oliver))
; (supervisor (Cratchet Robert) (Scrooge Eben))
; (supervisor (Aull DeWitt) (Warbucks Oliver))
;
; These frames are passed to the second clause of the `and`
; syntax, when it comes to `Warbucks Oliver`, the `(supervisor
; (Bitdiddle Ben) (Warbucks Oliver))` is extended by the second
; clause with,
;
; (supervisor (Hacker Alyssa P) (Bitdiddle Ben))
; (supervisor (Fect Cy D) (Bitdiddle Ben))
; (supervisor (Tweakit Lem E) (Bitdiddle Ben))
;
; and another occurence extended from `(supervisor (Scrooge Eben)
; (Warbucks Oliver))`.
