#!/usr/bin/env -S guile -e '(lambda _ (with-output-to-file "magic-strdy.kbd" main))' -s
!#

;; SPDX-FileCopyrightText: 2024 antlers <antlers@illucid.net>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (ice-9 format)
             (ice-9 regex)
             (ice-9 match)
             (ice-9 textual-ports))

(define alphabet
  '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n
    #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z #\. #\,))

(define aliases
  (string-join
    (let ((i -1))
      (map (lambda (letter)
             (format #f "  ~a (macro sldr ~a)" letter letter))
           alphabet))
    "\n"))

(define sequences
  (string-join
    (let ((i -1))
      (map (match-lambda
             ((binding output)
              (set! i (1+ i))
              (format #f "(defseq seq-~a (~a))~%(deffakekeys seq-~a (macro ~a)))"
                i binding
                i (string-join
                    (let ((lst (map string (string->list output))))
                      (cons* (car lst)
                             "(unmod"
                             (cdr lst)))
                    " "))))
           '(("a nop0" "ao")
             ("b nop0" "be")
             ("c nop0" "cy")
             ("d nop0" "dy")
             ("e nop0" "eu")
             ("g nop0" "gy")
             ("i nop0" "ion")
             ("l nop0" "lk")
             ("m nop0" "ment")
             ("n nop0" "nion")
             ("o nop0" "oa")
             ("p nop0" "py")
             ("q nop0" "quen")
             ("r nop0" "rl")
             ("s nop0" "sk")
             ("t nop0" "tment")
             ("u nop0" "ue")
             ("y nop0" "yp")
             (". nop0" ".o")
             )))
    "\n"))

(define (make-subst pattern item)
  (lambda (str)
    (call-with-output-string
      (lambda (port)
        (regexp-substitute port
          (string-match pattern str)
          'pre (format #f "~a" item) 'post)))))

(define (main)
  (display ((compose (make-subst "\\{\\{SEQUENCES\\}\\}" sequences)
                     (make-subst "\\{\\{ALIASES\\}\\}" aliases))
            (call-with-input-file "magic-strdy.kbd.in" get-string-all))))