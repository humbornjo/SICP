;; Answer

(load "./eval_init_seq.scm")

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))

(define x (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(assert (equal? (list 22 26 30) (accumulate-n + 0 x)))
