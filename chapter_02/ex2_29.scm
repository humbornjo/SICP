;; Answer

(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))

; a.

(define (left-branch mob) (car mob))
(define (right-branch mob) (cadr mob))
(define (branch-length bch) (car bch))
(define (branch-structure bch) (cadr bch))

; b.

(define (total-weight mob)
  (cond
    ((null? mob) 0)
    ((not (pair? mob)) mob)
    (else
      (+
        (total-weight (branch-structure (left-branch mob)))
        (total-weight (branch-structure (right-branch mob)))))))

; c.

(define (balanced? mob)
  (cond ((null? mob) #t)
        ((not (pair? mob)) #t)
        (else
          (and (= (* (branch-length (left-branch mob))
                     (total-weight (branch-structure (left-branch mob))))
                  (* (branch-length (right-branch mob))
                     (total-weight (branch-structure (right-branch mob)))))
               (balanced? (branch-structure (left-branch   mob)))
               (balanced? (branch-structure (right-branch  mob)))))))

(define m1 (make-mobile
             (make-branch 4 6)
             (make-branch 5
                          (make-mobile
                            (make-branch 3 7)
                            (make-branch 9 8)))))

(define m2 (make-mobile
             (make-branch 4 6)
             (make-branch 2
                          (make-mobile
                            (make-branch 5 8)
                            (make-branch 10 4)))))

(assert (not (balanced? m1)))
(assert (balanced? m2))

; d.

(define (make-mobile left right) (cons left right))
(define (make-branch length structure) (cons length structure))

; Just redefine the selector:

(define (left-branch mob) (car mob))
(define (right-branch mob) (cdr mob))
(define (branch-length bch) (car bch))
(define (branch-structure bch) (cdr bch))

(define m1 (make-mobile
             (make-branch 4 6)
             (make-branch 5
                          (make-mobile
                            (make-branch 3 7)
                            (make-branch 9 8)))))

(define m2 (make-mobile
             (make-branch 4 6)
             (make-branch 2
                          (make-mobile
                            (make-branch 5 8)
                            (make-branch 10 4)))))

(assert (not (balanced? m1)))
(assert (balanced? m2))
