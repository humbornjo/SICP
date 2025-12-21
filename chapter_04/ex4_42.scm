; Solve the following “Liars” puzzle (from Phillips 1934):
;
; Five schoolgirls sat for an examination. Their parents—so they
; thought—showed an undue degree of interest in the result. They
; therefore agreed that, in writing home about the examination,
; each girl should make one true statement and one untrue one.
; The following are the relevant passages from their letters:
;
; • Betty: “Kitty was second in the examination. I was only third.”
; • Ethel: “You’ll be glad to hear that I was on top. Joan was 2nd.”
; • Joan: “I was third, and poor old Ethel was bottom.”
; • Kitty: “I came out second. Mary was only fourth.”
; • Mary: “I was fourth. Top place was taken by Betty.”
;
; What in fact was the order in which the five girls were placed?

;; Answer

(define (lairs-puzzle)
  (let ((betty (amb 1 2 3 4 5))
        (ethel (amb 1 2 3 4 5))
        (joan (amb 1 2 3 4 5))
        (kitty (amb 1 2 3 4 5))
        (mary (amb 1 2 3 4 5)))
    (require
      (distinct? (list betty ethel joan kitty mary)))
    (require (xor (= kitty 2) (= betty 3)))
    (require (xor (= ethel 1) (= joan 2)))
    (require (xor (= joan 3) (= ethel 5)))
    (require (xor (= kitty 2) (= mary 4)))
    (require (xor (= mary 4) (= betty 1)))
    (list (list 'betty betty)
          (list 'ethel ethel)
          (list 'joan joan)
          (list 'kitty kitty)
          (list 'mary mary))))


;; Test

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (lairs-puzzle)
       (let ((betty (amb 1 2 3 4 5))
             (ethel (amb 1 2 3 4 5))
             (joan (amb 1 2 3 4 5))
             (kitty (amb 1 2 3 4 5))
             (mary (amb 1 2 3 4 5)))
         (require
           (distinct? (list betty ethel joan kitty mary)))
         (require (xor (= kitty 2) (= betty 3)))
         (require (xor (= ethel 1) (= joan 2)))
         (require (xor (= joan 3) (= ethel 5)))
         (require (xor (= kitty 2) (= mary 4)))
         (require (xor (= mary 4) (= betty 1)))
         (list (list 'betty betty)
               (list 'ethel ethel)
               (list 'joan joan)
               (list 'kitty kitty)
               (list 'mary mary))))

     (lairs-puzzle)
     )
  )

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-got nil)
(define test-want '(((betty 3) (ethel 5) (joan 2) (kitty 1) (mary 4))))

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

