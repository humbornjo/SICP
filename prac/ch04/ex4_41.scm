; Write an ordinary Scheme program to solve the multiple dwelling
; puzzle.

(define (distinct? items)
  (cond ((null? items) #t)
        ((null? (cdr items)) #t)
        ((member (car items) (cdr items)) #f)
        (else (distinct? (cdr items)))))

;; Answer

(define (multiple-dwelling)
  (define tenants (list 1 1 1 1 1))
  (define (inc tenants)
    (if (null? tenants)
      #f
      (begin
        (set-car! tenants (+ 1 (car tenants)))
        (if (> (car tenants) 5)
          (begin
            (set-car! tenants 1)
            (inc (cdr tenants)))
          #t))))

  (define (check tenants)
    (let ((baker (car tenants))
          (cooper (cadr tenants))
          (fletcher (caddr tenants))
          (miller (cadddr tenants))
          (smith (cadr (cdddr tenants))))
      (and
        (distinct? tenants)
        (not (= baker 5))
        (not (= cooper 1))
        (not (= fletcher 5))
        (not (= fletcher 1))
        (> miller cooper)
        (not (= (abs (- smith fletcher)) 1))
        (not (= (abs (- fletcher cooper)) 1)))
      ))

  (define (print tenants)
    (let ((baker (car tenants))
          (cooper (cadr tenants))
          (fletcher (caddr tenants))
          (miller (cadddr tenants))
          (smith (cadr (cdddr tenants))))

      (display (list (list 'baker baker) (list 'cooper cooper)
                     (list 'fletcher fletcher) (list 'miller miller)
                     (list 'smith smith)))))

  (define (inner tenants)
    (if (inc tenants)
      (begin
        (if (check tenants) (print tenants))
        (inner tenants))))

  (inner tenants))


;; ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;; (multiple-dwelling)
