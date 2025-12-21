; Formulate compound queries that retrieve the following
; information:
;
; a. the names of all people who are supervised by Ben Bitdiddle,
;    together with their addresses;
; b. all people whose salary is less than Ben Bitdiddle’s,
;    together with their salary and Ben Bitdiddle’s salary;
; c. all people who are supervised by someone who is not in the
;    computer division, together with the supervisor’s name and
;    job.


;; Answer

; a.
; (and (supervisor ?x (Bitdiddle Ben)) (address . ?y))

; b.
; (and (salary (Ben Bitdiddle) ?amt_b)
;      (salary ?emplyee ?amt_x)
;      (lisp-value > ?amt_b ?amt_x))

; c.
; (and (supervisor ?people ?someone)
;      (not (job ?someone (computer . ?x))))
