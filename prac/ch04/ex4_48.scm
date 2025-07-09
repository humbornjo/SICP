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

