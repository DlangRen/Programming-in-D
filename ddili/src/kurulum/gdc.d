Ddoc

$(H5 Linux'ta GNU'nun Derleyicisi $(CODE gdc)'nin Kurulması)

$(P $(RED $(B Not:) Bu yazı yazıldığı sırada gdc yalnızca D'nin birinci sürümünü (D1) desteklemektedir. D2 hem çok daha modern olanaklar içerdiği için, hem de D.ershane'de de D2 anlatıldığı için, ben gdc yerine dmd'yi kurmanızı öneririm.)
)

$(P Eğer kullandığınız Linux dağıtımı $(CODE gdc)'yi paket olarak veriyorsa, en kolayı paket yöneticisini kullanmaktır. $(CODE gdc)'nin paket isminin $(CODE gcc-gdc) olduğunu ve paket yöneticisi olarak $(CODE yum)'un kullanıldığını varsayarsak, şu komutu $(CODE root) olarak işletmeniz yeterli olabilir:
)

$(SHELL
yum install gcc-gdc
)

$(P
Örneğin eğer Ubuntu kullanıyorsanız, $(CODE gdc) pakedini şu adreste arayabilirsiniz:
)

$(P
$(LINK http://packages.ubuntu.com/)
)

$(P
Şimdiki CentOS 5 ortamımda öyle bir paket bulunmadığı için ben programı projenin sitesinden indirerek kurmaya karar verdim...
)

$(STEPS

$(LI Derleyiciyi SourceForge'dan indirin:
$(P
$(LINK http://sourceforge.net/project/showfiles.php?group_id=154306)
)

$(P
Bu yazıyı yazdığım sırada 0.24 sürümündeler. Seçenekler içinden kendi ortamınıza uyan $(CODE tar) dosyasını seçin. Örneğin $(CODE gdc-0.24-i686-linux-gnu-gcc-4.1.2.tar.bz2)...
)
)

$(LI

İndirdiğiniz $(CODE tar) dosyasını açın:

$(SHELL
tar jxvf gdc-0.24-i686-linux-gnu-gcc-4.1.2.tar.bz2
)

$(P
Derleyici dosyaları $(CODE gdc) isimli bir klasöre açılacaklardır.
)
)

$(LI
Program dosyalarının bulunduğu $(CODE gdc/bin) klasörünü $(CODE PATH)'e ekleyin. Örneğin dosyaların $(CODE ~/gdc) klasörüne açıldıklarını varsayarsak:

$(SHELL
export PATH=$PATH:~/gdc/bin
)

$(P
$(CODE gdc)'nin bu noktada D programlarını derleyebilir duruma gelmiş olması gerekir. Derleyicini bulunup çalıştırılabildiğini denemek için
)

$(SHELL
gdc --version
)

yazabilirsiniz. Çıkışa derleyici sürümü ile ilgili bilgilerin yazılmış olması gerekir.
)

$(LI
 Derleyiciyi denemek için bir "merhaba dünya" programı yazın ve $(CODE merhaba.d) ismiyle kaydedin:

---
import std.stdio;
void main()
{
  printf("merhaba dünya\n");
}
---
)

$(LI
Programı derleyin
$(SHELL gdc merhaba.d -o merhaba
)

$(P Eğer çalışırsa aynı klasör içinde $(CODE merhaba) isminde bir program oluşacaktır. Çalıştırmayı deneyin:
)

$(SHELL ./merhaba)

$(P Ekrana şu çıktıyı vermesi gerekir:

$(SHELL
merhaba dünya
)
)
)

)

Macros:
        SUBTITLE=gdc Kurulumu

        DESCRIPTION=GNU'nun D derleyicisi gdc'nin kurulması

        KEYWORDS=d programlama dili derleyici gdc indir kur
