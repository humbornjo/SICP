(define nil '())
; exercise 3.12
(define x (list 'a 'b))
(define y (list 'c 'd))

(define z (append x y))
(display z)
(newline)
(display (cdr x))

(define (append! x y)
(set-cdr! (last-pair x) y)
x)
(define (last-pair x)
(if (null? (cdr x)) x (last-pair (cdr x))))
(newline)
(define w (append! x y))
(display w)
(newline)
(display (cdr x))

; exercise 3.13
(define (make-cycle x)
(set-cdr! (last-pair x) x)
x)
(define z (make-cycle (list 'a 'b 'c)))
;; [a, *]->[b, *]->[c, *]->[a, *]-> ...
;; (display (last-pair z)) ; it hangs

; exercise 3.14
(define (mystery x)
  (define (loop x y)
    (if (null? x)
      y
      (let ((temp (cdr x)))
        (set-cdr! x y)
        (loop temp x))))
  (loop x '()))
;; it reverse x

; Sharing and identity

; exercise 3.16
;; the pair can be shared

; exercise 3.17
(define (count-pairs x)
  (define vis '())
  (define (inner xx)
    (if (not (pair? xx))
      0
      (if (memq xx vis)
        0
        (begin
          (set! vis (append vis (list xx)))
          (+ (inner (car xx))
             (inner (cdr xx))
             1)))))
  (inner x))


(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(newline)
(display (count-pairs z1))
(newline)
(display (count-pairs z2))

; exercise 3.18
(define (python x)
  (define vis nil)
  (define (inner xx)
    (if (null? xx) #f
      (if (memq xx vis)
        #t
        (begin 
          (set! vis (cons xx vis))
          (inner (cdr xx))))))
  (inner x))

(newline)
(display (python z))


; exercise 3.19
(define (python-constant x)
  (define slow x)
  (define fast (cdr x))
  (define (inner s f)
    (if (or (null? s) (null? f) (null? (cdr f)))
      #f
      (if (eq? s f)
        #t
        (inner (cdr s) (cddr f)))))
  (inner slow fast))

(newline)
(display (python-constant z))
(newline)
(display (python-constant (list 'a 'b)))

;Mutation is just assignment
; exercise 3.20
;; http://community.schemewiki.org/?sicp-ex-3.20

;Representing eues
(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr! queue item)
  (set-cdr! queue item))
(define (empty-queue? queue)
  (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))
(define (front-queue queue)
  (if (empty-queue? queue)
    (error "FRONT called with an empty queue" queue)
    (car (front-ptr queue))))
(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
            (set-cdr! (rear-ptr queue) new-pair)
            (set-rear-ptr! queue new-pair)
            queue))))
(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else (set-front-ptr! queue (cdr (front-ptr queue)))
              queue)))

; exercise 3.21
(newline)
(define (print-queue q)
  (display (car q)))
(define q1 (make-queue))
(insert-queue! q1 'a)
(insert-queue! q1 'b)
(insert-queue! q1 'c)
(print-queue q1)

; exercise 3.22
(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (insert-queue! item)
      (let ((new-pair (cons item '())))
        (cond ((null? front-ptr)
               (set! front-ptr new-pair)
               (set! rear-ptr new-pair)
               (cons front-ptr rear-ptr))
              (else
                (set-cdr! rear-ptr new-pair)
                (set! rear-ptr new-pair)
                (cons front-ptr rear-ptr)))))
    (define (delete-queue!)
      (cond ((null? front-ptr)
             (error "DELETE! called with an empty queue" (cons front-ptr rear-ptr)))
            (else (set! front-ptr (cdr front-ptr))
                  (cons front-ptr rear-ptr))))
    (define (dispatch m) 
      (cond 
        ((eq? m 'front-ptr) front-ptr)
        ((eq? m 'rear-ptr) rear-ptr)
        ((eq? m 'empty?) (null? front-ptr))
        ((eq? m 'front-queue) 
         (if (null? front-ptr)
           (error "FRONT called with an empty queue" (cons front-ptr rear-ptr))
           (car front-ptr)))
        ((eq? m 'insert) insert-queue!)
        ((eq? m 'delete) delete-queue!)))
    dispatch))

; exercise 3.24



