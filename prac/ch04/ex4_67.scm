; Devise a way to install a loop detector in the query system so
; as to avoid the kinds of simple loops illustrated in the text
; and in Exercise 4.64. The general idea is that the system
; should maintain some sort of history of its current chain of
; deductions and should not begin processing a query that it is
; already working on. Describe what kind of information (patterns
; and frames) is included in this history, and how the check
; should be made. (After you study the details of the
; query-system implementation in Section 4.4.4, you may want to
; modify the system to include your loop detector.)


;; Answer

; Pattern should be used as the index to the history. And the
; value should be an array of frame stream identities, every time
; a query is eval-ed, the history will be updated. If identity is
; found duplicated in the array, then there is a loop.
;
; The Identity could be the frame stream itself, or a hash of it.
