; Use the amb evaluator to solve the following puzzle:49
;
; Mary Ann Moore’s father has a yacht and so has each of his four
; friends: Colonel Downing, Mr. Hall, Sir Barnacle Hood, and
; Dr. Parker. Each of the five also has one daughter and each has
; named his yacht after a daughter of one of the others. Sir
; Barnacle’s yacht is the Gabrielle, Mr. Moore owns the Lorna;
; Mr. Hall the Rosalind. The Melissa, owned by Colonel Downing,
; is named after Sir Barnacle’s daughter. Gabrielle’s father owns
; the yacht that is named after Dr. Parker’s daughter. Who is
; Lorna’s father?
;
; Try to write the program so that it runs efficiently (see Ex-
; ercise 4.40). Also determine how many solutions there are if
; we are not told that Mary Ann’s last name is Moore.

; (define test-want '(((Lorna Parker) (Melissa Barnacle) (Rosalind Downing) (Gabrielle Hall) (Mary Moore))
;                     ((Lorna Downing) (Melissa Barnacle) (Rosalind Parker) (Gabrielle Hall) (Mary Moore))))

;; Answer

;; Moore    -> Lorna
;; Downing  -> Melissa   [Barnacle]
;; Hall     -> Rosalind
;; Barnacle -> Gabrielle
;; Parker   -> Mary      [Moore]

(define (yacht-puzzle)
  (define (print-father number)
    (cond ((= number 1) 'Moore)
          ((= number 2) 'Downing)
          ((= number 3) 'Hall)
          ((= number 4) 'Barnacle)
          ((= number 5) 'Parker)
          (else (error "Your Father is Ging Freecss")))
    )
  (let ((Lorna (amb 1 2 3 4 5))
        (Melissa(amb 1 2 3 4 5))
        (Rosalind (amb 1 2 3 4 5))
        (Gabrielle (amb 1 2 3 4 5))
        (Mary (amb 1 2 3 4 5)))
    (require (= Mary 1))
    (require (= Melissa 4))
    (require (not (= Gabrielle 5)))

    (require (not (= Lorna 1)))
    (require (not (= Melissa 2)))
    (require (not (= Rosalind 3)))
    (require (not (= Gabrielle 4)))
    (require (not (= Mary 5)))

    (require (or (not (= Lorna 5)) (= Gabrielle 1)))
    (require (or (not (= Melissa 5)) (= Gabrielle 2)))
    (require (or (not (= Rosalind 5)) (= Gabrielle 3)))
    (require (or (not (= Gabrielle 5)) (= Gabrielle 4)))
    (require (or (not (= Mary 5)) (= Gabrielle 5)))

    (require
      (distinct? (list Lorna Melissa Rosalind Gabrielle Mary)))
    (list (list 'Lorna (print-father Lorna))
          (list 'Melissa (print-father Melissa))
          (list 'Rosalind (print-father Rosalind))
          (list 'Gabrielle (print-father Gabrielle))
          (list 'Mary (print-father Mary)))))


;; Mary's Father is not told
(define (yacht-puzzle-advanced)
  (define (print-father number)
    (cond ((= number 1) 'Moore)
          ((= number 2) 'Downing)
          ((= number 3) 'Hall)
          ((= number 4) 'Barnacle)
          ((= number 5) 'Parker)
          (else (error "Your Father is Ging Freecss")))
    )
  (let ((Lorna (amb 1 2 3 4 5))
        (Melissa(amb 1 2 3 4 5))
        (Rosalind (amb 1 2 3 4 5))
        (Gabrielle (amb 1 2 3 4 5))
        (Mary (amb 1 2 3 4 5)))
    ;! (require (= Mary 1))
    (require (= Melissa 4))
    (require (not (= Gabrielle 5)))

    (require (not (= Lorna 1)))
    (require (not (= Melissa 2)))
    (require (not (= Rosalind 3)))
    (require (not (= Gabrielle 4)))
    (require (not (= Mary 5)))

    (require (or (not (= Lorna 5)) (= Gabrielle 1)))
    (require (or (not (= Melissa 5)) (= Gabrielle 2)))
    (require (or (not (= Rosalind 5)) (= Gabrielle 3)))
    (require (or (not (= Gabrielle 5)) (= Gabrielle 4)))
    (require (or (not (= Mary 5)) (= Gabrielle 5)))
    (require
      (distinct? (list Lorna Melissa Rosalind Gabrielle Mary)))
    (list (list 'Lorna (print-father Lorna))
          (list 'Melissa (print-father Melissa))
          (list 'Rosalind (print-father Rosalind))
          (list 'Gabrielle (print-father Gabrielle))
          (list 'Mary (print-father Mary)))))


;; Test

; yacht-puzzle
(define test-input-1
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (yacht-puzzle)
       (define (print-father number)
         (cond ((= number 1) 'Moore)
               ((= number 2) 'Downing)
               ((= number 3) 'Hall)
               ((= number 4) 'Barnacle)
               ((= number 5) 'Parker)
               (else (error "Your Father is Ging Freecss")))
         )
       (let ((Lorna (amb 1 2 3 4 5))
             (Melissa(amb 1 2 3 4 5))
             (Rosalind (amb 1 2 3 4 5))
             (Gabrielle (amb 1 2 3 4 5))
             (Mary (amb 1 2 3 4 5)))
         (require (= Mary 1))
         (require (= Melissa 4))
         (require (not (= Gabrielle 5)))

         (require (not (= Lorna 1)))
         (require (not (= Melissa 2)))
         (require (not (= Rosalind 3)))
         (require (not (= Gabrielle 4)))
         (require (not (= Mary 5)))

         (require (or (not (= Lorna 5)) (= Gabrielle 1)))
         (require (or (not (= Melissa 5)) (= Gabrielle 2)))
         (require (or (not (= Rosalind 5)) (= Gabrielle 3)))
         (require (or (not (= Gabrielle 5)) (= Gabrielle 4)))
         (require (or (not (= Mary 5)) (= Gabrielle 5)))

         (require
           (distinct? (list Lorna Melissa Rosalind Gabrielle Mary)))
         (list (list 'Lorna (print-father Lorna))
               (list 'Melissa (print-father Melissa))
               (list 'Rosalind (print-father Rosalind))
               (list 'Gabrielle (print-father Gabrielle))
               (list 'Mary (print-father Mary)))))

     (yacht-puzzle)
     )
  )

; yacht-puzzle-advanced
(define test-input-2
  `(begin
     (define (require predicate) (if (not predicate) (amb)))

     (define (yacht-puzzle-advanced)
       (define (print-father number)
         (cond ((= number 1) 'Moore)
               ((= number 2) 'Downing)
               ((= number 3) 'Hall)
               ((= number 4) 'Barnacle)
               ((= number 5) 'Parker)
               (else (error "Your Father is Ging Freecss")))
         )
       (let ((Lorna (amb 1 2 3 4 5))
             (Melissa(amb 1 2 3 4 5))
             (Rosalind (amb 1 2 3 4 5))
             (Gabrielle (amb 1 2 3 4 5))
             (Mary (amb 1 2 3 4 5)))
         ;! (require (= Mary 1))
         (require (= Melissa 4))
         (require (not (= Gabrielle 5)))

         (require (not (= Lorna 1)))
         (require (not (= Melissa 2)))
         (require (not (= Rosalind 3)))
         (require (not (= Gabrielle 4)))
         (require (not (= Mary 5)))

         (require (or (not (= Lorna 5)) (= Gabrielle 1)))
         (require (or (not (= Melissa 5)) (= Gabrielle 2)))
         (require (or (not (= Rosalind 5)) (= Gabrielle 3)))
         (require (or (not (= Gabrielle 5)) (= Gabrielle 4)))
         (require (or (not (= Mary 5)) (= Gabrielle 5)))
         (require
           (distinct? (list Lorna Melissa Rosalind Gabrielle Mary)))
         (list (list 'Lorna (print-father Lorna))
               (list 'Melissa (print-father Melissa))
               (list 'Rosalind (print-father Rosalind))
               (list 'Gabrielle (print-father Gabrielle))
               (list 'Mary (print-father Mary)))))

     (yacht-puzzle-advanced)
     )
  )


(load "./eval_init_amb.scm")
(load "./eval_impl_separate_amb.scm")

(define test-got-1 nil)
(define test-want-1 '(((Lorna Downing) (Melissa Barnacle) (Rosalind Parker) (Gabrielle Hall) (Mary Moore))))
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
(assert (equal? test-got-1 test-want-1))

(define test-got-2 nil)
(define test-want-2 '(((Lorna Parker) (Melissa Barnacle) (Rosalind Downing) (Gabrielle Moore) (Mary Hall))
                      ((Lorna Downing) (Melissa Barnacle) (Rosalind Parker) (Gabrielle Hall) (Mary Moore))))
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
(assert (equal? test-got-2 test-want-2))



