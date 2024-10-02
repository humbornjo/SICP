; Give some examples that illustrate the difference between the
; streams of Chapter 3 and the "lazier" lazy lists described in
; this section. How can you take advantage of this extra laziness?

(load "eval_init.scm")
(load "eval_impl_normal_memo.scm")

(actual-value
  `(begin
     (define (cons x y)
       (lambda (m) (m x y)))
     (define (car z)
       (z (lambda (p q) p)))
     (define (cdr z)
       (z (lambda (p q) q)))

     (define (list-ref items n)
       (if (= n 0)
         (car items)
         (list-ref (cdr items) (- n 1))))
     (define (map proc items)
       (if (null? items)
         '()
         (cons (proc (car items)) (map proc (cdr items)))))
     (define (scale-list items factor)
       (map (lambda (x) (* x factor)) items))

     (define (add-lists list1 list2)
       (cond ((null? list1) list2)
             ((null? list2) list1)
             (else (cons (+ (car list1) (car list2))
                         (add-lists (cdr list1) (cdr list2))))))
     (define ones (cons 1 ones))
     (define integers (cons 1 (add-lists ones integers)))

     (assert (eq? 18 (list-ref integers 17))))
  the-global-environment)

;; Answer

;; To iter through the stream in chapter 3, we need to add delay
;; and force into the the stream construction function. And the
;; according value should be eval-ed when it is referenced.
;; However, this is not necessary for the lazy list. nothing extra
;; is needed. Alongside, the referenced value is eval-ed only when
;; it is really needed.
;;
;; For advantage, IRCC, something like GORM preload.
;;
;; var result_list []B
;; db.Table("Table_B").
;;   Preload("Table_A").
;;   Where("age > ?", 18).Find(&result_list);
