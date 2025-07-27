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

(rule (live-near-but ?person-1 ?person-2)
      (and (lives-near ?person-1 ?person-2)
           (lisp-value cmp-string ?person-1 ?person-2))
      )
