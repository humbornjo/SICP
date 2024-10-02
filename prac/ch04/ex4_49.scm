; Alyssa P. Hacker is more interested in generating interesting
; sentences than in parsing them. She reasons that by simply
; changing the procedure parse-word so that it ignores the
; "input sentence" and instead always succeeds and generates an
; appropriate word, we can use the programs we had built for
; parsing to do generation instead. Implement Alyssa’s idea, and
; show the first half-dozen or so sentences generated.


;; Answer

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define (select items)
  (amb (car items)
       (select (cdr items))))

(define (parse-word word-list)
  (list (car word-list) (select (cdr word-list))))


;; Test

(define test-input
  `(begin
     (define nouns '(noun student professor cat class))
     (define verbs '(verb studies lectures eats sleeps))
     (define articles '(article the a))
     (define prepositions '(prep for to in by with))

     (define (select items)
       (amb (car items)
            (select (cdr items))))

     (define (parse-word word-list)
       (list (car word-list) (select (cdr word-list))))

     (define (parse-simple-noun-phrase)
       (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word nouns)))

     (define (parse-noun-phrase)
       (define (maybe-extend noun-phrase)
         (amb noun-phrase
              (maybe-extend
                (list 'noun-phrase
                      noun-phrase
                      (parse-prepositional-phrase)))))
       (maybe-extend (parse-simple-noun-phrase)))

     (define (parse-prepositional-phrase)
       (list 'prep-phrase
             (parse-word prepositions)
             (parse-noun-phrase)))

     (define (parse-verb-phrase)
       (define (maybe-extend verb-phrase)
         (amb verb-phrase
              (maybe-extend
                (list 'verb-phrase
                      verb-phrase
                      (parse-prepositional-phrase)))))
       (maybe-extend (parse-word verbs)))

     (define (parse-sentence)
       (list 'sentence (parse-noun-phrase) (parse-verb-phrase)))

     (define *unparsed* '())
     (define (parse input)
       (set! *unparsed* input)
       (let ((sent (parse-sentence)))
         (require (null? *unparsed*))
         sent))

     (parse-sentence)
     )
  )

(define test-got nil)
(define test-want `(sentence (simple-noun-phrase (article the) (noun student)) (verb studies)))

(ambeval test-input
         the-global-environment
         (lambda (val next-alternative)
           (set! test-got val))
         (lambda ()
           (display "Glorious Death"))
         )

(assert (equal? test-got test-want))
