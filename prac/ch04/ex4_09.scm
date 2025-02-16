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

(define (for->combination exp)
  (let* 
    ((init (cadr exp))
     (var (list (car init)))
     (val (list (cadr init)))
     (pred (caddr exp))
     (step (cadddr exp))
     (body (caddddr actions)))
    (sequence->exp 
      (list (make-definition 
              'while-ref 
              var
              (make-if 
                pred 
                (sequence->exp 
                  (list body (list 'while-ref (step var))))
                'nil))
            (cons 'while-ref val)))))

(for->combination 
  '(for 
     (a 10) 
     (< a 20) 
     (+ a 1) 
     (if (eq? (square a) 25) (display a))))
