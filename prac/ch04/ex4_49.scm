;; Alyssa P. Hacker is more interested in generating interesting
;; sentences than in parsing them. She reasons that by simply
;; changing the procedure parse-word so that it ignores the
;; "input sentence" and instead always succeeds and generates an
;; appropriate word, we can use the programs we had built for
;; parsing to do generation instead. Implement Alyssa’s idea, and
;; show the first half-dozen or so sentences generated.


;; Answer

(load "./eval_init_amb.scm")

(define (select items)
  (amb (car items)
       (select (cdr items))))

(define (parse-word word-list)
  (list (car word-list) (select (cdr word-list))))
