;; Answer

(load "./eval_init_seq.scm")

(define (count-leaves-recursive t)
  (accumulate + 0 (map (lambda (node)
                         (if (pair? node)
                           (count-leaves-recursive node)
                           1))
                       t)))
