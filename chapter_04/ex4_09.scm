;; suppose impl c style for loop which
;; 
;; for (init; condition; step){
;;   exp;
;; }
;; 
;; the scheme syntax would be
;; (for init condition step exp)

;; example: 
;; (for 
;;   (a 10)
;;   (< a 20) 
;;   (lambda (x) (+ x 1)) 
;;   (if (eq? (square a) 25) (display a)))

(load "eval_init.scm")

(define (for->combination exp)
  (let* 
    ((init (cadr exp))
     (var (list (car init)))
     (val (list (cadr init)))
     (condition (caddr exp))
     (step (cadddr exp))
     (body (car (cddddr exp))))
    (sequence->exp 
      (list (make-definition 
              'for-ref 
              var
              (make-if 
                condition 
                (sequence->exp 
                  (list body 
                        (list 'for-ref 
                              (cons (make-lambda var (list step)) var))))
                'nil))
            (cons 'for-ref val)))))

;; main

(assert 
  (eq? (eval (sequence->exp 
               `(list
                  (define x 0)
                  ,(for->combination 
                     '(for 
                        (a 0) 
                        (< a 20) 
                        (+ a 1)
                        (if (eq? a 15) (set! x a))
                        ))
                  x
                  )))
       15))

