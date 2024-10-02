; Why does flatten-stream use delay ex-plicitly? What would be
; wrong with defining it as follows:
;
; (define (flatten-stream stream)
;   (if (stream-null? stream)
;     the-empty-stream
;     (interleave
;       (stream-car stream)
;       (flatten-stream (stream-cdr stream)))))


;; Answer

; Correct version
;
; (define (flatten-stream stream)
;   (if (stream-null? stream)
;     the-empty-stream
;     (interleave-delayed
;       (stream-car stream)
;       (delay (flatten-stream (stream-cdr stream))))))

; Without delay, when stream is not null, eval of flatten-stream
; on stream-cdr will start immediately. Which may lead to
; "undesirable behavior" (see ex4_71.scm).


(load "eval_init_query.scm")
(load "eval_impl_query.scm")

; ; Toggle this section to use delay or not.
; (define (flatten-stream stream)
;   (if (stream-null? stream)
;     the-empty-stream
;     (interleave
;       (stream-car stream)
;       (flatten-stream (stream-cdr stream)))))
;
; (define first-stream (singleton-stream "the first stream"))
;
; (define infinite-stream (cons-stream  "infinite stream" infinite-stream))
;
; (define to-be-flatten (cons-stream first-stream (singleton-stream infinite-stream)))
;
; (display-stream (flatten-stream to-be-flatten))
