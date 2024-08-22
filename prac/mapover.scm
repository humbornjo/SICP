(define (scale-list items factor)
  (if (null? items)
    '()
    (cons (* (car items) factor)
          (scale-list (cdr items)
                      factor))))
(scale-list (list 1 2 3 4 5) 10)

(define (map proc items)
  (if (null? items)
    '()
    (cons (proc (car items))
          (map proc (cdr items)))))
(map abs (list -10 2.5 -11.6 17))
(map (lambda (x) (* x x)) (list 1 2 3 4))

(cons (list 1 2) (list 3 4))
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

; exercise 2.21
(define (square-list items)
  (if (null? items)
    '()
    (cons (square (car items)) (square-list (cdr items)))))
(square-list (list 1 2 3 4))

(define (square-list items)
  (map (lambda (x) (* x x)) items))
(square-list (list 1 2 3 4))

; exercise 2.22
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons (square (car things))
                  answer))))
  (iter items '()))
;; because list in lisp is like [scalar, list]
;; rather [list, scalar]

; exercise 2.23
(define (for-each proc items)
  (cond ((not (null? items)) (proc (car items)) (for-each proc (cdr items)))))

(for-each (lambda (x)
            (newline)
            (display x))
          (list 57 321 88))

; exercise 2.25
(define lx (list 1 3 (list 5 7) 9))
(cadr (car (cdr (cdr lx))))

(define ly (list (list 7)))
(car (car ly))

(define lz (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(cadr (cadr (cadr (cadr (cadr (cadr lz))))))

; exercise 2.26
(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y) ; (1 2 3 4 5 6)
(cons x y)   ; ((1 2 3) 4 5 6))
(list x y)   ; ((1 2 3) (4 5 6))


; exercise 2.27
(define x (list (list 1 (list 10 11 12)) (list 3 4)))
(define (deep-reverse x) 
  (if (null? (cdr x))
    (if (pair? (car x))
      (list (deep-reverse (car x)))
      x)
    (if (pair? (car x))
      (append (deep-reverse (cdr x)) (list (deep-reverse (car x))))
      (append (deep-reverse (cdr x)) (list (car x))))))

(deep-reverse x)


; exercise 2.28
(define x (list (list 1 2) (list 3 4 5)))
(define (fringe items)
  (if (null? items)
    '()
    (if (pair? (car items))
      (append (fringe (car items)) (fringe (cdr items)))
      (cons (car items) (fringe (cdr items))))))
(fringe x)
(fringe (list (list (list 1 2 3 19 283 38) 2 3 2) (list 2 3 (list 217 382 1827) 2 187 (list 2838)) 2 1 2 (list 2 (list 3 (list 3)) 23 2 1 238)))

; exercise 2.29
(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))
;; a
(define (left-branch mob)
  (car mob))
(define (right-branch mob)
  (cadr mob))
(define (branch-length bch)
  (car bch))
(define (branch-structure bch)
  (cadr bch))

;; b
(define (total-weight mob) 
  (cond 
    ((null? mob) 0)
    ((not (pair? mob)) mob)
    (else 
      (+ 
        (total-weight (branch-structure (left-branch mob))) 
        (total-weight (branch-structure (right-branch mob)))))))

(define m1 (make-mobile 
             (make-branch 4 6) 
             (make-branch 5 
                          (make-mobile 
                            (make-branch 3 7) 
                            (make-branch 9 8))))) 
(total-weight m1)

;; c
(define (balanced? mob) 
  (cond ((null? mob) #t) 
        ((not (pair? mob)) #t) 
        (else 
          (and (= (* (branch-length (left-branch mob)) 
                     (total-weight (branch-structure (left-branch mob)))) 
                  (* (branch-length (right-branch mob)) 
                     (total-weight (branch-structure (right-branch mob))))) 
               (balanced? (branch-structure (left-branch   mob))) 
               (balanced? (branch-structure (right-branch  mob))))))):w 

(define m2 (make-mobile 
             (make-branch 4 6) 
             (make-branch 2 
                          (make-mobile 
                            (make-branch 5 8) 
                            (make-branch 10 4))))) 

(balanced? m2) 
(balanced? m1)

;; d
(define (make-mobile left right) (cons left right))
(define (make-branch length structure)
  (cons length structure))

;; we just need to redefine the selector
(define (left-branch mob)
  (car mob))
(define (right-branch mob)
  (cdr mob))
(define (branch-length bch)
  (car bch))
(define (branch-structure bch)
  (cdr bch))

(begin
  (define m1 
    (make-mobile 
      (make-branch 4 6) 
      (make-branch 5 
                   (make-mobile 
                     (make-branch 3 7) 
                     (make-branch 9 8))))) 
  (define m2 
    (make-mobile 
      (make-branch 4 6) 
      (make-branch 2 
                   (make-mobile 
                     (make-branch 5 8) 
                     (make-branch 10 4))))) 

  (balanced? m2) 
  (balanced? m1))

;;;;;;;;;;;;;;;;;;;;;

(define nil '())
(define (scale-tree tree factor)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (* tree factor))
        (else (cons (scale-tree (car tree) factor)
                    (scale-tree (cdr tree) factor)))))
(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)) 10)

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
           (scale-tree sub-tree factor)
           (* sub-tree factor)))
       tree))

; exercise 2.30
(define (square-tree tree)
  (cond 
    ((null? tree) nil)
    ((not (pair? tree)) (* tree tree))
    (else 
      (cons (square-tree (car tree)) (square-tree (cdr tree))))))

(square-tree 
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

(define (square-tree tree)
  (map (lambda (x) 
         (if (pair? x)
           (square-tree x)
           (* x x)))
       tree))

(square-tree 
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

; exercise 2.31
(define (tree-map f tree) 
  (map (lambda (x) 
         (if (pair? x)
           (square-tree x)
           (f x)))
       tree))
  )

(define (square-tree tree) (tree-map square tree))

(square-tree 
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

; exercise 2.32
(define (subsets s)
  (if (null? s)
    (list nil)
    (let ((rest (subsets (cdr s))))
      (append rest (map (lambda (x) (cons (car s) x)) rest)))))

(subsets (list 1 2 3))

