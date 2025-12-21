;; Answer

(load "./ex2_65.scm")

(define (lookup given-key set-of-records)
  (if (null? set-of-records) #f
    (let ((val (entry set-of-records)))
      (cond ((= given-key val) val)
            ((> given-key val) (lookup given-key (right-branch set-of-records)))
            (else (lookup given-key (left-branch set-of-records)))))))

(assert (lookup 31 t1))
(assert (not (lookup 31 t2)))
