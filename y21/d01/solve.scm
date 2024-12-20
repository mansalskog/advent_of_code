(define (read-lines)
  (define (f ls)
    (let ((l (read-line)))
      (if (eof-object? l)
	  (reverse ls)
	  (f (cons l ls)))))
  (f '()))

(define lines (with-input-from-file "input.txt" read-lines))
(define xs (map string->number lines))
(write (apply + (map (lambda (x) (if x 1 0))
		     (map < (reverse (cdr (reverse xs))) (cdr xs)))))
