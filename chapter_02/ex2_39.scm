;; Answer

(load "./ex2_38.scm")

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))
(reverse (list 1 3 0 5 0 1))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))
(reverse (list 1 3 0 5 0 1))
