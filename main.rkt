#lang racket

;; -----------------------------
;; Helpers
;; -----------------------------

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

;; -----------------------------
;; Expression Evaluator
;; returns: (list value remaining-chars)
;; -----------------------------

(define (eval-expr chars history)
  (define cleaned (skip-spaces chars))

  (cond
    [(empty? cleaned)
     (error "empty expression")]

    ;; number
    [(char-numeric? (first cleaned))
     (parse-number cleaned)]

    [else
     (error "invalid expression")]))

;; -----------------------------
;; Top-level evaluation
;; -----------------------------

(define (evaluate-line input history)
  (define result (eval-expr (string->list input) history))
  (define value (first result))
  (define remaining (skip-spaces (second result)))

  (if (empty? remaining)
      value
      (error "extra text after expression")))

;; -----------------------------
;; REPL loop
;; -----------------------------

(define (eval-loop history)
  (display "> ")
  (define input (read-line))

  (cond
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