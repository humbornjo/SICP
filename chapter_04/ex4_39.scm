; Does the order of the restrictions in the multiple-dwelling
; procedure affect the answer? Does it affect the time to find an
; answer? If you think it matters, demonstrate a faster program
; obtained from the given one by reordering the restrictions. If
; you think it does not matter, argue your case.

(define (multiple-dwelling-original)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
      (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker) (list 'cooper cooper)
          (list 'fletcher fletcher) (list 'miller miller)
          (list 'smith smith))))

;; Answer
;;
;; The order of the restrictions does not affect the answer. But
;; it affects the time to find an answer.
;;
;; distinct? is a very expensive operation, it takes O(n^2).

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require
      (distinct? (list baker cooper fletcher miller smith)))
    (list (list 'baker baker) (list 'cooper cooper)
          (list 'fletcher fletcher) (list 'miller miller)
          (list 'smith smith))))


;; Test

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-input-1
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between low high)
       (require (<= low high))
       (amb low (an-integer-between (+ low 1) high)))

     (define (multiple-dwelling-original)
       (let ((baker (amb 1 2 3 4 5))
             (cooper (amb 1 2 3 4 5))
             (fletcher (amb 1 2 3 4 5))
             (miller (amb 1 2 3 4 5))
             (smith (amb 1 2 3 4 5)))
         (require
           (distinct? (list baker cooper fletcher miller smith)))
         (require (not (= baker 5)))
         (require (not (= cooper 1)))
         (require (not (= fletcher 5)))
         (require (not (= fletcher 1)))
         (require (> miller cooper))
         (require (not (= (abs (- smith fletcher)) 1)))
         (require (not (= (abs (- fletcher cooper)) 1)))
         (list (list 'baker baker) (list 'cooper cooper)
               (list 'fletcher fletcher) (list 'miller miller)
               (list 'smith smith))))

     (multiple-dwelling-original)
     )
  )

(define test-input-2
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between low high)
       (require (<= low high))
       (amb low (an-integer-between (+ low 1) high)))

     (define (distinct? items)
       (cond ((null? items) #t)
             ((null? (cdr items)) #t)
             ((member (car items) (cdr items)) #f)
             (else (distinct? (cdr items)))))

     (define (multiple-dwelling)
       (let ((baker (amb 1 2 3 4 5))
             (cooper (amb 1 2 3 4 5))
             (fletcher (amb 1 2 3 4 5))
             (miller (amb 1 2 3 4 5))
             (smith (amb 1 2 3 4 5)))
         (require (not (= baker 5)))
         (require (not (= cooper 1)))
         (require (not (= fletcher 5)))
         (require (not (= fletcher 1)))
         (require (> miller cooper))
         (require (not (= (abs (- smith fletcher)) 1)))
         (require (not (= (abs (- fletcher cooper)) 1)))
         (require
           (distinct? (list baker cooper fletcher miller smith)))
         (list (list 'baker baker) (list 'cooper cooper)
               (list 'fletcher fletcher) (list 'miller miller)
               (list 'smith smith))))

     (multiple-dwelling)
     )
  )

(define test-got-1 nil)
(define test-got-2 nil)
(define test-want '(((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))))

(ambeval test-input-1
         the-global-environment
         ;; ambeval success
         (lambda (val next-alternative)
           (set! test-got-1 (cons val test-got-1))
           (next-alternative)
           )
         ;; ambeval failure
         (lambda () (announce-output
                      ";;; There are no more values of")))

(ambeval test-input-2
         the-global-environment
         ;; ambeval success
         (lambda (val next-alternative)
           (set! test-got-2 (cons val test-got-2))
           (next-alternative)
           )
         ;; ambeval failure
         (lambda () (announce-output
                      ";;; There are no more values of")))


(assert (equal? test-got-1 test-got-2))
(assert (equal? test-got-1 test-want))
(assert (equal? test-got-2 test-want))
