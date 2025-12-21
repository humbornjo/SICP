;; Answer

; http://community.schemewiki.org/?sicp-ex-2.38

(load "./eval_init_seq.scm")

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
      result
      (iter (op result (car rest))
            (cdr rest))))
  (iter initial sequence))

(define (fold-right op initial sequence)
  (accumulate op initial sequence))
