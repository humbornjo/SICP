;; Answer

(load "./ex2_40.scm")

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

(assert (eq? 92 (length (queens 8))))
