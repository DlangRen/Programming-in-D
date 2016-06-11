Ddoc

$(H4 $(C shared)'e Geçiş)

$(P
  $(B Çeviren:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Tarih:) 13 Aralık 2009
$(BR)
  $(B İngilizcesi:) $(LINK2 http://www.dlang.org/migrate-to-shared.html, Migrating to Shared)
)

$(P
$(C dmd)'nin 2.030 sürümünden başlayarak, C ve C++'da olduğunun aksine, statik ve evrensel (global) değişkenler artık evrensel alanda değil, her iş parçacığına özel alanda (thread local storage - TLS) bulunuyorlar. Çoğu D programının bu değişimden hiç etkilenmeden derlenmesi ve çalışması beklense de, bilinmesi gereken bazı konular vardır:
)

$(OL
$(LI TLS değişkenlerinin hızları)
$(LI TLS değişkenlerinin hangileri olduklarını bilebilmek)
$(LI $(C immutable) olarak işaretlemek)
$(LI $(C shared) olarak işaretlemek)
$(LI $(C __gshared) ile klasik alana yerleştirmek)
$(LI Derleyici hataları)
$(LI Bağlayıcı hataları)
)

$(H5 TLS değişkenlerinin hızları)

$(P
Evet, iş parçacığına özel değişkenleri okumak ve yazmak klasik evrensel değişkenlerden daha yavaştır. Tek bir mikro işlemci işlemi yerine üç işlem gerekeceği düşünülebilir; ancak, en azından Linux üzerinde, derleyici seçeneği olarak PIC (position independent code) seçildiğinde, TLS değişkenlerinin klasik evrensel değişkenlerden az da olsa daha hızlı olmaları beklenir. Bu yüzden hız konusunda bir sorun olacağını düşünmek gerçekçi olmaz. Yine de hız sorunu olacağını bir an için kabul ederek neler yapılabileceğine bakalım:
)

$(OL
$(LI Evrensel değişkenleri azaltın. Evrensel değişken kullanımın azaltılması; kodun bağımsızlığını ve geliştirilebilirliğini arttıracağı için, bu zaten hedeflenen bir amaçtır.
)

$(LI Evrensel değişkenleri $(C immutable) yapın. $(C immutable) verilerin iş parçacıkları tarafından ortak kullanılmaları ve eş zamanlı çalışma sorunları olmadığı için derleyici onları TLS'ye yerleştirmez.
)

$(LI Evrensel değişkenin yerel bir kopyasını kullanın. Asıl değişken yerine yerel kopyasının kullanılması erişimin daha hızlı olmasını sağlar.
)

$(LI Değişkeni $(C __gshared) ile normal evrensel değişken haline getirin.
)

)

$(H5 TLS değişkenlerinin hangileri olduklarını bilebilmek)

$(P
Kendileriyle ilgili bu konuda herhangi bir işlem yapılabilmesi için evrensel değişkenlerin öncelikle tanınmaları gerekir.
)

$(P
Programların ne kadar karmaşık olabilecekleri göz önüne alınırsa, evrensel değişkenleri bulmak her zaman kolay olmayabilir. Eskiden otomatik olarak evrensel olduklarından, onları $(C grep) programıyla da ayırt edemeyiz. Bulduğumuz kadarının da evrensel değişkenlerin tümü olduğundan emin olamayız.
)

$(P
Bu konuda yardımcı olması için yeni bir $(C dmd) seçeneği eklenmiştir: $(C -vtls). Program o seçeneği kullanarak derlendiğinde, TLS alanına yerleştirilen bütün değişkenler listelenir:
)

---
int x;

void main()
{
    static int y;
}
---

$(SHELL
dmd test $(HILITE -vtls)
test.d(2): x is thread local
test.d(6): y is thread local
)

$(H5 $(C immutable) olarak işaretlemek)

$(P
$(C immutable) veriler bir kere ilk değerlerini aldıktan sonra değiştirilemezler. Bu, çoklu iş parçacıkları kullanıldığında eş zamanlı çalışmayla ilgili erişim sorunlarının ortadan kalkması anlamına gelir. Bu yüzden, $(C immutable) verilerin TLS'e yerleştirilmelerine de gerek yoktur. Derleyici bu tür değişkenleri TLS'e değil, güvenle klasik evrensel alana yerleştirir.
)

$(P
Programlarda kullanılan evrensel değişkenlerin büyük bir bölümü bu türdendir. $(C immutable) olarak işaretlenmeleri yeter:
)

---
int[3] tablo = [6, 123, 0x87];
---

$(P
yerine
)

---
immutable int[3] tablo = [6, 123, 0x87];
---

$(P
$(C immutable)'ın getirdiği $(I değişmezlik) kavramının başka bir yararı, derleyiciye daha fazla eniyiliştirme [optimization] olanağı sunmasıdır.
)

$(H5 $(C shared) olarak işaretlemek)

$(P
Gerçekten birden fazla iş parçacığı tarafından erişilen veriler $(C shared) olarak işaretlenmelidir:
)

---
shared int birDurum;
---

$(P
Bu, $(C birDurum)'un klasik evrensel alana yerleştirilmesi yanında, türünün de $(C shared) olmasına neden olur:
)

---
int* p = &birDurum;           // hata: birDurum shared'dir
shared(int)* q = &birDurum;   // çalışır
---

$(P
$(C const) ve $(C immutable)'da olduğu gibi, $(C shared) de $(I geçişlidir). Böylece paylaşılan verilere erişimlerin doğruluğu da derleme zamanında denetlenebilir.
)

$(H5 $(C __gshared) ile klasik alana yerleştirmek)

$(P
Yukarıdaki çözümlerin kullanılamadığı zamanlar olabilir:
)

$(OL

$(LI klasik evrensel değişkenler kullanan C kodu kullanıldığında)

$(LI programı çabucak derlenebilir hale getirerek, daha uygun çözümün daha sonraya bırakıldığında)

$(LI program tek iş parçacığı kullandığında [single-threaded]; bu durumda zaten eş zamanlı erişim sorunları yoktur)

$(LI en ufak hız kaybı bile önemli olduğunda)

$(LI eş zamanlı erişim konusunu kendiniz halletmek istediğinizde)

)

$(P
D bir sistem dili olduğu için, size bu serbestiyi $(C __gshared) anahtar sözcüğü ile sağlar:
)

---
__gshared int x;

void main()
{
    __gshared int y;
}
---

$(P
$(C __gshared), değişkeni klasik evrensel alana yerleştirir.
)

$(P
Doğal olarak, $(I safe) modda $(C __gshared) kullanılamaz.
)

$(P
Kodun içindeki $(C __gshared) değişkenler daha uygun çözümlerin uygulanması için kolayca bulunabilirler.
)

$(H5 Derleyici hataları)

$(P
TLS ile ilgili en çok karşılaşılacak hata herhalde şudur:
)

---
int x;
int* p = &x;
---

$(SHELL
test.d(2): Error: non-constant expression & x
)

$(P (Türkçesi: "sabit olmayan ifade"))

$(P
Klasik evrensel değişkenlerle normalde derlenebilen o ifade, TLS değişkenleriyle derlenemez. Bunun nedeni, TLS değişkenlerinin adreslerinin ne bağlayıcı [linker] ne de yükleyici [loader] tarafından bilinebilmesidir. Bu değişkenlerin adresleri çalışma zamanında hesaplanır.
)

$(P
Çözüm, bu tür değişkenleri statik kurucu işlevlerde ilklemektir.
)

$(H5 Bağlayıcı hataları)

$(P
Evrensel değişkenlerle ilgili bağlayıcı hataları da alabilirsiniz. Çoğu durumda bunların nedeni; değişkenin bir modül tarafından TLS'e yerleştirmesine karşın, başka bir modül tarafından klasik evrensel alana yerleştirilmesidir. Böyle bir durum; program, dmd'nin önceki bir sürümü ile derlenmiş olan kütüphanelerle bağlanırken oluşabilir. Kullanılan $(C libphobos2.a) kütüphanesinin yeni sürümle gelen yeni kütüphane olduğundan emin olun.
)

$(P
Bu durumla C ile etkileşirken de karşılaşılabilir. C, TLS değişkenlerini de destekliyor olsa da; C'de evrensel değişkenler için varsayılan yerleşim, klasik evrensel yerleşimdir. Bu gibi durumlarda D iliştirici [binding] dosyalarındaki bildirimlerin TLS ve klasik yerleşim konularında C'dekilere uyduklarından emin olmak gerekir:
)

$(FARK_C
int x;
extern int y;
__thread int z;
)

$(FARK_D
---
extern (C)
{
    extern shared int x;
    shared int y;
    extern int z;
}
---
)


Macros:
        SUBTITLE=shared'e Geçiş

        DESCRIPTION=D'de statik ve evrensel değişkenlin normalde iş parçacığına özel olmaları

        KEYWORDS=d programlama dili makale d tanıtım evrensel global erişim TLS thread is parçacığı
