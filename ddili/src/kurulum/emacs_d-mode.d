Ddoc

$(H5 Emacs'e d-mode düzenleme modunu eklemek)

$(P
 Kurmak için:
)

$(STEPS

$(LI $(P $(CODE d-mode.el) dosyasını şu adresten indirin:
)

$(P $(LINK https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/blob/master/d-mode.el))

)

$(LI $(P
İndirdiğiniz dosyayı Emacs'in lisp dosyaları için baktığı bir klasöre kopyalayın (root yetkisi gerekebilir!). Uygun klasörlerin listesini şu komutla görebilirsiniz:)

$(P $(CODE
C-h v load-path
))

$(P
Benim sistemimdeki kopyalama komutu şöyleydi:
)

$(SHELL
cp d-mode.el /usr/share/emacs/21.4/site-lisp
)
)

$(LI
$(P
Aslında $(CODE d-mode.el)'yi derlemek hız kazancı sağlayacaktır ama benim ortamımda da şu bilinen hatayı verdi:
)

$(P
$(CODE error: "`c-lang-defconst' must be used in a file")
)

$(P
Eğer sizin ortamınızda çalışırsa Emacs'in içindeyken $(CODE d-mode.el)'yi derleyin:
)

$(P
$(CODE M-x byte-compile-file)
)

$(P
ve oluşan $(CODE d-mode.elc) dosyasını da site-lisp klasörüne kopyalayın.
)

$(SHELL
cp d-mode.elc /usr/share/emacs/21.4/site-lisp
)

)

$(LI $(P
 $(CODE .emacs) dosyanıza şu satırları ekleyin:)

$(P
$(SHELL
(add-to-list 'auto-mode-alist '("\\.d\\'" . d-mode))
(autoload 'd-mode "d-mode" "Major mode for D programs" t)
)
)
)

$(P
Artık uzantısı $(CODE .d) olan dosyalar d-mode'da açılacaklardır. Emacs içindeyken d-mode'u kendiniz de şöyle başlatabilirsiniz:
)

$(P
$(CODE M-x d-mode)
)
)

Macros:
        SUBTITLE=d-mode Kurulumu

        DESCRIPTION=Emacs'e d-mode modunun eklenmesi

        KEYWORDS=d programlama dili emacs d-mode indir kur
