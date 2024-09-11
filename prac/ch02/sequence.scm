(define nil '())
(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares (car tree))
                 (sum-odd-squares (cdr tree))))))

(define (even-fibs n)
  (define (next k)
    (if (> k n)
      nil
      (let ((f (fib k)))
        (if (even? f)
          (cons f (next (+ k 1)))
          (next (+ k 1))))))
  (next 0))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))
(enumerate-interval 2 7)

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))
(enumerate-tree (list 1 (list 2 (list 3 4)) 5))

(define (sum-odd-squares tree)
  (accumulate
    + 0 (map square (filter odd? (enumerate-tree tree)))))


(define (product-of-squares-of-odd-elements sequence)
  (accumulate * 1 (map square (filter odd? sequence))))
(product-of-squares-of-odd-elements (list 1 2 3 4 5))

; exercise 2.33
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

; exercise 2.34
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) 
                (+ this-coeff (* higher-terms x)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))

; exercise 2.35
(define (count-leaves-recursive t) 
  (accumulate + 0 (map (lambda (node) 
                         (if (pair? node) 
                           (count-leaves-recursive node) 
                           1)) 
                       t))))))

; exercise 2.36
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))

(define x (list (list 1 2 3) (list 40 50 60) (list 700 800 900))) 
(accumulate-n + 0 x)

; exercise 2.37
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

(define (transpose mat)
  (accumulate-n (lambda (x y) (cons x y)) nil mat))

(transpose x)

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))

; exercise 2.38
;; http://community.schemewiki.org/?sicp-ex-2.38
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
      result
      (iter (op result (car rest))
            (cdr rest))))
  (iter initial sequence))

(define (fold-right op initial sequence)
  (accumulate op initial sequence))

; exercise 2.39
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))
(reverse (list 1 3 0 5 0 1))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))
(reverse (list 1 3 0 5 0 1))

; nesting mapping
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (flatmap
                            (lambda (i)
                              (map (lambda (j) (list i j))
                                   (enumerate-interval 1 (- i 1))))
                            (enumerate-interval 1 n)))))

(define (permutations s)
  (if (null? s) ; empty set?
    (list nil)  ; sequence containing empty set
    (flatmap (lambda (x)
               (map (lambda (p) (cons x p))
                    (permutations (remove x s))))
             s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (prime? x) 
  (define (test divisor) 
    (cond ((> (* divisor divisor) x) true) 
          ((= 0 (remainder x divisor)) false) 
          (else (test (+ divisor 1))))) 
  (test 2))

; exercise 2.40
(define (unique-pair n)
  (flatmap
    (lambda (i)
      (map (lambda (j) (list i j))
           (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))

(define (prime-sum-pairs n) 
  (map make-pair-sum
       (filter prime-sum? (unique-pair n))))

(prime-sum-pairs 6)

; exercise 2.41
;; http://community.schemewiki.org/?sicp-ex-2.41 @Woofy's ans is good 
(define (sum-of-two n s)
  (filter 
    (lambda (x) (= s (+ (car x) (cadr x)))) 
    (unique-pair n)))

(define (sum-of-three n s) 
  (flatmap  
    (lambda (x) 
      (map 
        (lambda (xx) (append (list x) xx)) 
        (sum-of-two (- x 1) (- s x))))  
    (enumerate-interval 1 n)))

(sum-of-three 10 15)

; exercise 2.42
(define empty-board '())

(define (adjoin-position row col rest)
  (cons (list row col) rest))

(define (safe? k pos)
  (define (safe-cmp span other)
    (if (null? other)
      #t
      (let 
        ((r (car (car pos)))
         (c (car (cadr pos))))
        (and 
          (not (= (car (car other)) r))
          (not (= (car (car other)) (+ r span)))
          (not (= (car (car other)) (- r span)))
          (safe-cmp (+ 1 span) (cdr other)))
        )))
  (safe-cmp 1 (cdr pos)))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(length (queens 8))
(length (queens 11))

; exercise 2.43
;; http://community.schemewiki.org/?sicp-ex-2.43 
;; I think @woofy's answer is right
