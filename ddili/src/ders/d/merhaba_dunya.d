Ddoc

$(DIV_CLASS page_one,

$(DERS_BOLUMU $(IX merhaba dünya) "Merhaba Dünya" Programı)

$(P
Her programlama dilinde gösterilen ilk program $(I merhaba dünya) programıdır. Doğal olarak son derece basit olması gereken bu program o dilde program yazabilmek için mutlaka bilinmesi gereken kavramları da içerdiği için önemlidir.
)

$(P
Şimdilik bu kavramları bir kenara bırakalım ve önce bu programı görelim:
)

---
import std.stdio;

void main() {
    writeln("Merhaba dünya!");
}
---

$(P
Yukarıdaki $(I kaynak koddan) çalışabilir program oluşturulabilmesi için kaynak kodun bir D derleyicisi tarafından derlenmesi gerekir.
)

$(H5 $(IX derleyici kurulumu) $(IX kurulum, derleyici) Derleyici kurulumu)

$(P
$(IX gdc) $(IX ldc) Bu bölüm yazıldığı sırada derleyici olarak üç seçenek bulunuyor: Digital Mars derleyicisi $(C dmd), GCC derleyicisi $(C gdc), ve LLVM derleme ortamını hedefleyen $(C ldc).
)

$(P
$(IX dmd) D programlama dilinin geliştirilmesi sırasındaki asıl derleyici $(C dmd) olmuştur. D'nin yeni olanakları ilk olarak hep bu derleyicide gerçekleştirilmişlerdir. Bu kitaptaki örnekler de hep $(C dmd) üzerinde denenmiş olduklarından sizin de onu kurmanızı öneririm. Başka derleyicileri gerekirse daha sonra kurabilirsiniz. Bu kitaptaki kod örnekleri dmd 2.071 ile derlendi.
)

$(P
$(C dmd)'nin en yeni sürümünü $(LINK2 http://www.dlang.org/download.html, Digital Mars'ın Download sayfasından) indirebilirsiniz. O sayfadaki sürümler arasından işletim sisteminize uyan ve sisteminizin 32 veya 64 bitlik olmasına bağlı olan en yeni sürümü seçin. D1 sürümlerini seçmeyin. Bu kitap D'nin D2 diye de anılan son sürümünü anlatır.
)

$(P
Derleyici kurulumu ortama bağlı olarak farklılık gösterse de bir kaç bağlantıya ve düğmeye tıklamak kadar kolaydır.
)

$(H5 $(IX kaynak dosya) Kaynak dosya)

$(P
Programcının D dili kurallarına göre yazdığı ve derleyiciye derlemesi için verdiği dosyaya $(I kaynak dosya) denir. D derlemeli bir dil olduğu için, kaynak dosyanın kendisi çalıştırılabilir bir program değildir. Kaynak dosya, ancak derleyici tarafından derlendikten sonra çalıştırılabilen program haline gelir.
)

$(P
Her tür dosyanın olduğu gibi, kaynak dosyanın da diske kaydedilirken bir isminin olması gerekir. Kaynak dosya isminde sisteminizin izin verdiği her harfi kullanabilirsiniz. Ancak, D kaynak dosyalarının dosya isim $(I uzantısının) $(C .d) olması gelenekleşmiştir. Geliştirme ortamları, araç programlar, ve başka programcılar da bunu beklerler. Örneğin $(C deneme.d), $(C tavla.d), $(C fatura.d), vs. uygun kaynak dosya isimleridir.
)

$(H5 Merhaba dünya programını derlemek)

$(P
$(IX metin düzenleyici) $(IX düzenleyici, metin) Kaynak dosya bir $(LINK2 http://wiki.dlang.org/Editors, metin düzenleyicide) (veya aşağıda bahsedildiği gibi bir $(I geliştirme ortamında)) yazılabilir. Yukarıdaki programı bir metin dosyasına yazın veya kopyalayın ve $(C merhaba.d) ismiyle kaydedin.
)

$(P
Derleyicinin görevi, bu kaynak dosyada yazım hataları bulunmadığını denetlemek ve onu makine koduna dönüştürerek çalıştırılabilir program haline getirmektir. Programı derlemek için şu adımları uygulayın:
)

$(OL

$(LI Bir uç birim penceresi (konsol, terminal, komut satırı, vs. diye de bilinir) açın.)

$(LI $(C merhaba.d) dosyasının kaydedildiği klasöre gidin.)

$(LI Aşağıdaki komutu yazın ve Enter'a basın. ($(C $) karakterini yazmayın; o karakter komut satırının başını temsil ediyor.))

)

$(SHELL
$(DARK_GRAY $) dmd merhaba.d
)

$(P
Eğer bir hata yapmadıysanız hiçbir şey olmadığını düşünebilirsiniz. Tersine, $(C dmd)'nin mesaj vermemesi herşeyin yolunda gittiğini gösterir. Bulunduğunuz klasörde $(C merhaba) (veya $(C merhaba.exe)) isminde bir program oluşmuş olması gerekir.
)

$(P
Eğer derleyici bazı mesajlar yazdıysa programı yazarken bir hata yaptığınız için olabilir. Hatayı bulmaya çalışın, olası yanlışları düzeltin, ve programı tekrar derleyin. Programlama hayatınızda doğal olarak sıklıkla hatalar yapacaksınız.
)

$(P
Program başarıyla derlenmişse ismini yazarak başlatabilirsiniz. Programın "Merhaba dünya!" yazdığını göreceksiniz:
)

$(SHELL
$(DARK_GRAY $) ./merhaba     $(SHELL_NOTE programın çalıştırılması)
Merhaba dünya!  $(SHELL_NOTE programın yazdığı satır)
)

$(P
Tebrikler! İlk D programınızı çalıştırdınız.
)

$(H5 $(IX derleyici seçeneği) Derleyici seçenekleri)

$(P
Derleyicilerin derleme aşamasıyla ilgili komut satırı seçenekleri vardır. Bu seçenekleri görmek için yalnızca derleyicinin ismini yazın ve Enter'a basın:
)

$(SHELL
$(DARK_GRAY $) dmd    $(SHELL_NOTE yalnızca derleyicinin ismi)
DMD64 D Compiler v2.069.0
Copyright (c) 1999-2015 by Digital Mars written by Walter Bright
Documentation: http://dlang.org/
Config file: /etc/dmd.conf
Usage:
  dmd files.d ... { -switch }

  files.d        D source files
...
  -de            show use of deprecated features as errors (halt compilation)
...
  -unittest      compile in unit tests
...
  -w             warnings as errors (compilation will halt)
...
)

$(P
Özellikle kısaltılmış olarak gösterdiğim yukarıdaki liste her zaman için kullanmanızı önerdiğim seçenekleri içeriyor. Buradaki merhaba dünya programında hiçbir etkisi olmasa da aşağıdaki komut hem birim testlerini etkinleştirir hem de hiçbir uyarıya veya emekliye ayrılmış olanağa izin vermez. Bu ve bazı başka seçeneklerin anlamlarını ilerideki bölümlerde göreceğiz:
)

$(SHELL
$(DARK_GRAY $) dmd merhaba.d -de -w -unittest
)

$(P
$(C dmd) komut satırı seçeneklerinin tam listesini $(LINK2 http://dlang.org/dmd-linux.html, DMD Compiler sayfasında) bulabilirsiniz.
)

$(P
$(C -run) seçeneğini de kullanışlı bulabilirsiniz. $(C -run), kaynak kodun derlenmesini, programın oluşturulmasını, ve çalıştırılmasını tek komuta indirger:
)

$(SHELL
$(DARK_GRAY $) dmd $(HILITE -run) merhaba.d -w -unittest
Hello world!  $(SHELL_NOTE program otomatik olarak çalıştırılır)
)


$(H5 $(IX IDE) $(IX geliştirme ortamı) Geliştirme ortamı)

$(P
Derleyiciye ek olarak bir $(I geliştirme ortamı) (IDE) da kurmayı düşünebilirsiniz. Geliştirme ortamları program yazma, derleme, ve hata ayıklama adımlarını kolaylaştıran programlardır.
)

$(P
Geliştirme ortamlarında program derlemek ve çalıştırmak, bir tuşa basmak veya bir düğmeye tıklamak kadar kolaydır. Yine de programların uç birimlerde nasıl derlendiklerini bilmeniz de önemlidir.
)

$(P
Bir geliştirme ortamı kurmaya karar verdiğinizde $(LINK2 http://wiki.dlang.org/IDEs, dlang.org'daki IDEs sayfasındaki) seçeneklere bakabilirsiniz.
)

$(H5 $(IX türkçe harfler) $(IX windows, türkçe harfler) Türkçe harfler)

$(P
Kitabın bölümleri bütünüyle Türkçe programlardan oluştuklarından çalıştığınız ortamda Türkçe harflerin doğru olarak görünmeleri önemlidir. Bunun için uç birim penceresinin UTF-8 kodlamasına ayarlanmış olması gerekir. (Linux gibi bazı ortamlarda uç birimler zaten UTF-8'e ayarlıdır.)
)

$(P
Örneğin, eğer bir Windows ortamında çalışıyorsanız karakter kodlamasını $(LINK2 http://ddili.org/forum/post/8, 65001'e ayarlamanız) ve Lucida Console gibi bir TrueType font seçmeniz gerekir.
)

$(H5 Merhaba dünya programının içeriği)

$(P
Bu kadar küçük bir programda bile değinilmesi gereken çok sayıda kavram bulunuyor. Bu kavramları bu aşamada fazla ayrıntılarına girmeden şöyle tanıtabiliriz:
)

$(P $(B İç olanaklar): Her programlama dili kendi söz dizimini, temel türlerini, anahtar sözcüklerini, kurallarını, vs. tanımlar. Bunlar o dilin $(I iç olanaklarını) oluştururlar. Bu programda görülen parantezler, noktalı virgüller, $(C main) ve $(C void) gibi sözcükler; hep D dilinin kuralları dahilindedirler. Bunları Türkçe gibi bir dilin yazım kurallarına benzetebiliriz: özne, yüklem, noktalama işaretleri, vs...
)

$(P $(B Kütüphaneler ve işlevler): Dilin iç olanakları yalnızca dilin yapısını belirler. Bu olanaklar kullanılarak oluşturulan işlevlerin bir araya getirilmelerine $(I kütüphane) adı verilir. Kütüphaneler programların yararlanmaları amacıyla bir araya getirilmiş olan program parçacıklarından oluşurlar.
)

$(P Bu programdaki $(C writeln) işlevi, standart D kütüphanesinde çıkışa satır yazdırmak için kullanılan bir işlevdir. İsmi, "satır yaz"ın karşılığı olan "write line"dan gelir.
)

$(P $(B Modüller): Kütüphane içerikleri, kullanış amaçlarına göre gruplanmış olan $(I modüllerdir). D'de kütüphaneler programlara bu modüller halinde tanıtılırlar. Bu programda kullanılan tek modül olan $(C std.stdio)'nun ismi, "standart kütüphanenin standart giriş/çıkış modülü" olarak çevirebileceğimiz "standard input/output"tan türemiştir.
)

$(P $(B Karakterler ve dizgiler): Bu programdaki $(STRING "Merhaba dünya!") gibi bilgilere $(I dizgi), dizgileri oluşturan elemanlara da $(I karakter) adı verilir. Örneğin bu programdaki dizgiyi oluşturan karakterlerden bazıları $(STRING M), $(STRING e), ve $(STRING !) karakterleridir.
)

$(P $(B İşlem sırası): Program, işini belirli adımları belirli sırada tekrarlayarak yapar. Bu sıranın en başında $(C main) isimli işlevin içindeki işlemler vardır; programın işleyişi, $(C main)'le başlar. Bu küçük programda tek bir işlem bulunuyor: $(C writeln)'li satırdaki işlem.
)

$(P $(B Büyük/Küçük harf ayrımı): Programda değişiklik yaparken dizgilerin içinde istediğiniz karakterleri kullanabilirsiniz, ama diğer isimleri görüldükleri gibi küçük harfle yazmaya dikkat edin, çünkü D dilinde büyük/küçük harf ayrımı önemlidir. Örneğin $(C writeln) ile $(C Writeln) D dilinde farklı isimlerdir.
)

$(P $(IX anahtar sözcük) $(B Anahtar sözcük): Dilin iç olanaklarını belirleyen özel sözcüklere $(I anahtar sözcük) denir. Anahtar sözcükler dilin kendisi için ayrılmış olan ve özel anlamlar taşıyan sözcüklerdir; programda başka amaçla kullanılamazlar. Bu programda iki anahtar sözcük bulunuyor: Programa modül eklemeye yarayan $(C import) ve buradaki kullanımında "hiçbir tür" anlamına gelen $(C void).
)

$(P
D'nin anahtar sözcükleri şunlardır: $(C abstract), $(C alias), $(C align), $(C asm), $(C assert), $(C auto), $(C body), $(C bool), $(C break), $(C byte), $(C case), $(C cast), $(C catch), $(C cdouble), $(C cent), $(C cfloat), $(C char), $(C class), $(C const), $(C continue), $(C creal), $(C dchar), $(C debug), $(C default), $(C delegate), $(C delete), $(C deprecated), $(C do), $(C double), $(C else), $(C enum), $(C export), $(C extern), $(C false), $(C final), $(C finally), $(C float), $(C for), $(C foreach), $(C foreach_reverse), $(C function), $(C goto), $(C idouble), $(C if), $(C ifloat), $(C immutable), $(C import), $(C in), $(C inout), $(C int), $(C interface), $(C invariant), $(C ireal), $(C is), $(C lazy), $(C long), $(C macro), $(C mixin), $(C module), $(C new), $(C nothrow), $(C null), $(C out), $(C override), $(C package), $(C pragma), $(C private), $(C protected), $(C public), $(C pure), $(C real), $(C ref), $(C return), $(C scope), $(C shared), $(C short), $(C static), $(C struct), $(C super), $(C switch), $(C synchronized), $(C template), $(C this), $(C throw), $(C true), $(C try), $(C typedef), $(C typeid), $(C typeof), $(C ubyte), $(C ucent), $(C uint), $(C ulong), $(C union), $(C unittest), $(C ushort), $(C version), $(C void), $(C volatile), $(C wchar), $(C while), $(C with), $(C __FILE__), $(C __MODULE__), $(C __LINE__), $(C __FUNCTION__), $(C __PRETTY_FUNCTION__), $(C __gshared), $(C __traits), $(C __vector), ve $(C __parameters).
)

$(P
$(IX asm) $(IX __vector) $(IX delete) $(IX typedef) $(IX volatile) $(IX macro) Bir kaç tanesi hariç, bu sözcükleri ilerideki bölümlerde göreceğiz: $(LINK2 http://dlang.org/statement.html#AsmStatement, $(C asm)) ve $(LINK2 http://dlang.org/phobos/core_simd.html#.Vector, $(C __vector)) bu kitabın kapsamı dışında kalıyor; $(C delete), $(C typedef), ve $(C volatile) emekliye ayrılmışlardır; ve $(C macro) henüz kullanılmamaktadır.
)

$(PROBLEM_COK

$(PROBLEM Programa istediğiniz başka bir şey yazdırın.)

$(PROBLEM Programı birden fazla satır yazacak şekilde değiştirin. Bunun için programa yeni bir $(C writeln) satırı ekleyebilirsiniz.)

$(PROBLEM Programın başka yerlerinde değişiklikler yapın ve derlemeye çalışın; örneğin $(C writeln) satırının sonundaki noktalı virgül olmadığında derleme hatalarıyla karşılaştığınızı görün.
)

)

)

Macros:
        SUBTITLE=Merhaba Dünya

        DESCRIPTION=İlk D programlama dili dersi: Merhaba Dünya!

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial merhaba dünya

SOZLER= 
$(anahtar_sozcuk)
$(derleyici)
$(dizgi)
$(emekli)
$(gelistirme_ortami)
$(ic_olanak)
$(islev)
$(karakter)
$(kaynak_dosya)
$(klasor)
$(metin_duzenleyici)
$(modul)
$(program)
$(standart_cikis)
$(uc_birim)
