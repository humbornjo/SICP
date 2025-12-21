;; (lambda ⟨vars⟩
;;   (define u ⟨e1⟩)
;;   (define v ⟨e2⟩)
;;   ⟨e3⟩)

;; main 

;; when eval <e3>
;; it will be sth like 
;; (let ((var1 *unassigned*))
;;    (set! var1 val1)
;;    <body>)

;; with: let    -> lambda
;;       lambda -> procedure
;; (lambda (var1) ((set! var1 val1) <body>))

;; every time you call "eval-sequence" the env extend one more time
;; "eval-sequence" is called by "compound-procedure"
;; "compound-procedure" is only called when its tag is 'procedure

;; and when you turn a let into a procedure, it will be sealed with
;; that tag, so the env will extend.

;; If we want to avoid extra env frame, then the let should not be
;; spawned. and the easiest way to achieve that is merge the inner 
;; lambda and outter lambda
