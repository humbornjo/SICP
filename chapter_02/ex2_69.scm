;; Answer

(load "./ex2_68.scm")

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge ol)
  (if (null? (cdr ol))
    (car ol)
    (let
      ((node (make-code-tree (car ol) (cadr ol))))
      (successive-merge (adjoin-set node (cddr ol))))))

; (display (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1))))
