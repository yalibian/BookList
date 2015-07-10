; Exercise 2.79
; equ?
;

#lang racket

(define (add x y)
  (apply-generic 'add x y))

(define (sub x y)
  (apply-generic 'sub x y))

(define (mul x y)
  (apply-generic 'mul x y))

(define (div x y)
  (apply-generic 'div x y))

(define (equ? x y)
  (apply-generic 'equ? x y))


; attach-tag
(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum))
  (cadr datum)
  (error "Bad tagged datum -- TYPE-TAG" datum))

; scheme-number
(define (install-scheme-number-package)

  (define (tag x)
    (attach-tag 'scheme-number x))

  (put 'add '(scheme-number scheme-number)
       (lambda (x y)
         (tag (+ x y))))

  (put 'sub '(scheme-number scheme-number)
       (lambda (x y)
         (tag (- x y))))

  (put 'mul '(scheme-number scheme-number)
       (lambda (x y)
         (tag (* x y))))

  (put 'div '(scheme-number scheme-number)
       (lambda (x y)
         (tag (/ x y))))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y)
         (if (= x y)
             #t
             #f)))

  (put 'make 'scheme-number (lambda (x) (tag x)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))


; rational-number
(define (install-rational-packet)
  ;; internal procedures
  (define (number x)
    (car x))
  (define (denom x)
    (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x)
                    (denom y)))
              (* (denom x)
                 (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))

  (define (equ? x y)
    (if (and (= (numer x) (numer y)) (= (denom x) (denom y)))
        #t
        #f))

  ;; interface to rest of the system
  (define (tag x)
    (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y)
         (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y)
         (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y)
         (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y)
         (tag (div-rat x y))))
  (put 'equ? '(retional retional) equ?)
  (put 'make 'rational
       (lambda (n d)
         (tag (make-rat n d))))
  'done)

;complex-number
(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-ral-img 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (equ? z1 z2)
    (if (and (= (real-part z1) (real-part z2)) (= (imag-part z1) (imag-part z2)))
        #t
        #f))
  ;; interface to reat of the system
  (define (tag z)
    (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2)
         (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2)
         (tag (sub-complex z1 z2))))

  (put 'mul '(complex complex)
       (lambda (z1 z2)
         (mul-complex z1 z2)))
  (put 'div '(complex complex)
       (lambda (z1 z2)
         (div-complex z1 z2)))
  (put 'equ? '(complex complex) equ?)
  (put 'make-from-real-imag 'complex
       (lambda (x y)
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (x y)
         (tag (make-from-mag-ang x y))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-complex-from-real-imag) x y))
(define (make-complex-from-mag-ang x y)
  ((get 'make-complex-from-mag-ang) x y))