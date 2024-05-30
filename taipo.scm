#!/usr/bin/env -S guile -e '(lambda _ (with-output-to-file "taipo.kbd" main))' -s
!#

;; SPDX-FileCopyrightText: 2024 antlers <antlers@illucid.net>
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (ice-9 format)
             (ice-9 regex)
             (ice-9 match)
             (ice-9 textual-ports))

(define sequences
  (format #f
    "~:@{~:@{(defseq vfn-~a ~a)~%(defvirtualkeys vfn-~a ~a)~%~}~}"
    (map (lambda (i)
           (list i (if (> 10 i)
                       (list "nop1" i)
                       (list "nop1" 0 (- i 10)))
                 i (list "multi" (string-append "f" (number->string i)))))
         (iota 19 1))))

(define-syntax-rule (defchords ((letters ...) b1 b2 b3) ...)
  (let* ((->string
           (lambda (s)
             (if (string? s)
                 s
                 (symbol->string s))))
         (->chord
           (lambda (l)
             (string-join (map ->string l) " " 'infix))))
    (format #f "~:@{~:@{  (~a) (macro ~a 10 @taipo-hold)~%~}~}"
      (list
        (list (->chord '(letters ...)) 'b1)
        (list (->chord '(letters ... TB1)) 'b2)
        (list (->chord '(letters ... TB2)) 'b3))
      ...)))

(define chords
  (defchords
    ((        A      ) a S-a "S-,")
    ((R S            ) b S-b "@9")
    ((          O   E) c S-c "1")
    ((        A     E) d S-d "S-2")
    ((              E) e S-e "S-9")
    ((  S   I        ) f S-f "@6")
    ((R     I        ) g S-g "S-3")
    ((            T E) h S-h "@0")
    ((      I        ) i S-i "S-0")
    ((    N   A      ) j S-j "=")
    ((      I   O    ) k S-k "+")
    ((        A O    ) l S-l "@4")
    ((R             E) m S-m "S-4")
    ((    N          ) n S-n "S-[")
    ((          O    ) o S-o "{")
    ((  S N          ) p S-p "@7")
    ((        A   T  ) q S-q "@3")
    ((R              ) r S-r "S-.")
    ((  S            ) s S-s "S-]")
    ((            T  ) t S-t "[")
    ((          O T  ) u S-u "@2")
    ((  S           E) v S-v "S-8")
    ((      I A      ) w S-w "S-7")
    ((R           T  ) x S-x "S-6")
    ((    N I        ) y S-y "@5")
    ((R   N          ) z S-z "@8")

    ((  S         T  ) "/"   "\\"  "S-\\")
    ((    N     O    ) "-"   "S--" "S-5")
    ((R         O    ) "S-;" ";"   "nop9")
    ((      I     T  ) "S-/" "S-1" "nop9")
    ((    N         E) ","   "."   "S-grv")
    ((  S     A      ) "'"   "S-'" "grv")

    ((  S N I        ) "tab" "del" "nop1")
    ((          O T E) "ret" "esc" "esc") ; XXX: altgr?

    ;; ((R       A      ) "(on-press tap-virtualkey taipo-lmet)" "right" "pgup")
    ;; ((      I       E) "(on-press tap-virtualkey taipo-lsft)" "left"  "pgdn")
    ;; ((  S       O    ) "(on-press tap-virtualkey taipo-lalt)" "up"    "home")
    ;; ((    N       T  ) "(on-press tap-virtualkey taipo-lctl)" "down"  "end")
    ))

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
            (call-with-input-file "taipo.kbd.in" get-string-all))))
