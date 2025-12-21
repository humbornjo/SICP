;; Answer

; http://community.schemewiki.org/?sicp-ex-2.14-2.15-2.16
;
; - since R_1 + R_2 reach its minimum when both R_1 and R_2 is
;   minimum. however R_1 * R_2 require both R_1 and R_2 at their
;   maximum to reach its maxmum. the above two statement produce
;   the minimum of (R_1 + R_2)/(R_1 * R_2).
;
; - but R_1 nor R_2 cant at their min and max at the same time.
;
; - as the solution on the website explained, they are mutual
;   dependent.

(load "./ex2_07.scm")
(load "./ex2_12.scm")

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval
      one (add-interval (div-interval one r1)
                        (div-interval one r2)))))


(define i (make-center-width 10 0.5))
(define j (make-center-width 20 0.4))

(begin
  (define test (par1 i j))
  (assert (< (abs (- (lower-bound test) 6.026)) 0.01))
  (assert (< (abs (- (upper-bound test) 7.361)) 0.01)))

(begin
  (define test (par2 i j))
  (assert (< (abs (- (lower-bound test) 6.399)) 0.01))
  (assert (< (abs (- (upper-bound test) 6.932)) 0.01)))
