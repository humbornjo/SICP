(define (type exp)
  (if (pair? exp)
    (car exp)
    (error "Unknown expression TYPE" exp)))
(define (contents exp)
  (if (pair? exp)
    (cdr exp)
    (error "Unknown expression CONTENTS" exp)))

(define (assertion-to-be-added? exp)
  (eq? (type exp) 'assert!))
(define (add-assertion-body exp) (car (contents exp)))

(define (empty-conjunction? exps) (null? exps))
(define (first-conjunct exps) (car exps))
(define (rest-conjuncts exps) (cdr exps))
(define (empty-disjunction? exps) (null? exps))
(define (first-disjunct exps) (car exps))
(define (rest-disjuncts exps) (cdr exps))
(define (negated-query exps) (car exps))
(define (predicate exps) (car exps))
(define (args exps) (cdr exps))

(define (tagged-list? exp tag) (if (pair? exp) (eq? (car exp) tag) false))
(define (rule? statement)
  (tagged-list? statement 'rule))
(define (conclusion rule) (cadr rule))
(define (rule-body rule)
  (if (null? (cddr rule)) '(always-true) (caddr rule)))

(define (query-syntax-process exp)
  (map-over-symbols expand-question-mark exp))
(define (map-over-symbols proc exp)
  (cond ((pair? exp)
         (cons (map-over-symbols proc (car exp))
               (map-over-symbols proc (cdr exp))))
        ((symbol? exp) (proc exp))
        (else exp)))
(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
      (list '?
            (string->symbol
              (substring chars 1 (string-length chars))))
      symbol)))

(define (var? exp) (tagged-list? exp '?))
(define (constant-symbol? exp) (symbol? exp))

(define rule-counter 0)
(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)
(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))

(define (contract-question-mark variable)
  (string->symbol
    (string-append "?"
                   (if (number? (cadr variable))
                     (string-append (symbol->string (caddr variable))
                                    "-"
                                    (number->string (cadr variable)))
                     (symbol->string (cadr variable))))))

(define (make-binding variable value) (cons variable value))
(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))
(define (binding-in-frame variable frame) (assoc variable frame))
(define (extend variable value frame) (cons (make-binding variable value) frame))


(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))


; Simple database from book p600

(add-rule-or-assertion! '(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10)))
(add-rule-or-assertion! '(job (Bitdiddle Ben) (computer wizard)))
(add-rule-or-assertion! '(salary (Bitdiddle Ben) 60000))

(add-rule-or-assertion! '(address (Hacker Alyssa P) (Cambridge (Mass Ave) 78)))
(add-rule-or-assertion! '(job (Hacker Alyssa P) (computer programmer)))
(add-rule-or-assertion! '(salary (Hacker Alyssa P) 40000))
(add-rule-or-assertion! '(supervisor (Hacker Alyssa P) (Bitdiddle Ben)))

(add-rule-or-assertion! '(address (Fect Cy D) (Cambridge (Ames Street) 3)))
(add-rule-or-assertion! '(job (Fect Cy D) (computer programmer)))
(add-rule-or-assertion! '(salary (Fect Cy D) 35000))
(add-rule-or-assertion! '(supervisor (Fect Cy D) (Bitdiddle Ben)))

(add-rule-or-assertion! '(address (Tweakit Lem E) (Boston (Bay State Road) 22)))
(add-rule-or-assertion! '(job (Tweakit Lem E) (computer technician)))
(add-rule-or-assertion! '(salary (Tweakit Lem E) 25000))
(add-rule-or-assertion! '(supervisor (Tweakit Lem E) (Bitdiddle Ben)))

(add-rule-or-assertion! '(address (Reasoner Louis) (Slumerville (Pine Tree Road) 80)))
(add-rule-or-assertion! '(job (Reasoner Louis) (computer programmer trainee)))
(add-rule-or-assertion! '(salary (Reasoner Louis) 30000))
(add-rule-or-assertion! '(supervisor (Reasoner Louis) (Hacker Alyssa P)))

(add-rule-or-assertion! '(supervisor (Bitdiddle Ben) (Warbucks Oliver)))
(add-rule-or-assertion! '(address (Warbucks Oliver) (Swellesley (Top Heap Road))))
(add-rule-or-assertion! '(job (Warbucks Oliver) (administration big wheel)))
(add-rule-or-assertion! '(salary (Warbucks Oliver) 150000))

(add-rule-or-assertion! '(address (Scrooge Eben) (Weston (Shady Lane) 10)))
(add-rule-or-assertion! '(job (Scrooge Eben) (accounting chief accountant)))
(add-rule-or-assertion! '(salary (Scrooge Eben) 75000))
(add-rule-or-assertion! '(supervisor (Scrooge Eben) (Warbucks Oliver)))

(add-rule-or-assertion! '(address (Cratchet Robert) (Allston (N Harvard Street) 16)))
(add-rule-or-assertion! '(job (Cratchet Robert) (accounting scrivener)))
(add-rule-or-assertion! '(salary (Cratchet Robert) 18000))
(add-rule-or-assertion! '(supervisor (Cratchet Robert) (Scrooge Eben)))

(add-rule-or-assertion! '(address (Aull DeWitt) (Slumerville (Onion Square) 5)))
(add-rule-or-assertion! '(job (Aull DeWitt) (administration secretary)))
(add-rule-or-assertion! '(salary (Aull DeWitt) 25000))
(add-rule-or-assertion! '(supervisor (Aull DeWitt) (Warbucks Oliver)))

(add-rule-or-assertion! '(can-do-job (computer wizard) (computer programmer)))
(add-rule-or-assertion! '(can-do-job (computer wizard) (computer technician)))
(add-rule-or-assertion! '(can-do-job (computer programmer) (computer programmer trainee)))
(add-rule-or-assertion! '(can-do-job (administration secretary) (administration big wheel)))

(add-rule-or-assertion! (query-syntax-process '(rule (same ?x ?x))))
