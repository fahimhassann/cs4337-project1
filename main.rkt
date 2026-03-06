#lang racket

;; Helper functions

(define (skip-spaces chars)
  (cond
    [(empty? chars) '()]
    [(char-whitespace? (first chars)) (skip-spaces (rest chars))]
    [else chars]))

(define (parse-number chars)
  (define cleaned (skip-spaces chars))

  (define (collect-number cs acc)
    (cond
      [(empty? cs) (list (list->string (reverse acc)) '())]
      [(char-numeric? (first cs))
       (collect-number (rest cs) (cons (first cs) acc))]
      [else
       (list (list->string (reverse acc)) cs)]))

  (if (and (not (empty? cleaned)) (char-numeric? (first cleaned)))
      (let* ([result (collect-number cleaned '())]
             [num-str (first result)]
             [remaining (second result)])
        (list (string->number num-str) remaining))
      (error "not a number")))

(define (history-ref history n)
  (define ordered-history (reverse history))
  (if (or (< n 1) (> n (length ordered-history)))
      (error "invalid history reference")
      (list-ref ordered-history (- n 1))))

;; Expression evaluator
;; returns: (list value remaining-chars)


(define (eval-expr chars history)
  (define cleaned (skip-spaces chars))

  (cond
    [(empty? cleaned)
     (error "empty expression")]

    ;; number
    [(char-numeric? (first cleaned))
     (parse-number cleaned)]

    ;; +
    [(char=? (first cleaned) #\+)
     (define left-result (eval-expr (rest cleaned) history))
     (define left-value (first left-result))
     (define after-left (second left-result))

     (define right-result (eval-expr after-left history))
     (define right-value (first right-result))
     (define after-right (second right-result))

     (list (+ left-value right-value) after-right)]

    ;; *
    [(char=? (first cleaned) #\*)
     (define left-result (eval-expr (rest cleaned) history))
     (define left-value (first left-result))
     (define after-left (second left-result))

     (define right-result (eval-expr after-left history))
     (define right-value (first right-result))
     (define after-right (second right-result))

     (list (* left-value right-value) after-right)]

    ;; /
    [(char=? (first cleaned) #\/)
     (define left-result (eval-expr (rest cleaned) history))
     (define left-value (first left-result))
     (define after-left (second left-result))

     (define right-result (eval-expr after-left history))
     (define right-value (first right-result))
     (define after-right (second right-result))

     (if (= right-value 0)
         (error "division by zero")
         (list (quotient left-value right-value) after-right))]

    ;; unary -
    [(char=? (first cleaned) #\-)
     (define inner-result (eval-expr (rest cleaned) history))
     (define inner-value (first inner-result))
     (define after-inner (second inner-result))

     (list (- inner-value) after-inner)]

    ;; $n history reference
    [(char=? (first cleaned) #\$)
     (define num-result (parse-number (rest cleaned)))
     (define index (first num-result))
     (define remaining (second num-result))
     (list (history-ref history index) remaining)]

    [else
     (error "invalid expression")]))

;; Evaluate whole line

(define (evaluate-line input history)
  (define result (eval-expr (string->list input) history))
  (define value (first result))
  (define remaining (skip-spaces (second result)))

  (if (empty? remaining)
      value
      (error "extra text after expression")))

;; Main evaluation loop

(define (eval-loop history)
  (display "> ")
  (define input (read-line))

  (cond
    [(eof-object? input)
     (void)]

    [(equal? input "quit")
     (displayln "Goodbye")]

    [else
     (with-handlers ([exn:fail?
                      (lambda (e)
                        (displayln "Error: Invalid Expression")
                        (eval-loop history))])
       (define value (evaluate-line input history))
       (define new-history (cons value history))
       (define id (length new-history))
       (display id)
       (display ": ")
       (displayln (real->double-flonum value))
       (eval-loop new-history))]))

(define (main)
  (eval-loop '()))

(main)