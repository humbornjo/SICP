;; a

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((application? exp) ; <------------------------------------
         (apply (eval (operator exp) env)                      ;  |
                (list-of-values (operands exp) env)))          ;  |
        ((assignment? exp) (eval-assignment exp env))          ;  |
        ((definition? exp) (eval-definition exp env))          ;  |
        ((if? exp) (eval-if exp env))                          ;  |
        ((lambda? exp) (make-procedure (lambda-parameters exp) ;  |
                                       (lambda-body exp)       ;  |
                                       env))                   ;  |
        ((begin? exp)                                          ;  |
         (eval-sequence (begin-actions exp) env))              ;  |
        ((cond? exp) (eval (cond->if exp) env))                ;  |
            ; -----------------------------------------------------
        (else
          (error "Unknown expression type: EVAL" exp))))
;;
;; if louis move application before assignment and definition
;; (define x 3) will be inteperated as application

;; b

(define (application? exp) (tagged-list? exp 'call))




