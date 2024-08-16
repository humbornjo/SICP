;; (cons 1 (cons 2 (cons 3 (cons 4 nil))))
(define lx (list 1 2 3 4))
(define ly (list 5 6 7 8))

(car lx)
(cdr lx)

(define (list-ref items n)
  (if (= n 0)
    (car items)
    (list-ref (cdr items) (- n 1))))
(define squares (list 1 4 9 16 25))
(list-ref squares 3)

(define (length items)
  (if (null? items)
    0
    (+ 1 (length (cdr items)))))
(define odds (list 1 3 5 7))
(length odds)

(define (length items)
  (define (length-iter a count)
    (if (null? a)
      count
      (length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))

(define (append list1 list2)
  (if (null? list1)
    list2
    (cons (car list1) (append (cdr list1) list2))))
(append lx ly)

; exercise 2.17
(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))))

(last-pair (list 23 72 149 34))

; exercise 2.18
(define (reverse x) 
  (if (null? (cdr x))
    x
    (append (reverse (cdr x)) (list (car x)))))

(reverse (list 1 4 9 16 25))

; exercise 2.19
(define (first-denomination x)
  (car x))
(define (except-first-denomination x)
  (cdr x))
(define (no-more? x)
  (null?  x))
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                 (except-first-denomination
                   coin-values))
             (cc (- amount
                    (first-denomination
                      coin-values))
                 coin-values)))))

(define us-coins (list 50 25 10 5 1))
(cc 100 us-coins)

; exercise 2.20
(define (same-parity . x)
  (define (same-parity-list xx)
    (cond 
      ((null? xx) xx)
      ((null? (cdr xx)) xx)
      (else
        (if 
          (= (remainder (+ (car xx) (cadr xx)) 2) 0)
          (cons (car xx) (same-parity-list (cdr xx)))
          (same-parity-list (cons (car xx) (cdr (cdr xx))))))))
  (same-parity-list x))
    
(same-parity 1 2 2 4 5 6)
(same-parity 2 3 4 5 6 7)
