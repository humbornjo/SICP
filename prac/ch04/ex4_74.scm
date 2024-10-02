; Alyssa P. Hacker proposes to use a simpler version of
; stream-flatmap in negate, lisp-value, and find-assertions. She
; observes that the procedure that is mapped over the frame
; stream in these cases always produces either the empty stream
; or a singleton stream, so no interleaving is needed when
; combining these streams.
;
; a. Fill in the missing expressions in Alyssa’s program.
;
;   (define (simple-stream-flatmap proc s)
;     (simple-flatten (stream-map proc s)))
;   (define (simple-flatten stream)
;     (stream-map ⟨??⟩
;                 (stream-filter ⟨??⟩ stream)))
;
; b. Does the query system’s behavior change if we change it in
; this way?


;; Answer

; Original version
;
; (define (interleave-delayed s1 delayed-s2)
;   (if (stream-null? s1)
;     (force delayed-s2)
;     (cons-stream
;       (stream-car s1)
;       (interleave-delayed
;         (force delayed-s2)
;         (delay (stream-cdr s1))))))
;
; (define (stream-flatmap proc s)
;   (flatten-stream (stream-map proc s)))
; (define (flatten-stream stream)
;   (if (stream-null? stream)
;     the-empty-stream
;     (interleave-delayed
;       (stream-car stream)
;       (delay (flatten-stream (stream-cdr stream))))))


(load "eval_init_query.scm")
(load "eval_impl_query.scm")

; a.

; The execrise use "either ... or ..." so no multi frame stream
; is considered

(define (simple-stream-flatmap proc s)
  ; The mapping always produces either the empty stream or a singleton stream
  (simple-flatten (stream-map proc s)))
(define (simple-flatten stream) ; stream here is actually stream of stream of frame
  (stream-map stream-car
              ; filter out the empty stream of frame
              (stream-filter (lambda (x) (not (stream-null? x))) stream)))

; b.

; If the number of frame is always 0 or 1 in each stream, then
; no, there is no change. interleave itself was to output frame
; in the same order.


(define first-stream (singleton-stream "stream_1"))
(define second-stream (singleton-stream "stream_2"))
(define third-stream the-empty-stream)
(define fourth-stream (singleton-stream "stream_4"))

(define streams
  (cons-stream first-stream
               (cons-stream second-stream
                            (cons-stream third-stream
                                         (cons-stream fourth-stream the-empty-stream)))))

(assert (equal? (collect-stream (simple-flatten streams))
                (collect-stream (flatten-stream streams))))
