;; Answer

(load "./ex2_67.scm")

(define (encode message tree)
  (if (null? message)
    '()
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))

(define (encode-symbol sym tree)
  (if (leaf? tree)
    (if (eq? sym (symbol-leaf tree))
      '()
      (error "missing symbol: ENCODE-SYMBOL" sym))
    (let ((left (left-branch tree)))
      (if (memq sym (symbols left))
        (cons 0 (encode-symbol sym left))
        (cons 1 (encode-symbol sym (right-branch tree)))))))
