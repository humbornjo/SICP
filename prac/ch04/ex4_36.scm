; Exercise 3.69 discussed how to generate the stream of all
; Pythagorean triples, with no upper bound on the size of the
; integers to be searched. Explain why simply replacing
; an-integer-between by an-integer-starting-from in the procedure
; in Exercise 4.35 is not an adequate way to generate arbitrary
; Pythagorean triples. Write a procedure that actually will
; accomplish this. (that is, write a procedure for which
; repeatedly typing try-again would in principle eventually
; generate all Pythagorean triples.)

;; Answer
;;
;; Because backtracing, when try-again is invoked, the branch is
;; restarted from the nearest branch, which is the value picking
;; of k, and try-again will indefinitely increase k to infinity.

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (an-integer-starting-from low)
  (amb low (an-integer-starting-from (+ low 1))))

(define (a-pythagorean-triple-starting-from low)
  (let ((k (an-integer-starting-from low)))
    (let ((j (an-integer-between low k)))
      (let ((i (an-integer-between j k)))
            (require (= (+ (* i i) (* j j)) (* k k)))
            (list i j k)))))


;; Test

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between low high)
       (require (<= low high))
       (amb low (an-integer-between (+ low 1) high)))

     (define (an-integer-starting-from low)
       (amb low (an-integer-starting-from (+ low 1))))

     (define (a-pythagorean-triple-starting-from low)
       (let ((k (an-integer-starting-from low)))
         (let ((i (an-integer-between low k)))
           (let ((j (an-integer-between low i)))
             (require (= (+ (* i i) (* j j)) (* k k)))
             (list i j k)))))

     (a-pythagorean-triple-starting-from 1)
     )
  )

; Take the first 5 pythagorean triples
(define test-count 0)
(define test-iter 5)

(define test-got nil)
(define test-want '((16 12 20) (15 8 17) (12 9 15) (12 5 13) (8 6 10) (4 3 5)))

(ambeval test-input
         the-global-environment
         ;; ambeval success
         (lambda (val next-alternative)
           (set! test-got (cons val test-got))
           (set! test-count (+ test-count 1))
           (if (<= test-count test-iter)
             (next-alternative))
           )
         ;; ambeval failure
         (lambda () (announce-output
                ";;; There are no more values of")))

(assert (equal? test-got test-want))
