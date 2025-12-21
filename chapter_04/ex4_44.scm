; Exercise 2.42 described the “eight-queens puzzle” of placing
; queens on a chessboard so that no two attack each other. Write
; a nondeterministic program to solve this puzzle.

;; Answer

(define (sequence N)
  (define (inner n)
    (if (> n N)
      '()
      (cons n (inner (+ n 1)))))
  (inner 1))

(define (find-n lst n)
  (if (null? lst)
    '()
    (if (= n 1)
      (car lst)
      (find-n (cdr lst) (- n 1)))))

(define (rest-n lst n)
  (if (= n 1)
    (cdr lst)
    (cons (car lst) (rest-n (cdr lst) (- n 1)))))

(define (length lst)
  (if (null? lst)
    0
    (+ 1 (length (cdr lst)))))

(define (permutation-amb lst)
  (define length (length lst))
  (define (inner lst N)
    (let ((fix (find-n lst N))
          (rest (rest-n lst N)))
      (if (null? rest)
        (cons fix '())
        (cons fix (permutation-amb rest)))))
  (inner lst (an-integer-between 1 length)))

(define (N-queens N)
  (define (queen-kills queens)
    (define (inner queens start n)
      (require (not (= n
                       (abs (- (find-n queens start) (find-n queens (+ start n)))))))
      (if (= (+ start n) N)
        #t
        (inner queens start (+ n 1))))

    (define (iterator queens start)
      (if (= start N)
        #t
        (begin
          (inner queens start 1)
          (iterator queens (+ start 1))))
      )
    (iterator queens 1))

  (let ((queens (permutation-amb (sequence N))))
    (queen-kills queens)
    queens))

;; Test

(define test-input
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (an-integer-between low high)
       (require (<= low high))
       (amb low (an-integer-between (+ low 1) high)))

     (define (sequence N)
       (define (inner n)
         (if (> n N)
           '()
           (cons n (inner (+ n 1)))))
       (inner 1))

     (define (find-n lst n)
       (if (null? lst)
         '()
         (if (= n 1)
           (car lst)
           (find-n (cdr lst) (- n 1)))))

     (define (rest-n lst n)
       (if (= n 1)
         (cdr lst)
         (cons (car lst) (rest-n (cdr lst) (- n 1)))))

     (define (length lst)
       (if (null? lst)
         0
         (+ 1 (length (cdr lst)))))

     (define (permutation-amb lst)
       (define length (length lst))
       (define (inner lst N)
         (let ((fix (find-n lst N))
               (rest (rest-n lst N)))
           (if (null? rest)
             (cons fix '())
             (cons fix (permutation-amb rest)))))
       (inner lst (an-integer-between 1 length)))

     (define (N-queens N)
       (define (queen-kills queens)
         (define (inner queens start n)
           (require (not (= n
                            (abs (- (find-n queens start) (find-n queens (+ start n)))))))
           (if (= (+ start n) N)
             #t
             (inner queens start (+ n 1))))

         (define (iterator queens start)
           (if (= start N)
             #t
             (begin
               (inner queens start 1)
               (iterator queens (+ start 1))))
           )
         (iterator queens 1))

       (let ((queens (permutation-amb (sequence N))))
         (queen-kills queens)
         queens))

     (N-queens 5))
  )

(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-got nil)
(define test-want 10)

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

(assert (equal? (length test-got) test-want))
