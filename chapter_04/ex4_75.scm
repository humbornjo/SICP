; Implement for the query language a new special form called
; unique. unique should succeed if there is precisely one item
; in the data base satisfying a specified query. For example,
;
; (unique (job ?x (computer wizard)))
;
; should print the one-item stream
;
; (unique (job (Bitdiddle Ben) (computer wizard)))
;
; since Ben is the only computer wizard, and
;
; (unique (job ?x (computer programmer)))
;
; should print the empty stream, since there is more than one
; computer programmer. Moreover,
;
; (and (job ?x ?j) (unique (job ?anyone ?j)))
;
; should list all the jobs that are filled by only one person,
; and the people who fill them. There are two parts to
; implementing unique. The first is to write a procedure that
; handles this special form, and the second is to make qeval
; dispatch to that procedure. The second part is trivial, since
; qeval does its dispatching in a data-directed way. If your
; procedure is called uniquely-asserted, all you need to do is
;
; (put 'unique 'qeval uniquely-asserted)
;
; and qeval will dispatch to this procedure for every query whose
; type (car) is the symbol unique.
;
; The real problem is to write the procedure uniquely-asserted.
; This should take as input the contents (cdr) of the unique
; query, together with a stream of frames. For each frame in the
; stream, it should use qeval to find the stream of all
; extensions to the frame that satisfy the given query. Any
; stream that does not have exactly one item in it should be
; eliminated. The remaining streams should be passed back to be
; accumulated into one big stream that is the result of the
; unique query. This is similar to the implementation of the not
; special form.
;
; Test your implementation by forming a query that lists all
; people who supervise precisely one person.


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

; (assert! (job teacher devin))
(define assert1 '(assert! (weather snow LA)))
(if (assertion-to-be-added? assert1)
  (add-rule-or-assertion! (add-assertion-body assert1))
  (print "Not an assertion"))
; (assert! (part-time teacher devin))
(define assert2 '(assert! (company tech LA)))
(if (assertion-to-be-added? assert2)
  (add-rule-or-assertion! (add-assertion-body assert2))
  (print "Not an assertion"))
; (assert! (part-time teacher devin))
(define assert3 '(assert! (company finance LA)))
(if (assertion-to-be-added? assert3)
  (add-rule-or-assertion! (add-assertion-body assert3))
  (print "Not an assertion"))

(define (stream-singleton? stream) (stream-null? (stream-cdr stream)))

(define (unique-query operands) (car operands))
(define (uniquely-asserted operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (let ((asserted-stream (qeval (unique-query operands) (singleton-stream frame))))
        (if (stream-singleton? asserted-stream)
          asserted-stream
          the-empty-stream)))
    frame-stream))
(put 'unique 'qeval uniquely-asserted)

(define test-query-1 (query-syntax-process '(unique (weather ?x LA))))
(define test-expected-1 '((unique (weather snow LA))))
(assert (equal?
          test-expected-1
          (collect-stream
            (stream-map
              (lambda (frame)
                (instantiate test-query-1 frame (lambda (v f)
                                                  (contract-question-mark v))))
              (qeval test-query-1 (singleton-stream '()))))))


(define test-query-2 (query-syntax-process '(unique (company ?x LA))))
(define test-expected-2 the-empty-stream)
(assert (equal?
          test-expected-2
          (stream-map
            (lambda (frame)
              (instantiate test-query-2 frame (lambda (v f)
                                                (contract-question-mark v))))
            (qeval test-query-2 (singleton-stream '())))))
