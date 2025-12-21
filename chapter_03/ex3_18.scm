;; Answer

(load "../init.scm")

(define (python x)
  (define vis nil)
  (define (inner xx)
    (if (null? xx) false
      (if (memq xx vis)
        true
        (begin
          (set! vis (cons xx vis))
          (inner (cdr xx))))))
  (inner x))

(define p1 (cons 1 nil))

(define p2 (cons 2 p1))

(set-cdr! p1 p2)

(define z (cons p1 p2))

(assert (python z))


