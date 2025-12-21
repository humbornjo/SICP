; The following data base (see Genesis 4) traces the genealogy of
; the descendants of Ada back to Adam, by way of Cain:
;
; (son Adam Cain)
; (son Cain Enoch)
; (son Enoch Irad)
; (son Irad Mehujael)
; (son Mehujael Methushael)
; (son Methushael Lamech)
; (wife Lamech Ada)
; (son Ada Jabal)
; (son Ada Jubal)
;
; Formulate rules such as “If S is the son of f , and f is the
; son of G, then S is the grandson of G” and “If W is the wife of
; M , and S is the son of W , then S is the son of M ” (which was
; supposedly more true in biblical times than today) that will
; enable the query system to find the grandson of Cain; the sons
; of Lamech; the grandsons of Methushael. (See Exercise 4.69 for
; some rules to deduce more complicated relationships.)


;; Answer

;; Never see a exam ask the reader to read religious material lol

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(define rule-grandson
  (query-syntax-process
    '(rule (grandson ?gp ?gs)
           (and (son ?f ?gs)
                (son ?gp ?f)))))

(add-rule-or-assertion! rule-grandson)

(define rule-son
  (query-syntax-process
    '(rule (son ?f ?s)
           (and (wife ?f ?m)
                (son ?m ?s)))))

(add-rule-or-assertion! rule-son)


(add-rule-or-assertion! '(son Adam Cain))
(add-rule-or-assertion! '(son Cain Enoch))
(add-rule-or-assertion! '(son Enoch Irad))
(add-rule-or-assertion! '(son Irad Mehujael))
(add-rule-or-assertion! '(son Mehujael Methushael))
(add-rule-or-assertion! '(son Methushael Lamech))
(add-rule-or-assertion! '(wife Lamech Ada))
(add-rule-or-assertion! '(son Ada Jabal))
(add-rule-or-assertion! '(son Ada Jubal))

(define test-input-grandson '(grandson ?x ?y))

(define test-query-grandson (query-syntax-process test-input-grandson))

(define test-expected-grandson
  '((grandson Mehujael Lamech)
    (grandson Irad Methushael)
    (grandson Enoch Mehujael)
    (grandson Cain Irad)
    (grandson Adam Enoch)
    (grandson Methushael Jubal)
    (grandson Methushael Jabal)))

(assert (equal? test-expected-grandson
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-grandson frame (lambda (v f)
                                                               (contract-question-mark v))))
                    (qeval test-query-grandson (singleton-stream '()))))))

(define test-input-son '(son ?x ?y))

(define test-query-son (query-syntax-process test-input-son))

(define test-expected-son
  '((son Ada Jubal)
    (son Ada Jabal)
    (son Methushael Lamech)
    (son Mehujael Methushael)
    (son Irad Mehujael)
    (son Enoch Irad)
    (son Cain Enoch)
    (son Adam Cain)
    (son Lamech Jubal)
    (son Lamech Jabal)))

(assert (equal? test-expected-son
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-son frame (lambda (v f)
                                                          (contract-question-mark v))))
                    (qeval test-query-son (singleton-stream '()))))))

