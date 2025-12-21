;; Answer

(define (count-pairs x)
  (define vis '())
  (define (inner xx)
    (if (not (pair? xx))
      0
      (if (memq xx vis)
        0
        (begin
          (set! vis (append xx vis))
          (+ (inner (car xx))
             (inner (cdr xx))
             1)))))
  (inner x))

(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(assert (eq? 1 (count-pairs z1)))
(assert (eq? 3 (count-pairs z2)))
