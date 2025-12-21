;; Answer

; if a interval span over 0, then this interval include some
; value that very close to 0, divide those values could lead to
; very large and meaningless result

(define (div-interval x y)
  (if (<= (* (upper-bound y) (lower-bound y)) 0)
    (error "Division error (interval spans 0)" y)
    (mul-interval
      x
      (make-interval (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y))))))
