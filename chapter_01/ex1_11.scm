; A function f is defined by the rule that
;
; f (n) =
;   | n  if n < 3,
;   | f(n-1) + 2f(n-2) + 3f(n-3)  if n \ge 3.
;
; Write a procedure that computes f by means of a recursive
; process. Write a procedure that computes f by means of an
; iterative process.

;; Answer

(define (f n)
  (define (f-iter a b c i)
    (cond ((< n 3) n)
          ((<= n i) a)
          (else (f-iter (+ a (* 2 b) (* 3 c)) a b (+ i 1)))))
  (f-iter 2 1 0 2))

(assert (eq? 4 (f 3)))
