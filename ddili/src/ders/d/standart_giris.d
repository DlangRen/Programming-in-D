Ddoc

$(DERS_BOLUMU $(IX giriş) Girişten Bilgi Almak)

$(P
Girilen bilginin daha sonradan kullanılabilmesi için bir değişkende saklanması gerekir. Örneğin okulda kaç tane öğrenci bulunduğu bilgisini alan bir program, bu bilgiyi $(C int) türünde bir değişkende tutabilir.
)

$(P
Yazdırma işlemi sırasında dolaylı olarak $(C stdout) akımının kullanıldığını bir önceki bölümde gördük. Bu, bilginin nereye gideceğini açıklamaya yetiyordu; çünkü $(C stdout), $(I standart çıkış) demektir. Çıkışa ne yazdırılacağını da parametre olarak veriyorduk. Örneğin $(C write(öğrenci_sayısı);) yazmak, çıkışa $(C öğrenci_sayısı) değişkeninin $(I değerinin) yazdırılacağını söylemeye yetiyordu. Özetlersek:
)

$(MONO
akım:       stdout
işlem:      write
yazdırılan: öğrenci_sayısı değişkeninin değeri
hedef:      normalde ekran
)

$(P
$(IX readf) $(C write)'ın karşılığı $(C readf)'tir. İsmindeki "f", "belirli bir düzende"nin İngilizcesi olan "formatted"dan gelir.
)

$(P
Standart girişin de $(C stdin) olduğunu görmüştük.
)

$(P
Okuma durumunda bundan başkaca önemli bir ayrıntı vardır: okunan bilginin nerede depolanacağının da belirtilmesi gerekir. Okuma işlemini de özetlersek:
)

$(MONO
akım:       stdin
işlem:      readf
okunan:     bir bilgi
hedef:      ?
)

$(P
Bilginin depolanacağı hedef belirtilirken bir değişkenin adresi kullanılır. Bir değişkenin adresi, o değişkenin değerinin bellekte yazılı olduğu yerdir.
)

$(P
$(IX &, adres) D'de isimlerden önce kullanılan $(C &) karakteri, o isimle belirtilen şeyin $(I adresi) anlamına gelir. $(C readf)'e okuduğu bilgiyi yerleştireceği yer bu şekilde bildirilir: $(C &öğrenci_sayısı). Burada $(C &öğrenci_sayısı), "öğrenci_sayısı değişkenine" diye okunabilir. Bu kullanım, yukarıdaki soru işaretini ortadan kaldırır:
)

$(MONO
akım:       stdin
işlem:      readf
okunan:     bir bilgi
hedef:      öğrenci_sayısı değişkeninin bellekteki yeri
)

$(P
İsimlerin başına $(C &) karakteri koymak o ismin belirttiği şeyin $(I gösterilmesi) anlamına gelir. Bu gösterme kavramı, sonraki bölümlerde karşılaşacağımız referansların ve göstergelerin de özünü oluşturur.
)

$(P
$(C readf) konusunda bir noktayı ilerideki bölümlere bırakacağız ve şimdilik ilk parametresi olarak $(STRING "%s") kullanmak gerektiğini kabul edeceğiz:
)

---
    readf("%s", &öğrenci_sayısı);
---

$(P
($(I Not: Çoğu durumda aslında boşluk karakteri ile) $(STRING " %s") $(I yazmak gerekeceğini aşağıda gösteriyorum.))
)

$(P
$(STRING "%s"), verinin değişkene uygun olan düzende dönüştürüleceğini belirtir. Örneğin girişten gelen '4' ve '2' karakterleri, bir $(C int)'e okunduklarında 42 tamsayı değerini oluşturacak şekilde okunurlar.
)

$(P
Bu anlatılanları gösteren programda önce sizden öğrenci sayısını bildirmeniz isteniyor. İstediğiniz değeri yazdıktan sonra Enter'a basmanız gerekir.
)

---
import std.stdio;

void main() {
    write("Okulda kaç öğrenci var? ");

    // Öğrenci sayısının tutulacağı değişkenin tanımlanması
    int öğrenci_sayısı;

    /* Girişten gelen bilginin öğrenci_sayısı değişkenine
     * atanması */
    readf("%s", &öğrenci_sayısı);

    writeln(
      "Anladım: okulda ", öğrenci_sayısı, " öğrenci varmış.");
}
---

$(H5 $(IX %s, boşluklu) $(IX boşluk) Boşlukların gözardı edilmelerinin gerekmesi)

$(P
Yukarıdaki gibi programlarda değerleri yazdıktan sonra Enter tuşuna basılması gerektiğini biliyorsunuz. Kullanıcının Enter tuşuna basmış olması da özel bir kod olarak ifade edilir ve o bile programın standart girişinde belirir. Programlar böylece bilgilerin tek satır olarak mı yoksa farklı satırlarda mı girildiklerini algılayabilirler.
)

$(P
Bazı durumlarda ise girişte bekleyen o özel kodların hiçbir önemi yoktur; süzülüp gözardı edilmeleri gerekir. Yoksa standart girişi $(I tıkarlar) ve başka bilgilerin girilmesini engellerler.)

$(P
Bunun bir örneğini görmek için yukarıdaki programda ayrıca öğretmen sayısının da girilmesini isteyelim. Program düzenini biraz değiştirerek ve açıklamaları kaldırarak:
)

---
import std.stdio;

void main() {
    write("Okulda kaç öğrenci var? ");
    int öğrenci_sayısı;
    readf("%s", &öğrenci_sayısı);

    write("Kaç öğretmen var? ");
    int öğretmen_sayısı;
    readf("%s", &öğretmen_sayısı);

    writeln("Anladım: okulda ", öğrenci_sayısı, " öğrenci",
            " ve ", öğretmen_sayısı, " öğretmen varmış.");
}
---

$(P
Ne yazık ki program ikinci $(C int)'i okuyamaz:
)

$(SHELL
Okulda kaç öğrenci var? 100
Kaç öğretmen var? 20
  $(SHELL_NOTE_WRONG Burada bir hata atılır)
)

$(P
Öğretmen sayısı olarak 20 yazılmış olsa da $(I bir önceki 100'ün) sonunda basılmış olan Enter'ın kodları girişi tıkamıştır ve o yüzden $(C öğretmen_sayısı) değişkeninin değeri olan 20 okunamamaktadır. Programın girişine gelen kodları şu şekilde ifade edebiliriz:
)

$(MONO
100$(HILITE [EnterKodu])20[EnterKodu]
)

$(P
Girişin tıkandığı noktayı işaretli olarak belirttim.
)

$(P
Bu durumda çözüm, öğretmen sayısından önce gelen Enter kodunun önemli olmadığını belirtmek için $(STRING %s) belirtecinden önce bir boşluk karakteri kullanmaktır: $(STRING " %s"). Düzen dizgisi içinde geçen boşluk karakterleri $(I sıfır veya daha fazla sayıdaki görünmez kodu) okuyup gözardı etmeye yararlar. O tek boşluk karakteri bütün görünmez karakter kodlarını okuyup gözardı eder: normal boşluk karakteri, Enter'la girilen satır sonu karakteri, Tab karakteri vs.
)

$(P
Genel bir kural olarak, okunan her değer için $(STRING " %s") kullanabilirsiniz. Yukarıdaki program o değişiklikle artık istendiği gibi çalışır. Yalnızca değişen satırlarını göstererek:
)

---
// ...
    readf(" %s", &öğrenci_sayısı);
// ...
    readf(" %s", &öğretmen_sayısı);
// ...
---

$(P
Çıktısı:
)

$(SHELL
Okulda kaç öğrenci var? 100
Kaç öğretmen var? 20
Anladım: okulda 100 öğrenci ve 20 öğretmen varmış.
)

$(H5 Ek bilgiler)

$(UL
$(LI
$(IX açıklama) $(IX /*) $(IX */) Daha önce gördüğümüz $(COMMENT //) karakterleri tek bir satır açıklama yazmaya elverişlidir. Birden fazla satırda blok halinde açıklama yazmak için açıklamayı $(COMMENT /*) ve $(COMMENT */) belirteçleri arasına alabilirsiniz.

$(P
$(IX /+) $(IX +/) Başka açıklama belirteçlerini de içerebilmek için $(COMMENT /+) ve $(COMMENT +/) belirteçleri kullanılır:
)

---
    /+
     // Tek satırlık açıklama

     /*
       Birden fazla
       satırlık açıklama
      */

      Yukarıdaki belirteçleri bile içerebilen açıklama bloğu
     +/
---

)

$(LI
Kaynak kodlardaki boşluk karakterlerinin çoğu önemsizdir. O yüzden fazla uzayan satırları bölebiliriz veya daha anlaşılır olacağını düşündüğümüz boşluklar ekleyebiliriz. Hatta yazım hatasına yol açmadığı sürece hiç boşluk kullanmayabiliriz bile:

---
import std.stdio;void main(){writeln("Okuması zor!");}
---

$(P
Fazla sıkışık kodu okumak güçtür.
)

)

)

$(PROBLEM_TEK

$(P
Girişten sayı beklenen durumda harfler girin ve programın yanlış çalıştığını gözlemleyin.
)

)

Macros:
        SUBTITLE=Girişten Bilgi Almak

        DESCRIPTION=D dilinde girişten bilgi almak

        KEYWORDS=d programlama dili ders bölümler öğrenmek tutorial girişten bilgi almak okumak

SOZLER=
$(gosterge)
$(standart_cikis)
