; Modify the multiple-dwelling procedure to omit the requirement
; that Smith and Fletcher do not live on adjacent floors. How
; many solutions are there to this modified puzzle?

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

;; import func an-integer-between
(load "./ex4_35.scm")

(define (multiple-dwelling)
  (let* ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb (an-integer-between 1 (- fletcher 1))
                    (an-integer-between (+ fletcher 1) 5))))
    (require
      (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    ; (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker) (list 'cooper cooper)
          (list 'fletcher fletcher) (list 'miller miller)
          (list 'smith smith))))


;; Test

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between low high)
       (require (<= low high))
       (amb low (an-integer-between (+ low 1) high)))

     (define (multiple-dwelling)
       (let* ((baker (amb 1 2 3 4 5))
              (cooper (amb 1 2 3 4 5))
              (fletcher (amb 1 2 3 4 5))
              (miller (amb 1 2 3 4 5))
              (smith (amb (an-integer-between 1 (- fletcher 1))
                          (an-integer-between (+ fletcher 1) 5))))
         (require
           (distinct? (list baker cooper fletcher miller smith)))
         (require (not (= baker 5)))
         (require (not (= cooper 1)))
         (require (not (= fletcher 5)))
         (require (not (= fletcher 1)))
         (require (> miller cooper))
         ; (require (not (= (abs (- smith fletcher)) 1)))
         (require (not (= (abs (- fletcher cooper)) 1)))
         (list (list 'baker baker) (list 'cooper cooper)
               (list 'fletcher fletcher) (list 'miller miller)
               (list 'smith smith))))

     (multiple-dwelling)
     )
  )

(define test-got nil)
(define test-want '(((baker 3) (cooper 4) (fletcher 2) (miller 5) (smith 1))
                    ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
                    ((baker 1) (cooper 4) (fletcher 2) (miller 5) (smith 3))
                    ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3))
                    ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5))))

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

