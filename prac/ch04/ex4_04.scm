(load "eval_init.scm")

(define (and? exp) (tagged-list? exp 'and))
(define (or? exp) (tagged-list? exp 'or))

;; special form
(define (eval-and exp env)
  (define (inner seq env prev)
    (cond ((null? seq) prev)
          ((not (true? (eval (car seq)))) false)
          (else (inner (cdr seq) env (eval (car seq))))))
  (inner (cdr exp) env true))

(define (eval-or exp env)
  (define (inner seq env prev)
    (cond ((null? (car seq)) prev)
          ((true? (eval (car seq))) true)
          (else (inner (cdr seq) env (eval (car seq))))))
  (inner (cdr exp) env false))

;; derived form 
(define (and->if exp) (expand-and (cdr exp) 'true))
(define (expand-and seq prev)
  (if (null? seq) 
    prev
    (let ((first (car seq))
          (rest (cdr seq)))
      (make-if first
               (expand-and rest (eval first))
               false))))

(define (or->if exp) (expand-or (cdr exp) 'false))
(define (expand-or seq prev)
  (if (null? seq) 
    prev
    (let ((first (car seq))
          (rest (cdr seq)))
      (make-if first
               true
               (expand-or rest (eval first))))))


;; main

(assert (eq? #t (eval-and '(and #t #t) '())))
(assert (eq? #t (eval-or '(and #f #t) '())))

(assert (eq? #t (eval (and->if '(and #t #t #t)))))
(assert (eq? #t (eval (or->if '(or #f #f #t)))))

