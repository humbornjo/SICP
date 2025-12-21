(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))

;; main

;; * What happens if we attempt to evaluate (factorial 5)?
;; - The indefinite loop of evaluation on <(* n (factorial (- n 1)))>


;; * Will our definitions work in a normal-order language?
;; - Yes, unless will be expanded to 
;; 
;;     (if (= n 1)
;;       1
;;       (* n (factorial (- n 1))))
;; 
;;   and the args are evaluated in order where they are really needed.



