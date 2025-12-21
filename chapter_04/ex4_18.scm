;; Consider an alternative strategy for scanning out definitions that 
;; translates the example in the text to

;; (lambda ⟨vars⟩
;;   (let ((u '*unassigned*) (v '*unassigned*))
;;     (let ((a ⟨e1⟩) (b ⟨e2⟩))
;;       (set! u a)
;;       (set! v b))
;;     ⟨e3⟩))

;; Here a and b are meant to represent new variable names, created by 
;; the interpreter, that do not appear in the user’s program. Consider 
;; the solve procedure from Section 3.5.4:

;; (define (solve f y0 dt)
;;   (define y (integral (delay dy) y0 dt))
;;   (define dy (stream-map f y))
;;   y)

;; main

;; To determine if it works, we have to figure out how <let> works
;; let -> lambda -> procedure

;; In let -> lambda, what actually happends is (eval ((lambda) vals))
;; and the vals will be evaluated one by one, so y cant see dy, and dy
;; cant see y. so it will not work.
