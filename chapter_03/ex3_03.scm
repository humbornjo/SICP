;; Answer

(define (make-account balance pass)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (if (eq? p pass)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "Unknown request: MAKE-ACCOUNT" m)))
      (error "Incorrect password")))
  dispatch)

(define acc (make-account 100 'secret-password))

(assert (eq? 60 ((acc 'secret-password 'withdraw) 40)))
