; In the multiple dwelling problem, how many sets of assignments
; are there of people to floors, both before and after the requirement
; that floor assignments be distinct? It is very inefficient to
; generate all possible assignments of people to floors and then
; leave it to backtracking to eliminate them. For example, most
; of the restrictions depend on only one or two of the person-floor
; variables, and can thus be imposed before floors have been
; selected for all the people. Write and demonstrate a much more
; efficient non-deterministic procedure that solves this problem
; based upon generating only those possibilities that are not
; already ruled out by previous restrictions. (Hint: This will
; require a nest of let expressions.)

;; Answer

(define (an-integer-between-by-cond low high condition)
  (require (<= low high))
  (if (not (condition low))
    (an-integer-between-by-cond (+ low 1) high condition)
    (amb low (an-integer-between-by-cond (+ low 1) high condition))))

(define (multiple-dwelling)
  (let ((baker (an-integer-between-by-cond 1 5 (lambda (x) (not (= x 5)))))
        (smith (an-integer-between-by-cond 1 5 (lambda (x) #t)))
        (miller (an-integer-between-by-cond 1 5 (lambda (x) #t))))
    (let ((fletcher
            (an-integer-between-by-cond 1 5
                                        (lambda (x)
                                          (not (or
                                                 (not (= (abs (- x smith)) 1))
                                                 (= x 5)
                                                 (= x 1)))))))
      (let ((cooper
              (an-integer-between-by-cond 1 5
                                          (lambda (x)
                                            (not (or
                                                   (not (= (abs (- x fletcher)) 1))
                                                   (< x miller)))))))
        (list (list 'baker baker) (list 'cooper cooper)
              (list 'fletcher fletcher) (list 'miller miller)
              (list 'smith smith))))))
