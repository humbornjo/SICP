; What is the purpose of the let bindings in the procedures
; add-assertion! and add-rule! ? What would be wrong with the
; following implementation of add-assertion! ? Hint: Recall the
; definition of the infinite stream of ones in Section 3.5.2:
; (define ones (cons-stream 1 ones)).
;
; (define (add-assertion! assertion)
;   (store-assertion-in-index assertion)
;   (set! THE-ASSERTIONS
;     (cons-stream assertion THE-ASSERTIONS))
;   'ok)


;; Answer

; stream is not eval-ed till it is used or forced, so
; "THE-ASSERTIONS" will be set to
; (cons-stream assertion THE-ASSERTIONS) in the frame, which will
; lead to a infinite stream of assertion. However, if
; THE-ASSERTIONS is binded to the let binding, the frame will be
; extended, and the stream will be the correct stream with
; assertion inserted at the head.
