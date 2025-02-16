;; main

;; why it is an issue? when define is performed on a function, it 
;; will finally be converted to a binding like (var, procedure) in 
;; the given env, nothing else. which means it is lazy eval.

;; however, if it is performed on a parameter, then the parameter
;; will be eval immidiately. which will cause dependency error. 

;; I would throw a error, and the simultaneous define will be devised
;; in my impl of intepretor
