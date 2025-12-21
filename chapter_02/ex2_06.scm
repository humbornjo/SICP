;; Answer

(load "./eval_init.scm")

(define zero (lambda (f) (lambda (x) x)))

(define one  (lambda (f) (lambda (x) (f x))))

(define two  (lambda (f) (lambda (x) (f (f x)))))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(begin
  (define expected 512)
  (define result (((add-1 one) cube) 2))
  (assert (eq? expected result)))

(define (+ a b)
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x)))))

(begin
  (define expected 256)
  (define result (((+ two one) square) 2))
  (assert (eq? expected result)))

