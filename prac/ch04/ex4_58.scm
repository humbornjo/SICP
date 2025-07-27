; Define a rule that says that a person is a “big shot” in a
; division if the person works in the division but does not have
; a supervisor who works in the division.


;; Answer

(rule (is-big-shot ?person)
      (and (job ?person (?division . ?x))
           (supervisor ?person ?supervisor)
           (not (job ?supervisor (?division . ?y))))
      )
