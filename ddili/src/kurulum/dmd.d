Ddoc

$(H4 $(CH4 dmd'nin) otomatik olarak kurulması)

$(P
$(C dmd)'yi kurmanın en kolay yolu, indirme sayfasındaki seçeneklerden $(I 1-click install) yazanlardan birisine tıklamaktır:
)

$(P
$(LINK http://www.dlang.org/download.html)
)

$(P
Orada hem Windows'un hem de Linux'un kurulum dosyaları bulunuyor.
)

$(H4 $(CH4 dmd)'nin $(C .zip) dosyasından kurulması)

$(P
Herhangi bir nedenle $(C .zip) dosyasını indirmeniz gerekiyorsa şu adımları izleyebilirsiniz:
)

$(STEPS

$(LI Derleyiciyi dlang.org'dan indirin:

$(P
     $(LINK http://www.dlang.org/download.html)
)
)

$(LI
İndirdiğiniz zip dosyasını herhangi bir klasöre açın [unzip]. Örneğin $(CODE ~/dmd)
)

$(LI

Derleyici programlarının rahatça bulunabilmeleri için $(CODE ~/dmd/linux/bin32) klasörünü $(CODE PATH)'e ekleyin. $(CODE dmd)'yi $(CODE ~/dmd) klasörüne açtığınızı varsayarsak, bunu geçici olarak etkinleştirmek için şu komutu kullanabilirsiniz:

$(SHELL
export PATH=$PATH:~/dmd/linux/bin32
)

$(P
Eğer dmd'yi her zaman için bir konsoldan başlatmak yeterli olacaksa ve konsol olarak bash kullanıyorsanız, o satırı $(CODE ~/.bashrc) dosyanıza ekleyin. Artık açtığınız konsollarda yalnızca $(CODE dmd) yazmak derleyicinin başlatılması için yeterli olacaktır. Bir sonraki adıma geçebilirsiniz.
)

$(P
Eğer PATH'i menülerden başlatılan programlar için bile etkin hale getirmek istiyorsanız, $(CODE ~/.profile) dosyasına PATH'e klasörün tam yolunu ekleyen satırı yazın. Örneğin dmd'nin $(CODE /home/kullanici_ismi/dmd) gibi bir klasöre kurulduğunu varsayarsak, $(CODE ~/.profile) dosyanızın sonuna şöyle bir satır ekleyin:
)

$(SHELL
PATH=$PATH:/home/kullanici_ismi/dmd/linux/bin32
)

$(P
Bu ayarın etkinleşmesi için oturumu kapatıp tekrar açmanız gerekebilir.
)
)

$(P
$(CODE dmd)'nin bu noktada D programlarını derleyebilir duruma gelmiş olması gerekiyor.
)

$(P
$(I Not: $(C dmd)'nin 64 bitlik olanını kullanmak için klasör yolunda $(C bin32) yerine $(C bin64) yazmanız gerekir. Bunun üretilen programların 32 bit veya 64 bit olması ile ilgisi yoktur; yalnızca $(C dmd)'nin kendisini etkiler.)
)

$(LI
Derleyiciyle gelen örnek programların bulunduğu $(CODE ~/dmd/samples/d) klasörüne geçin ve örnekleri derlemeyi deneyin:

$(SHELL
dmd hello.d
)

Eğer başarıyla derlenirse aynı klasör içinde $(CODE hello) isminde yeni bir program oluşacaktır. Çalıştırmak için:

$(SHELL
./hello
)

Herşey yolunda gittiyse ekranda şöyle bir çıktı olması gerekir:

$(SHELL
hello world
args.length = 1
args[0] = './hello'
)

Programı değişik sayıda argümanla çalıştırmayı da deneyebilirsiniz:

$(SHELL
./hello 42 "bir arada"
)
)
)
Macros:
        SUBTITLE=dmd Kurulumu

        DESCRIPTION=Digital Mars firmasının D derleyicisi dmd'nin Linux'ta ve Windows'da kurulması

        KEYWORDS=d programlama dili derleyici dmd indir kur
