; In Section 4.4.3 we saw that not and lisp-value can cause the
; query language to give “wrong” answers if these filtering
; operations are applied to frames in which variables are
; unbound. Devise a way to fix this shortcoming. One idea is to
; perform the filtering in a “delayed” manner by appending to the
; frame a “promise” to filter that is fulfilled only when enough
; variables have been bound to make the operation possible. We
; could wait to perform filtering until all other operations have
; been performed. However, for efficiency’s sake, we would like
; to perform filtering as soon as possible so as to cut down on
; the number of intermediate frames generated.


;; Answer

(load "./eval_init_query.scm")
(load "./eval_impl_query.scm")

(define filter-key 'filter-key)
(define (clean-frame frame)
  (cond ((null? frame) frame)
        (else
          (if (eq? (binding-variable (car frame)) filter-key)
            (cdr frame)
            frame))))

(define (car-filter? frame)
  (if (eq? filter-key (binding-variable (car frame)))
    true
    false))

(define (extend variable value frame)
  (define (try-filter maybe-filter f)
    (cond ((null? maybe-filter) maybe-filter)
          ((car-filter? maybe-filter)
           (let ((b (car maybe-filter)))
             (if (all-vars-bound? (binding-value b) f)
               (if (stream-null?
                     (qeval (negated-query (binding-value b))
                            (singleton-stream f)))
                 f
                 'failed)
               (cons b (try-filter (cdr f))))))
          (else f)))

  (if (eq? variable filter-key)
    (cons (make-binding variable value) frame)
    (let ((extended-frame
            (cons (make-binding variable value) (clean-frame frame))))
      (try-filter frame extended-frame))))

(define (all-vars-bound? operands frame)
  (cond ((var? operands)
         (not (equal? false (binding-in-frame operands frame))))
        ((pair? operands)
         (and (all-vars-bound? (car operands) frame)
              (all-vars-bound? (cdr operands) frame)))
        (else true)))

; check if all variables are bound
(define (negate operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (all-vars-bound? (negated-query operands) frame)
        (if (stream-null?
              (qeval (negated-query operands)
                     (singleton-stream frame)))
          (singleton-stream frame)
          the-empty-stream)
        (singleton-stream (extend filter-key operands frame))))
    frame-stream))
(put 'not 'qeval negate)


; put the negate filter before a query
(define test-query (query-syntax-process
                     '(and (not (job ?x (computer programmer))) (job ?x ?y))))

; Normally (job ?x ?y) will give the following 9 records, with
; two record whose job is programmer.
;
; (job (Aull DeWitt) (administration secretary))
; (job (Cratchet Robert) (accounting scrivener))
; (job (Scrooge Eben) (accounting chief accountant))
; (job (Warbucks Oliver) (administration big wheel))
; (job (Reasoner Louis) (computer programmer trainee))
; (job (Tweakit Lem E) (computer technician))
; (job (Fect Cy D) (computer programmer))
; (job (Hacker Alyssa P) (computer programmer))
; (job (Bitdiddle Ben) (computer wizard))

; The expected answer is all the recoeds but the ones of
; programmer (7 records).
;
; (and (not (job (Aull DeWitt) (computer programmer))) (job (Aull DeWitt) (administration secretary)))
; (and (not (job (Cratchet Robert) (computer programmer))) (job (Cratchet Robert) (accounting scrivener)))
; (and (not (job (Scrooge Eben) (computer programmer))) (job (Scrooge Eben) (accounting chief accountant)))
; (and (not (job (Warbucks Oliver) (computer programmer))) (job (Warbucks Oliver) (administration big wheel)))
; (and (not (job (Reasoner Louis) (computer programmer))) (job (Reasoner Louis) (computer programmer trainee)))
; (and (not (job (Tweakit Lem E) (computer programmer))) (job (Tweakit Lem E) (computer technician)))
; (and (not (job (Bitdiddle Ben) (computer programmer))) (job (Bitdiddle Ben) (computer wizard)))
(define test-expected
  '((and (not (job (Aull DeWitt) (computer programmer))) (job (Aull DeWitt) (administration secretary)))
    (and (not (job (Cratchet Robert) (computer programmer))) (job (Cratchet Robert) (accounting scrivener)))
    (and (not (job (Scrooge Eben) (computer programmer))) (job (Scrooge Eben) (accounting chief accountant)))
    (and (not (job (Warbucks Oliver) (computer programmer))) (job (Warbucks Oliver) (administration big wheel)))
    (and (not (job (Reasoner Louis) (computer programmer))) (job (Reasoner Louis) (computer programmer trainee)))
    (and (not (job (Tweakit Lem E) (computer programmer))) (job (Tweakit Lem E) (computer technician)))
    (and (not (job (Bitdiddle Ben) (computer programmer))) (job (Bitdiddle Ben) (computer wizard)))))

(assert
  (equal? test-expected
          (collect-stream
            (stream-map
              (lambda (frame)
                (instantiate test-query frame (lambda (v f)
                                                (contract-question-mark v))))
              (qeval test-query (singleton-stream '()))))))
