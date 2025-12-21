; In the multiple dwelling problem, how many sets of assignments
; are there of people to floors, both before and after the
; requirement that floor assignments be distinct? It is very
; inefficient to generate all possible assignments of people to
; floors and then leave it to backtracking to eliminate them. For
; example, most of the restrictions depend on only one or two of
; the person-floor variables, and can thus be imposed before
; floors have been selected for all the people. Write and
; demonstrate a much more efficient non-deterministic procedure
; that solves this problem based upon generating only those
; possibilities that are not already ruled out by previous
; restrictions. (Hint: This will require a nest of let
; expressions.)

;; Answer

(define (an-integer-between-by-cond low high condition)
  (require (<= low high))
  (if (not (condition low))
    (an-integer-between-by-cond (+ low 1) high condition)
    (amb low (an-integer-between-by-cond (+ low 1) high condition))))

(define (multiple-dwelling)
  (let* ((baker (an-integer-between-by-cond 1 5
                                            (lambda (x) (not (= x 5)))))
         (smith (an-integer-between-by-cond 1 5
                                            (lambda (x) #t)))
         (miller (an-integer-between-by-cond 1 5
                                             (lambda (x) #t)))
         (fletcher (an-integer-between-by-cond 1 5
                                               (lambda (x) (not (or (= x 5)
                                                                    (or (= x 1)
                                                                        (= (abs (- x smith)) 1)))))))
         (cooper (an-integer-between-by-cond 1 5
                                             (lambda (x) (not
                                                           (or (= x 1)
                                                               (or (not (< x miller))
                                                                   (= (abs (- x fletcher)) 1))))))))
    (require (distinct? (list baker cooper fletcher miller smith)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

;; Test

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between-by-cond low high condition)
       (require (<= low high))
       (if (not (condition low))
         (an-integer-between-by-cond (+ low 1) high condition)
         (amb low (an-integer-between-by-cond (+ low 1) high condition))))

     (define (multiple-dwelling)
       (let* ((baker (an-integer-between-by-cond 1 5
                                                 (lambda (x) (not (= x 5)))))
              (smith (an-integer-between-by-cond 1 5
                                                 (lambda (x) #t)))
              (miller (an-integer-between-by-cond 1 5
                                                  (lambda (x) #t)))
              (fletcher (an-integer-between-by-cond 1 5
                                                    (lambda (x) (not (or (= x 5)
                                                                         (or (= x 1)
                                                                             (= (abs (- x smith)) 1)))))))
              (cooper (an-integer-between-by-cond 1 5
                                                  (lambda (x) (not
                                                                (or (= x 1)
                                                                    (or (not (< x miller))
                                                                        (= (abs (- x fletcher)) 1))))))))
         (require (distinct? (list baker cooper fletcher miller smith)))
         (list (list 'baker baker)
               (list 'cooper cooper)
               (list 'fletcher fletcher)
               (list 'miller miller)
               (list 'smith smith))))

     (multiple-dwelling)
     )
  )

(define test-got nil)
(define test-want '(((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))))

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
