;; Answer

(load "./eval_init.scm")

(define (first-denomination x) (car x))

(define (except-first-denomination x) (cdr x))

(define (no-more? x) (null?  x))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                 (except-first-denomination
                   coin-values))
             (cc (- amount
                    (first-denomination
                      coin-values))
                 coin-values)))))

(define us-coins (list 50 25 10 5 1))

(assert (eq? 292 (cc 100 us-coins)))
