(define (read-lines lines)
  (let ((line (read-line)))
    (if (eof-object? line)
	(reverse lines)
	(read-lines (cons line lines)))))

(define (starts-with? p s)
  (let ((l (string-length p)))
    (and (<= l (string-length s))
	 (substring=? p 0 l s 0 l))))

(define (process lines h d a)
  (if (null? lines)
      (* h d)
      (let* ((l (car lines))
	     (ls (cdr lines))
	     (x (string->number
		 (string-tail l (+ 1 (string-find-next-char l #\ ))))))
	(cond ((starts-with? "forward" l)
	       (process ls (+ h x) (+ d (* a x)) a))
	      ((starts-with? "down" l)
	       (process ls h d (+ a x)))
	      ((starts-with? "up" l)
	       (process ls h d (- a x)))))))

(with-input-from-file "input.txt"
  (lambda ()
    (let ((lines (read-lines '())))
      (display (process lines 0 0 0)))))
