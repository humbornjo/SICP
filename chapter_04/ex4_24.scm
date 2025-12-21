(import (chicken time))

;; main

(load "eval_init.scm")

(define cases
  '((begin (define (fib n)
             (cond ((= n 1) 1)
                   ((= n 2) 1)
                   (else (+ (fib (- n 1)) (fib (- n 2))))))
           (fib 22))
    (begin (define (loop n)
             (if (= n 0)
               'done
               (begin (+ 1 1)
                      (loop (- n 1)))))
           (loop 10000))
    (begin (define (factorial n)
        (if (= n 1) 1 (* (factorial (- n 1)) n)))
      (factorial 10000))
    ))


;; test the metacircular evaluator
(load "eval_impl_metacircular.scm")

(define stime_meta (cpu-time))
(define ret_meta (map
                   (lambda (case)
                     (eval case the-global-environment))
                   cases))
(define etime_meta (cpu-time))

(display "metacircular evaluator time: ")
(display (- etime_meta stime_meta))
(newline)



;; test the separate evaluator
(load "eval_impl_separate.scm")

(define stime_sep (cpu-time))
(define ret_sep (map
                  (lambda (case)
                    (eval case the-global-environment))
                  cases))
(define etime_sep (cpu-time))

(display "separate evaluator time: ")
(display (- etime_sep stime_sep))
(newline)

(assert (equal? ret_meta ret_sep))
