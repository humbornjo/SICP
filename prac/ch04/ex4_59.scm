; Ben Bitdiddle has missed one meeting too many. Fearing that his
; habit of forgettings could cost him his job, Ben decides
; to do something about it. He adds all the weekly meetings of
; the firm to the Microshaft data base by asserting the
; following:
;
; (meeting accounting (Monday 9am))
; (meeting administration (Monday 10am))
; (meeting computer (Wednesday 3pm))
; (meeting administration (Friday 1pm))
;
; Each of the above assertions is for a meeting of an entire
; division. Ben also adds an entry for the company-wide meeting
; that spans all the divisions. All of the company’s employees
; attend this meeting.
;
; (meeting whole-company (Wednesday 4pm))
;
; a. On Friday morning, Ben wants to query the data base for all
;    the meetings that occur that day. What query should he use?
;
; b. Alyssa P. Hacker is unimpressed. She thinks it would be much
;    more useful to be able to ask for her meetings by specifying
;    her name. So she designs a rule that says that a person’s
;    meetings include all whole-company meetings plus all
;    meetings of that person’s division. Fill in the body of
;    Alyssa’s rule.
;
;    (rule (meeting-time ?person ?day-and-time)
;      ⟨rule-body⟩)
;
; c. Alyssa arrives at work on Wednesday morning and wonders what
;    meetings she has to attend that day. Having defined the above
;    rule, what query should she make to find this out?


;; Answer

(load "eval_init_query.scm")
(load "eval_impl_query.scm")

(add-rule-or-assertion! '(meeting accounting (Monday 9am)))
(add-rule-or-assertion! '(meeting administration (Monday 10am)))
(add-rule-or-assertion! '(meeting computer (Wednesday 3pm)))
(add-rule-or-assertion! '(meeting administration (Friday 1pm)))

; a.
(define test-input-a '(meeting ?x (Friday ?y)))

(define test-query-a (query-syntax-process test-input-a))

(define test-expected-a
  '((meeting administration (Friday 1pm))))

(assert (equal? test-expected-a
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-a frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-a (singleton-stream '()))))))


; ; b.
(define rule-meeting-time
  (query-syntax-process
    '(rule (meeting-time ?person ?day-and-time)
      (or  (meeting whole-company ?day-and-time)
           (and (job ?person (?division . ?x))
                (meeting ?division ?day-and-time))))))

(add-rule-or-assertion! rule-meeting-time)



; ; c.
(define test-input-c '(meeting-time (Hacker Alyssa P) (Wednesday ?x)))

(define test-query-c (query-syntax-process test-input-c))

(define test-expected-c '((meeting-time (Hacker Alyssa P) (Wednesday 3pm))))

(assert (equal? test-expected-c
                (collect-stream
                  (stream-map
                    (lambda (frame)
                      (instantiate test-query-c frame (lambda (v f)
                                                        (contract-question-mark v))))
                    (qeval test-query-c (singleton-stream '()))))))
