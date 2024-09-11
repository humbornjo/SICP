(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval
    x
    (make-interval (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y)))))

; exercise 2.7
(define (make-interval a b) (cons a b))
(define (upper-bound x) (cdr x))
(define (lower-bound x) (car x))


; exercise 2.8
(define (sub-interval x y) 
  (make-interval (- (lower-bound x) (lower-bound y))
                 (- (upper-bound x) (upper-bound y))))


; exercise 2.10
;; if a interval span over 0, then this interval include some 
;; value that very close to 0, divide those values could lead 
;; to very large and meaningless result
(define (div-interval x y)
  (if (<= (* (upper-bound y) (lower-bound y)) 0) 
    (error "Division error (interval spans 0)" y)
    (mul-interval
      x
      (make-interval (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y))))))


; exercise 2.11
(define (pos-interval x)
  (and (> (upper-bound x) 0) (> (lower-bound x) 0)))
(define (neg-interval x)
  (and (< (upper-bound x) 0) (< (lower-bound x) 0)))
(define (span-interval x)
  (and (<= (lower-bound x) 0) (<= 0 (upper-bound x))))

(define (mul-interval x y)
  (let 
    ((lox (lower-bound x))
     (hix (upper-bound x))
     (loy (lower-bound y))
     (hiy (upper-bound y)))
    (cond 
      ((and (pos-interval x) (pos-interval y)) (make-interval (* lox loy) (* hix hiy)))
      ((and (pos-interval x) (neg-interval y)) (make-interval (* hix loy) (* lox hiy)))
      ((and (pos-interval x) (span-interval y)) (make-interval (* hix loy) (* hix hiy)))
      ((and (neg-interval x) (pos-interval y)) (make-interval (* lox hiy) (* hix loy)))
      ((and (neg-interval x) (neg-interval y)) (make-interval (* hix hiy) (* lox loy)))
      ((and (neg-interval x) (span-interval y)) (make-interval (* lox hiy) (* lox loy)))
      ((and (span-interval x) (pos-interval y)) (make-interval (* lox hiy) (* hix hiy)))
      ((and (span-interval x) (neg-interval y)) (make-interval (* hix loy) (* lox loy)))
      (else 
        (let 
          ((p1 (* lox loy))
           (p2 (* lox hiy))
           (p3 (* hix loy))
           (p4 (* hix hiy)))
          (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4)))))))

(begin
  (define (print-interval name i) 
    (newline) 
    (display name) 
    (display ": [") 
    (display (lower-bound i)) 
    (display ",") 
    (display (upper-bound i)) 
    (display "]")) 

  (define i (make-interval 2 7)) 
  (define j (make-interval -1 3)) 
  (define jj (make-interval -2 10)) 
  (define k (make-interval -10 -7)) 

  (print-interval "i" i) 
  (print-interval "j" j) 
  (print-interval "jj" jj) 
  (print-interval "k" k) 

  (print-interval "i*i" (mul-interval i i)) 
  (print-interval "i*j" (mul-interval i j)) 
  (print-interval "i*k" (mul-interval i k)) 

  (print-interval "j*i" (mul-interval j i)) 
  (print-interval "j*j" (mul-interval j j)) 
  (print-interval "j*k" (mul-interval j k)) 

  (print-interval "k*i" (mul-interval k i)) 
  (print-interval "k*j" (mul-interval k j)) 
  (print-interval "k*k" (mul-interval k k)) 

  (print-interval "j*jj" (mul-interval j jj)) 
)

; exercise 2.12
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c p)
  (let 
    ((w (abs (* c (/ p 100.0)))))
    (make-interval (- c w) (+ c w))))
(define (percent i)
  (abs (* 100(/ (width i) (center i)))))

(begin
  (define i (make-center-percent 10 0.5)) 
  (define j (make-center-percent 10 0.4)) 
  (newline)
  (display "lower bound of 10-50%: ")
  (display (lower-bound i)) 
  (newline)
  (display "upper bound of 10-50%: ")
  (display (upper-bound i))
  (newline)
  (display "center of 10-50%: ")
  (display (center i))
  (newline)
  (display "percent of 10-50%: ")
  (display (percent (mul-interval i j)))
)

; exercise 2.13
(begin
  (define (make-interval a b) (cons a b)) 
  (define (upper-bound interval) (max (car interval) (cdr interval))) 
  (define (lower-bound interval) (min (car interval) (cdr interval))) 
  (define (center i) (/ (+ (upper-bound i) (lower-bound i)) 2)) 

  ;; Percent is between 0 and 100.0 
  (define (make-interval-center-percent c pct) 
    (let ((width (* c (/ pct 100.0)))) 
      (make-interval (- c width) (+ c width)))) 

  (define (percent-tolerance i) 
    (let ((center (/ (+ (upper-bound i) (lower-bound i)) 2.0)) 
          (width (/ (- (upper-bound i) (lower-bound i)) 2.0))) 
      (* (/ width center) 100))) 

  (define (mul-interval x y) 
    (let ((p1 (* (lower-bound x) (lower-bound y))) 
          (p2 (* (lower-bound x) (upper-bound y))) 
          (p3 (* (upper-bound x) (lower-bound y))) 
          (p4 (* (upper-bound x) (upper-bound y)))) 
      (make-interval (min p1 p2 p3 p4) 
                     (max p1 p2 p3 p4)))) 

  (define i (make-interval-center-percent 10 0.5)) 
  (define j (make-interval-center-percent 10 0.4)) 
  (percent-tolerance (mul-interval i j)))

; exercise 2.14
;; a = [ca*(1 - pa), ca*(1 + pa)]
;; b = [cb*(1 - pb), cb*(1 + pb)]
;; a*b = [ca*cb*(1 - (pa + pb) + 0.5*pa*pb), ca*cb*(1 + (pa + pb) + 0.5*pa*pb)]
;; pa*pb -> 0
;; a*b = [ca*cb*(1 - (pa + pb)), ca*cb*(1 + (pa + pb))]

; exercise 2.15
(begin
  (define (par1 r1 r2)
    (div-interval (mul-interval r1 r2)
                  (add-interval r1 r2)))
  (define (par2 r1 r2)
    (let ((one (make-interval 1 1)))
      (div-interval
        one (add-interval (div-interval one r1)
                          (div-interval one r2)))))

  (define i (make-interval-center-percent 10 0.5)) 
  (define j (make-interval-center-percent 20 0.4)) 

  (print-interval "i" i) 
  (print-interval "j" j) 
  (newline)
  (display "par1: ")
  (display (par1 i j))
  (newline)
  (display "par2: ")
  (display (par2 i j))
)

; exercise 2.15
;; http://community.schemewiki.org/?sicp-ex-2.14-2.15-2.16
;; - since R_1 + R_2 reach its minimum when both R_1 and R_2
;; is minimum. however R_1 * R_2 require both R_1 and R_2 
;; at their maximum to reach its maxmum. the above two 
;; statement produce the minimum of (R_1 + R_2)/(R_1 * R_2).
;; - but R_1 nor R_2 cant at their min and max at the same 
;; time.
;; - as the solution on the website explained, they are 
;; mutual dependent.

; exercise 2.16
;; http://community.schemewiki.org/?sicp-ex-2.14-2.15-2.16
;; - No, I dont think it is possible.
;; - we are actually solving a extreme problem using algebra
;; and algebra have no memory, so we simply have no way to 
;; do it right except change the underneath formula.
;; - it is a fiendish question for mortal like me, sadly true.
