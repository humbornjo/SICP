(load "../init.scm")
(load "../chapter_03/eval_init_stream.scm")
(load "../chapter_03/eval_init_table.scm")

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  ; query-syntax-process convert input expression to standard
  ; form.
  ;
  ; e.g. IN : (job ?x devin)
  ;      OUT: (job (? x) devin)
  (let ((q (query-syntax-process (read))))
    (cond ((assertion-to-be-added? q) ; test if q start with assert!
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
            (newline)
            (display output-prompt)
            (display-stream
              (stream-map
                (lambda (frame)
                  (instantiate q frame (lambda (v f)
                                         (contract-question-mark v))))
                (qeval q (singleton-stream '()))))
            (query-driver-loop)))))

(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
               (copy (binding-value binding))
               (unbound-var-handler exp frame))))
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp)))
  (copy exp))

(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame-stream)
      (simple-query query frame-stream))))

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
    (lambda (frame)
      (stream-append-delayed
        (find-assertions query-pattern frame)
        (delay (apply-rules query-pattern frame))))
    frame-stream))

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
    frame-stream
    (conjoin (rest-conjuncts conjuncts)
             (qeval (first-conjunct conjuncts) frame-stream))))
(put 'and 'qeval conjoin)

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
    the-empty-stream
    (interleave-delayed
      (qeval (first-disjunct disjuncts) frame-stream)
      (delay (disjoin (rest-disjuncts disjuncts) frame-stream)))))
(put 'or 'qeval disjoin)

(define (negate operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (stream-null?
            (qeval (negated-query operands)
                   (singleton-stream frame)))
        (singleton-stream frame)
        the-empty-stream))
    frame-stream))
(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (execute
            (instantiate
              call
              frame
              (lambda (v f)
                (error "Unknown pat var: LISP-VALUE" v))))
        (singleton-stream frame)
        the-empty-stream))
    frame-stream))
(put 'lisp-value 'qeval lisp-value)

(define (execute exp)
  ; use the native csi eval, ignore user-initial-environment
  (apply (eval (predicate exp)); user-initial-environment)
         (args exp)))

(define (always-true ignore frame-stream) frame-stream)
(put 'always-true 'qeval always-true)

; return all the frame binded
(define (find-assertions pattern frame)
  (stream-flatmap
    (lambda (datum) (check-an-assertion datum pattern frame))
    (fetch-assertions pattern frame)))

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result
          (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
      the-empty-stream
      (singleton-stream match-result))))

(define (pattern-match pat dat frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? pat dat) frame)
        ((var? pat) (extend-if-consistent pat dat frame))
        ((and (pair? pat) (pair? dat))
         (pattern-match
           (cdr pat)
           (cdr dat)
           (pattern-match (car pat) (car dat) frame)))
        (else 'failed)))

; extend return a frame with a pair of binding
;
; (define (extend variable value frame)
;   (cons (make-binding variable value) frame))
(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
      (pattern-match (binding-value binding) dat frame)
      (extend var dat frame))))

(define (apply-rules pattern frame)
  (stream-flatmap (lambda (rule)
                    (apply-a-rule rule pattern frame))
                  (fetch-rules pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result (unify-match query-pattern
                                     (conclusion clean-rule)
                                     query-frame)))
      (if (eq? unify-result 'failed)
        the-empty-stream
        (qeval (rule-body clean-rule)
               (singleton-stream unify-result))))))

(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk exp)
      (cond ((var? exp)
             (make-new-variable exp rule-application-id))
            ((pair? exp)
             (cons (tree-walk (car exp))
                   (tree-walk (cdr exp))))
            (else exp)))
    (tree-walk rule)))

; unify-match return 'failed or (extended)frame
(define (unify-match p1 p2 frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? p1 p2) frame)
        ((var? p1) (extend-if-possible p1 p2 frame))
        ((var? p2) (extend-if-possible p2 p1 frame)) ; ***
        ((and (pair? p1) (pair? p2))
         (unify-match (cdr p1)
                      (cdr p2)
                      (unify-match (car p1)
                                   (car p2)
                                   frame)))
        (else 'failed)))

(define (extend-if-possible var val frame)
  ; binding-in-frame find the binding of var in frame, return a
  ; pair of binding (var . val) if found, else return #f
  (let ((binding (binding-in-frame var frame)))
    (cond
      ; binding is already in frame match with binding-value,
      ; return the result of unify-match
      (binding
        (unify-match (binding-value binding) val frame))
      ; binding is not in frame, if val is var (begin with ?)
      ((var? val) ; ***
       (let ((binding (binding-in-frame val frame)))
         (if binding
           ; val is already in frame, match with binding-value.
           ;
           ; e.g.
           ;   var = ?x, val = ?y and y = 1, then match (x 1 frame)
           ;   which leads to extend (x . 1) on frame
           (unify-match
             var (binding-value binding) frame)
           (extend var val frame))))
      ; check if any element of val depends on var
      ((depends-on? val var frame) ; ***
       'failed)
      (else (extend var val frame)))))

(define (depends-on? exp var frame)
  (define (tree-walk e)
    (cond
      ; when e is var
      ((var? e)
       (if (equal? var e)
         ; if var = e, return true
         true
         ; let b be the binding pair of e in frame
         (let ((b (binding-in-frame e frame)))
           (if b
             ; if b exist, check if binding-value depends on var
             (tree-walk (binding-value b))
             false))))
      ((pair? e)
       (or (tree-walk (car e))
           (tree-walk (cdr e))))
      (else false)))
  (tree-walk exp))

(define THE-ASSERTIONS the-empty-stream)
(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
    (get-indexed-assertions pattern)
    (get-all-assertions)))
(define (get-all-assertions) THE-ASSERTIONS)
(define (get-indexed-assertions pattern)
  (get-stream (index-key-of pattern) 'assertion-stream))
(define (get-stream key1 key2)
  (let ((s (get key1 key2)))
    (if s s the-empty-stream)))

(define THE-RULES the-empty-stream)
(define (fetch-rules pattern frame)
  (if (use-index? pattern)
    (get-indexed-rules pattern)
    (get-all-rules)))
(define (get-all-rules) THE-RULES)
(define (get-indexed-rules pattern)
  (stream-append
    (get-stream (index-key-of pattern) 'rule-stream)
    (get-stream '? 'rule-stream)))

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
    (add-rule! assertion)
    (add-assertion! assertion)))
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
      (cons-stream assertion old-assertions))
    'ok))
(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES (cons-stream rule old-rules))
    'ok))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
    (let ((key (index-key-of assertion)))
      (let ((current-assertion-stream
              (get-stream key 'assertion-stream)))
        (put key
             'assertion-stream
             (cons-stream
               assertion
               current-assertion-stream))))))
(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
      (let ((key (index-key-of pattern)))
        (let ((current-rule-stream
                (get-stream key 'rule-stream)))
          (put key
               'rule-stream
               (cons-stream rule
                            current-rule-stream)))))))

(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat))))

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)))

(define (use-index? pat) (constant-symbol? (car pat)))

; (define (stream-append s1 s2)
;   (if (stream-null? s1)
;     s2
;     (cons-stream (stream-car s1)
;                  (stream-append (stream-cdr s1) s2))))
(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (stream-append-delayed
        (stream-cdr s1)
        delayed-s2))))
(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (interleave-delayed
        (force delayed-s2)
        (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))
(define (flatten-stream stream)
  (if (stream-null? stream)
    the-empty-stream
    (interleave-delayed
      (stream-car stream)
      (delay (flatten-stream (stream-cdr stream))))))
(define (collect-stream stream)
  (if (stream-null? stream)
    nil
    (cons (stream-car stream)
          (collect-stream (stream-cdr stream)))))

(define (singleton-stream x) (cons-stream x the-empty-stream))
