;; Answer

; When you call serialized-exchange, both account need to be
; locked until finish but if you lock each procedure at the very
; beginning, it will be:
;
;  try mutex1.lock
;    try mutex2.lock
;      exchange:
;        ; withdraw and deposit in exchange
;        protected_withdraw <- try mutex1.lock
;        protected_deposit  <- try mutex2.lock
