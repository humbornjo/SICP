(define (right-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (right-split painter (- n 1))))
      (beside painter (below smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
    painter
    (let ((up (up-split painter (- n 1)))
          (right (right-split painter (- n 1))))
      (let ((top-left (beside up up))
            (bottom-right (below right right))
            (corner (corner-split painter (- n 1))))
        (beside (below painter top-left)
                (below bottom-right corner))))))

; exercise 2.44 
(define (up-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (up-split painter (- n 1))))
      (below painter (beside smaller smaller)))))

; exercise 2.45
(define (split bh1 bh2)
  (lambda (painter n)
  (if (= n 0)
    painter
    (let ((smaller ((split bh1 bh2) painter (- n 1))))
      (bh1 painter (bh2 smaller smaller))))))
    
; exercise 2.46
(define (make-vect x y) 
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cadr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect v scalar)
  (make-vect (* scalar (xcor-vect v)) (* scalar (ycor-vect v))))

; exercise 2.47
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame f)
  (car f))
(define (edge1-frame f)
  (cadr f))
(define (edge2-frame f)
  (cadr (cdr f)))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin-frame f)
  (car f))
(define (edge1-frame f)
  (cadr f))
(define (edge2-frame f)
  (cdr (cdr f)))

; exercise 2.48
(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment seg)
  (car seg))

(define (end-segment seg)
  (cdr seg))


; exercise 2.50
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame
                   new-origin
                   (sub-vect (m corner1) new-origin)
                   (sub-vect (m corner2) new-origin))))))

(define (flip-horiz painter) 
  (transform-painter painter (make-vect 1 0) (make-vect 0 0) (make-vect 1 1)))

(define (rotate180 painter) 
  (transform-painter painter (make-vect 1.0 1.0) (make-vect 0.0 1.0) (make-vect 1.0 0.0))) 

(define (rotate270 painter) 
  (transform-painter painter (make-vect 0.0 1.0) (make-vect 0.0 0.0) (make-vect 1.0 1.0))) 

; exercise 2.51
(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom
            (transform-painter
              painter1
              (make-vect 0.0 0.0)
              (make-vect 0.0 1.0)
              split-point))
          (paint-top
            (transform-painter
              painter2
              split-point
              (make-vect 1.0 0.5)
              (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))

(define (below painter1 painter2)
  (rotate270 (rotate180 (beside (rotate270 painter1) (rotate270 painter2)))))

; exercise 2.52
;; b
(define (corner-split painter n)
  (if (= n 0)
    painter
    (let ((up (up-split painter (- n 1)))
          (right (right-split painter (- n 1))))
      (let ((corner (corner-split painter (- n 1))))
        (beside (below painter (up-split painter (- n 1)))
                (below (right-split painter (- n 1)) corner))))))

;; c
(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define (square-limit painter n)
  (let ((combine4 (square-of-four identity flip-horiz 
                                  flip-vert rotate180)))
    (combine4 (corner-split painter n))))

