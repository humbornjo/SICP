;; What work will the execution procedure produced by Alyssa’s program do? 
;; - it will produce the same result as the original version, but delay the 
;;   analyze of <execute-sequence> to the execution stage.

;; What about the execution procedure produced by the program in the text above? 
;; - it will execute proc one by one, and analyze <execute-sequence> every time
;;   it step into next procedure.

;; How do the two versions compare for a sequence with two expressions?
;; - there will be remaining part of analyze in execution in Alyssa’s version.
