(define (run-forever) (run-forever))
(define (try p)
  (if (halts? p p) (run-forever) 'halted))

;; observing <try>, 
;; - if <p> is halt on <p>, <try> will run forever
;; - if <p> throw an error or run forever on <p>, return 'halted

;; if <try> halt on <try> (say return 'halt) <try> will run forever
;; if <try> not halt on <try> (say run-forever) <try> will return 'halt 
;; which is contradictory -> such <halt?> not exist
