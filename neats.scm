#!/usr/bin/env -S guile -e '(lambda _ (with-output-to-file "neats.kbd" main))' -s
!#

;; SPDX-FileCopyrightText: 2024 antlers <antlers@illucid.net>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (ice-9 format)
             (ice-9 regex)
             (ice-9 match)
             (ice-9 textual-ports))

(define sequences
  (string-join
    (let ((i -1))
      (map (match-lambda
             ((binding output)
              (set! i (1+ i))
              (format #f "(defseq seq-~a (~a))~%(deffakekeys seq-~a (macro ~a)))"
                i binding
                i (string-join
                    (let* ((lst (map string (string->list output)))
                           (->char (lambda (c)
                                     (cond ((equal? c " ") "spc")
                                           (else c)))))
                      (cons* (->char (car lst))
                             "(unmod"
                             (map ->char (cdr lst))))
                    " "))))
           '(;; ("spc r t" " pr")
             ("h nop1" "hn")
             ("n nop1" "nf")
             ("c nop1" "ck")
             ("i nop1" "ing")
             ("a nop1" "and")
             ("i nop0" "ion")
             ("a nop0" "ao")
             ("o nop0" "oa")
             ("e nop0" "eu")
             ("u nop0" "ue")
             ("n nop0" "nion")
             ("b nop0" "bs")
             ("w nop0" "way")
             ("g nop0" "gy")
             ("y nop0" "yp")
             ("d nop0" "dy")
             ("p nop0" "py")
             ("c nop0" "cy")
             ("r nop0" "rl")
             ("l nop0" "lk")
             ("k nop0" "ks")
             ("t nop0" "tment")
             ("m nop0" "ment")
             ("x nop0" "xes")
             ("s nop0" "sk")
             ("b nop1" "bb")
             ("d nop1" "dd")
             ("e nop1" "ee")
             ("f nop1" "ff")
             ("g nop1" "gg")
             ("j nop1" "jj")
             ("k nop1" "kk")
             ("l nop1" "ll")
             ("m nop1" "mm")
             ("o nop1" "oo")
             ("p nop1" "pp")
             ("q nop1" "qq")
             ("r nop1" "rr")
             ("s nop1" "ss")
             ("t nop1" "tt")
             ("u nop1" "uu")
             ("v nop1" "vv")
             ("w nop1" "ww")
             ("x nop1" "xx")
             ("y nop1" "yy")
             ("z nop1" "zz")
             )))
    "\n"))

(define-syntax-rule (defchords ((letters ...) b1 b2 b3) ...)
  (let* ((->string
           (lambda (s)
             (if (string? s)
                 s
                 (symbol->string s))))
         (->chord
           (lambda (l)
             (string-join (map ->string l) " " 'infix))))
    (format #f "~:@{~:@{  (~a) ~a~%~}~}"
      (list
        (list (->chord '(letters ...)) 'b1)
        ; (list (->chord '(letters ... TB1)) 'b2)
        ; (list (->chord '(letters ... TB2)) 'b3)
        )
      ...)))

(define chords
  (defchords
    ;(S T R I A E N O SPC ‡) x S-x)
    ((        A            ) a S-a "")
    ((    R           SPC  ) b S-b "")
    ((    R               ‡) b S-b "")
    ((            N O      ) c S-c "")
    ((S     I              ) d S-d "")
    ((          E          ) e S-e "")
    ((        A   N        ) f S-f "")
    ((          E   O      ) g S-g "")
    ((S   R                ) h S-h "")
    ((      I              ) i S-i "")
    ((          E N O      ) j S-j "")
    ((  T     A            ) k S-k "")
    ((          E N        ) l S-l "")
    ((        A E          ) m S-m "")
    ((            N        ) n S-n "")
    ((              O      ) o S-o "")
    ((    R I              ) p S-p "")
    ((    R         O      ) q S-q "")
    ((    R                ) r S-r "")
    ((S                    ) s S-s "")
    ((  T                  ) t S-t "")
    ((S T                  ) u S-u "")
    ((        A       SPC  ) v S-v "")
    ((        A           ‡) v S-v "")
    ((            N   SPC  ) w S-w "")
    ((            N       ‡) w S-w "")
    ((    R   A            ) x S-x "")
    ((        A     O      ) y S-y "")
    ((  T R   A            ) z S-z "")
    ;; ((S           N        ) . S-. "")
    ;; ((  T   I              ) , S-, "")
    ;; ((S             O      ) ; S-; "")
    ((                    ‡) nop1 S-nop1 "")
    ((  T R                ) nop0 S-nop0 "")
    ((                SPC  ) spc S-spc "")
    ((S T             SPC  ) bspc S-bspc "")
    ((S T                 ‡) bspc S-bspc "")
    ((        A E     SPC  ) ret S-ret "")
    ((        A E         ‡) ret S-ret "")
    ((  T R           SPC  ) tab S-tab "")
    ((  T R               ‡) tab S-tab "")))

(define (make-subst pattern item)
  (lambda (str)
    (call-with-output-string
      (lambda (port)
        (regexp-substitute port
          (string-match pattern str)
          'pre (format #f "~a" item) 'post)))))

(define (main)
  (display ((compose (make-subst "\\{\\{SEQUENCES\\}\\}" sequences)
                     (make-subst "\\{\\{CHORDS\\}\\}" chords))
            (call-with-input-file "neats.kbd.in" get-string-all))))
