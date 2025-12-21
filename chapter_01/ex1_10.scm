;; Answer

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1) (A x (- y 1))))))

(A 1 10)
(A 2 4)

; exercise 1.10
(define (f n) (A 0 n)) ; 2n
(define (g n) (A 1 n)) ; 2^n
(define (h n) (A 2 n)) ; 2^(2^(2^(...))), n times

; A(2, n)   = A(1, A(2, n-1)) = 2^(A(2, n-1))
; A(2, n-1) = A(1, A(2, n-2)) = 2^(A(2, n-2))
; ...
