; Our implementation of and as a series combination of queries
; (Figure 4.5) is elegant, but it is inefficient because in
; processing the second query of the and we must scan the data
; base for each frame produced by the first query. If the data
; base has n elements, and a typical query produces a number of
; output frames proportional to n (say n/k), then scanning the
; data base for each frame produced by the first query will
; require n^2/k calls to the pattern matcher. Another approach
; would be to process the two clauses of the and separately, then
; look for all pairs of output frames that are compatible. If
; each query produces n/k output frames, then this means that we
; must perform n^2/k^2 compatibility checks—a factor of k fewer
; than the number of matches required in our current method.
;
; Devise an implementation of and that uses this strategy. You
; must implement a procedure that takes two frames as inputs,
; checks whether the bindings in the frames are compatible, and,
; if so, produces a frame that merges the two sets of bindings.
; This operation is similar to unification.


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define (frame-compatible? frame1 frame2)
  ; extract extra bindings from frame2, if any binding in frame2
  ; is incompatible with a binding in frame1, return 'failed
  (define (extract-bindings frame)
    (cond ((null? frame) nil)
          (else
            (let* ((b (car frame))
                  (bb (binding-in-frame (binding-variable b) frame1)))
              (if bb
                (if (equal? b bb)
                  (let ((next (extract-bindings (cdr frame))))
                    (if (eq? next 'failed) 'failed next))
                  'failed)
                  (let ((next (extract-bindings (cdr frame))))
                    (if (eq? next 'failed) 'failed (cons b next)))
                  )))))

  ; merge two frames
  (define (frame-append f1 f2)
    (cond ((null? f1) f2)
          (else (cons (car f1) (frame-append (cdr f1) f2)))))

  (let ((f (extract-bindings frame2)))
    (cond ((eq? f 'failed) 'failed)
          ((null? f) frame1)
          (else (frame-append f frame1)))
  ))

; and using divide and conquer
(define (and-dac frame1 frame2)
  (frame-compatible? frame1 frame2))

(define base-frame (extend 'b 2 (extend 'c 3 '())))
(define extra-frame (extend 'a 1 base-frame))

(assert (equal? (and-dac '() extra-frame) extra-frame))
(assert (equal? (and-dac (extend 'a 1 base-frame) (extend 'a 2 base-frame)) 'failed))
(assert (equal? (and-dac base-frame extra-frame) extra-frame))
(assert (equal? (and-dac (extend 'd 1 base-frame) extra-frame) (extend 'a 1 (extend 'd 1 base-frame))))
