; Redesign the query language as a nondeterministic program to be
; implemented using the evaluator of Section 4.3, rather than as
; a stream process. In this approach, each query will produce a
; single answer (rather than the stream of all answers) and the
; user can type try-again to see more answers. You should find
; that much of the mechanism we built in this section is subsumed
; by nondeterministic search and backtracking. You will probably
; also find, however, that your new query language has subtle
; differences in behavior from the one implemented here. Can you
; find examples that illustrate this difference?


;; Answer

; Below is a amb impl for the query system, which is quite easy,
; thus only `simple-query` and `apply-rules` are ported, which
; allows the execution of simple-query, for example, (job ?x ?y).
; All the derived functions can be implemented in the same way.
; In addition, replace the frame-stream with frame.
;
; Subtle difference:
;   1. There are no interleaving of output, since we pass succeed
;      down, and that would be difficult to implement
;      interleaving, even if interleaving is applied, there is no
;      way to decide when to call the fail.
;
;      e.g. the fail of simple-query should yield to apply-rules,
;           and the fail of apply-rules should yield to
;           simple-query (which is confusing).

(load "./eval_init_query.scm")
(load "./eval_impl_query.scm")

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print q frame)
  (display (instantiate q frame (lambda (v f)
                         (contract-question-mark v)))))

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result
          (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
      nil
      match-result)))

(define (find-assertions pattern frame succeed fail)
  (define (try-next choices)
    (if (null? choices)
      (fail)
      (if (null? (stream-car choices))
        (try-next (stream-cdr choices))
        (succeed
          (check-an-assertion (stream-car choices) pattern frame)
          (lambda ()
            (try-next (stream-cdr choices)))))))
  (try-next (fetch-assertions pattern frame)))

(define (simple-query query-pattern frame succeed fail)
  (find-assertions query-pattern frame
                   succeed
                   (lambda ()
                     (apply-rules query-pattern frame succeed fail))))

(define (apply-rules pattern frame succeed fail)
  (define (try-next choices)
    (if (null? choices)
      (fail)
      (if (null? (stream-car choices))
        (try-next (stream-cdr choices))
        (succeed
          (apply-a-rule (stream-car choices) pattern frame)
          (lambda ()
            (try-next (stream-cdr choices)))))))
  (try-next (fetch-rules pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result (unify-match query-pattern
                                     (conclusion clean-rule)
                                     query-frame)))
      (if (eq? unify-result 'failed)
        the-empty-stream
        (qeval (rule-body clean-rule)
               (singleton-stream unify-result))))))

(define (qeval query frame succeed fail)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame succeed fail)
      (simple-query query frame succeed fail))))

(define (amb-driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
        (try-again)
        (begin
          (newline) (display ";;; Query results:")
          (let ((q (query-syntax-process input)))
            (cond ((assertion-to-be-added? q)
                   (add-rule-or-assertion! (add-assertion-body q))
                   (newline)
                   (display "Assertion added to data base.")
                   (amb-driver-loop))
                  (else
                    (qeval
                      q
                      '()
                      ;; ambeval success
                      (lambda (val next-alternative)
                        (announce-output output-prompt)
                        (user-print q val)
                        (internal-loop next-alternative))
                      ;; ambeval failure
                      (lambda ()
                        (amb-driver-loop)))
                    )))))))
  (internal-loop
    (lambda ()
      (newline) (display ";;; There is no current stream")
      (amb-driver-loop))))

; (amb-driver-loop)

(define test-input '(job ?x ?y))
(define test-query (query-syntax-process test-input))
(define test-result nil)
(define test-expected
  '((job (Bitdiddle Ben) (computer wizard))
    (job (Hacker Alyssa P) (computer programmer))
    (job (Fect Cy D) (computer programmer))
    (job (Tweakit Lem E) (computer technician))
    (job (Reasoner Louis) (computer programmer trainee))
    (job (Warbucks Oliver) (administration big wheel))
    (job (Scrooge Eben) (accounting chief accountant))
    (job (Cratchet Robert) (accounting scrivener))
    (job (Aull DeWitt) (administration secretary))))

(qeval test-query
       nil
       (lambda (val next-alternative)
         (set! test-result
           (cons (instantiate test-query val (lambda (v f)
                                               (contract-question-mark v)))
                 test-result))
         (next-alternative))
       (lambda () false))

(assert (equal? test-expected test-result))
