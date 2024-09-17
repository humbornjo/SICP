(define nil '())
(define false #f)
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
(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))
    (define (lookup key-1 key-2)
      (let ((subtable
              (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record
                  (assoc key-2 (cdr subtable))))
            (if record (cdr record) false))
          false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable
              (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record
                  (assoc key-2 (cdr subtable))))
            (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
          (set-cdr! local-table
                    (cons (list key-1 (cons key-2 value))
                          (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation: TABLE" m))))
    dispatch))

(newline)
(newline)

; put and get 
(define operation-table (make-table (lambda (x y) (< (abs (- x y)) 0.1)))) 
(define get (operation-table 'lookup-proc)) 
(define put (operation-table 'insert-proc!)) 

; test 
(put 1.0 1.0 'hello) 
(display "result of ex 3.24: " )
(display (get 1.01 1.01))

; Propagation of Constraint
(define (adder a1 a2 sum)
(define (process-new-value)
(cond ((and (has-value? a1) (has-value? a2))
(set-value! sum
(+ (get-value a1) (get-value a2))
me))
((and (has-value? a1) (has-value? sum))
(set-value! a2
(- (get-value sum) (get-value a1))
me))
((and (has-value? a2) (has-value? sum))
(set-value! a1
(- (get-value sum) (get-value a2))
me))))
(define (process-forget-value)
(forget-value! sum me)
(forget-value! a1 me)
(forget-value! a2 me)
(process-new-value))
(define (me request)
(cond ((eq? request 'I-have-a-value) (process-new-value))
((eq? request 'I-lost-my-value) (process-forget-value))
(else (error "Unknown request: ADDER" request))))
(connect a1 me)
(connect a2 me)
(connect sum me)
me)
(define (multiplier m1 m2 product)
(define (process-new-value)
(cond ((or (and (has-value? m1) (= (get-value m1) 0))
(and (has-value? m2) (= (get-value m2) 0)))
       (set-value! product 0 me))
((and (has-value? m1) (has-value? m2))
(set-value! product
(* (get-value m1) (get-value m2))
me))
((and (has-value? product) (has-value? m1))
(set-value! m2
(/ (get-value product)
(get-value m1))
me))
((and (has-value? product) (has-value? m2))
(set-value! m1
(/ (get-value product)
(get-value m2))
me))))
(define (process-forget-value)
(forget-value! product me)
(forget-value! m1 me)
(forget-value! m2 me)
(process-new-value))
(define (me request)
(cond ((eq? request 'I-have-a-value) (process-new-value))
((eq? request 'I-lost-my-value) (process-forget-value))
(else (error "Unknown request: MULTIPLIER"
request))))
(connect m1 me)
(connect m2 me)
(connect product me)
me)
(define (constant value connector)
(define (me request)
(error "Unknown request: CONSTANT" request))
(connect connector me)
(set-value! connector value me)
me)
(define (probe name connector)
(define (print-probe value)
(newline) (display "Probe: ") (display name)
(display " = ") (display value))
(define (process-new-value)
(print-probe (get-value connector)))
(define (process-forget-value) (print-probe "?"))
(define (me request)
(cond ((eq? request 'I-have-a-value) (process-new-value))
((eq? request 'I-lost-my-value) (process-forget-value))
(else (error "Unknown request: PROBE" request))))
(connect connector me)
me)
(define (inform-about-value constraint)
(constraint 'I-have-a-value))
(define (inform-about-no-value constraint)
(constraint 'I-lost-my-value))
(define (make-connector)
  (let ((value false) (informant false) (constraints '()))
    (define (set-my-value newval setter)
      (cond ((not (has-value? me))
             (set! value newval)
             (set! informant setter)
             (for-each-except setter
                              inform-about-value
                              constraints))
            ((not (= value newval))
             (error "Contradiction" (list value newval)))
            (else 'ignored)))
    (define (forget-my-value retractor)
      (if (eq? retractor informant)
        (begin (set! informant false)
               (for-each-except retractor
                                inform-about-no-value
                                constraints))
        'ignored))
    (define (connect new-constraint)
      (if (not (memq new-constraint constraints))
        (set! constraints
          (cons new-constraint constraints)))
      (if (has-value? me)
        (inform-about-value new-constraint))
      'done)
    (define (me request)
      (cond ((eq? request 'has-value?)
             (if informant true false))
            ((eq? request 'value) value)
            ((eq? request 'set-value!) set-my-value)
            ((eq? request 'forget) forget-my-value)
            ((eq? request 'connect) connect)
            (else (error "Unknown operation: CONNECTOR"
                         request))))
    me))
(define (for-each-except exception procedure list)
  (define (loop items)
    (cond ((null? items) 'done)
          ((eq? (car items) exception) (loop (cdr items)))
          (else (procedure (car items))
                (loop (cdr items)))))
  (loop list))
(define (has-value? connector)
  (connector 'has-value?))
(define (get-value connector)
  (connector 'value))
(define (set-value! connector new-value informant)
  ((connector 'set-value!) new-value informant))
(define (forget-value! connector retractor)
  ((connector 'forget) retractor))
(define (connect connector new-constraint)
  ((connector 'connect) new-constraint))

; exercise 3.33
(newline)
(newline)

(define (averager a b c)
  (let ((res (make-connector))
        (par (make-connector)))
    (adder a b res)
    (multiplier c par res)
    (constant 2 par)))

; exercise 3.35
(define (squarer a b)
  (define (process-new-value)
    (if (has-value? b)
      (if (< (get-value b) 0)
        (error "square less than 0: SQUARER" (get-value b))
        (set-value! a (sqrt (get-value b)) me))
      (if (has-value? a) 
        (set-value! b (square (get-value a)) me))))
  (define (process-forget-value) 
    (forget-value! a me)
    (process-new-value))
  (define (me request) 
    (cond ((eq? request 'I-have-a-value) (process-new-value))
          ((eq? request 'I-lost-my-value) (process-forget-value))
          (else (error "Unknown request: SQUARER"
                       request))))
  (connect a me)
  (connect b me)
  me)

; exercise 3.37
(define true #t)
(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))
(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))
(define (c/ x y)
  (let ((z (make-connector)))
    (multiplier y z x)
    z))
(define (cv x)
  (let ((z (make-connector)))
    (constant x z)
    z))
(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))
(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

