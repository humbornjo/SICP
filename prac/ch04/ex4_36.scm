; Exercise 3.69 discussed how to generate the stream of all
; Pythagorean triples, with no upper bound on the size of the
; integers to be searched. Explain why simply replacing
; an-integer-between by an-integer-starting-from in the procedure
; in Exercise 4.35 is not an adequate way to generate arbitrary
; Pythagorean triples. Write a procedure that actually will
; accomplish this. (that is, write a procedure for which repeatedly
; typing try-again would in principle eventually generate all
; Pythagorean triples.)

;; Answer
;;
;; Because backtracing, when try-again is invoked, the branch is
;; restarted from the nearest branch, which is the value picking
;; of k, and try-again will indefinitely increase k to infinity.

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (an-integer-starting-from low)
  (amb low (an-integer-starting-from (+ low 1))))

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-starting-from low)))
    (let ((j (an-integer-starting-from i)))
      (let ((k (an-integer-between j (+ i j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
