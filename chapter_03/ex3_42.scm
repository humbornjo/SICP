;; Answer

; It is safe and it is just like
;
; original:
;   if mutex.lock:
;     deposit/withdraw
;
; Ben Bitdiddl:
;   ; pre-defined protected_deposit/withdraw = if mutex.lock: deposit/withdraw
;   protected_deposit/withdraw
; where mutex is used to control the concurrency
