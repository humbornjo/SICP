;; Extend the grammar given above to handle more complex
;; sentences. For example, you could extend noun phrases and verb
;; phrases to include adjectives and adverbs, or you could handle
;; compound sentences.


;; Answer

(load "./eval_init_amb.scm")

(define adverbs '(adv quickly slowly patiently))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
           (list 'verb-phrase
                 verb-phrase
                 (parse-prepositional-phrase)))))
  (define (maybe-extend-adverb adverb-phrase)
    (list 'verb-phrase
          adverb-phrase
          (maybe-extend (parse-word verbs))))
  (amb (maybe-extend-adverb (parse-word adverbs))
       (maybe-extend (parse-word verbs))))

; "The professor patiently lectures to the student in the class
; with the cat."

;; Test

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define nouns '(noun student professor cat class))
     (define verbs '(verb studies lectures eats sleeps))
     (define articles '(article the a))
     (define prepositions '(prep for to in by with))
     (define adverbs '(adv quickly slowly patiently))

     (define (parse-word word-list)
       (require (not (null? *unparsed*)))
       (require (memq (car *unparsed*) (cdr word-list)))
       (let ((found-word (car *unparsed*)))
         (set! *unparsed* (cdr *unparsed*))
         (list (car word-list) found-word)))

     (define (parse-sentence)
       (list 'sentence
             (parse-noun-phrase)
             (parse-word verbs)))

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
       (define (maybe-extend-adverb adverb-phrase)
         (list 'verb-phrase
               adverb-phrase
               (maybe-extend (parse-word verbs))))
       (amb (maybe-extend-adverb (parse-word adverbs))
            (maybe-extend (parse-word verbs))))

     (define (parse-sentence)
       (list 'sentence (parse-noun-phrase) (parse-verb-phrase)))

     (define *unparsed* '())
     (define (parse input)
       (set! *unparsed* input)
       (let ((sent (parse-sentence)))
         (require (null? *unparsed*))
         sent))

     (define input '(the professor patiently lectures))

     (parse input)
     )
  )

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-got nil)
(define test-want `((sentence (simple-noun-phrase (article the) (noun professor))
                              (verb-phrase (adv patiently) (verb lectures)))))

(ambeval test-input
         the-global-environment
         ;; ambeval success
         (lambda (val next-alternative)
           (set! test-got (cons val test-got))
           (next-alternative)
           )
         ;; ambeval failure
         (lambda () (announce-output
                      ";;; There are no more values of")))

(assert (equal? test-got test-want))

