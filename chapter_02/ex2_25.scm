;; Answer

(define lx (list 1 3 (list 5 7) 9))

(assert (eq? 7 (cadr (car (cdr (cdr lx))))))

(define ly (list (list 7)))

(assert (eq? 7 (car (car ly))))

(define lz (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

(assert (eq? 7 (cadr (cadr (cadr (cadr (cadr (cadr lz))))))))
