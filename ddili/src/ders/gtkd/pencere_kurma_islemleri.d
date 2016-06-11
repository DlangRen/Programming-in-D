Ddoc

$(DERS_BOLUMU Pencere Kurma İşlemleri)

$(P Daha önceki dersimizde başlığı olan boş bir pencere yapmasını öğrenmiştik. Bu dersimizde pencere kurma ile ilgili işlemler yapacağız. )
$(P Anlatılacak bütün işlevler $(C gtk.Window) modülünde tanımlı olan $(I Window) sınıfının üye işlevleridir. )

$(H5 $(IX resize) Pencere Boyutunu Ayarlamak $(C resize(int en, int boy)))

$(P gtkD ile oluşturulan pencerenin öntanımlı boyutu 200x200 piksel boyutundadır. Eğer öntanımlı piksel boyutunu değiştirmek isterseniz,  $(HILITE resize) işlevini kullanabilirsiniz. $(HILITE resize) iki tane $(BLUE int) türünde parametre alır. Bunlar sırasıyla en ve boydur.  )
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere =
              new Window("450 eninde ve 570 boyunda resize.");
    pencere.resize(450,570) ; // Pencere 450 piksel eninde
                              // ve 570 boyundadır.
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX maximize) Pencereyi Tam Ekran Yapmak $(C maximize()) )
$(P
Eğer pencerenin tam ekran olmasını istiyorsanız $(HILITE maximize()) işlevini kullanabilirsiniz.
)
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("maximize");
    pencere.maximize(); // Pencereyi tam ekran yapar.
    pencere.show();
    Main.run;

    return 0;
}
---

$(H5 $(IX unmaximize) Pencereyi Tam Ekrandan Çıkartmak $(C unmaximize()) )
$(P
Eğer pencerenin tam ekran kipinden çıkmasını istiyorsanız $(HILITE unmaximize()) işlevini kullanabilirsiniz.
)
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("unmaximize");
    pencere.maximize(); // Pencereyi tam ekran yapar.
    pencere.unmaximize();/*Pencereyi tam ekran kipinden çıkarır
                           ve öntanımlı boyutuna getirir. */
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX move) Pencereyi Ekranda Konumlandırmak $(C move(int sağa, int aşağıya)))
$(P
Eğer pencerenin ekranda konumunu ayarlamak isterseniz, $(HILITE move) işlevini kullanabilirsiniz.
$(HILITE move) işlevi 2 parametre alır, parametre türü olarak $(BLUE int) değeri alır ve birimi pikseldir. Ekranın nereye yerleşeceğini de sol üst köşeden başlayarak girilen değer kadar sağa(en), ve aşağıya(boy) taşır.
)
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("move");
    pencere.move(450,570) ; // 450 piksel sağa ve 570 piksel
                            // aşağıya taşır.
    pencere.show();
    Main.run;
    return 0;
}
---



$(H5 $(IX setPosition) Pencereyi Piksel Değeri Girmeden Konumlandırmak $(C setPosition(GtkWindowPosition nereye)))
$(P
Eğer pencerenin konumunu piksel olarak değer vermeden örneğin ortala diyerek belirtmek istersek setPosition() işlevini kullanabiliriz.
)
$(P
$(C setPosition()) işlevi parametre olarak şu değerleri alır:
)

$(P $(B GtkWindowPosition.POS_NONE:) Pencere konumu üzerinde herhangi bir değişiklik yapılmayacağını belirtir.)

$(P $(B GtkWindowPosition.POS_CENTER: ) Pencereyi ekranın ortasına yerleştirir.)

$(P $(B GtkWindowPosition.POS_MOUSE: ) Pencere, farenin o anda bulunduğu konumda açılır.)

$(P $(B GtkWindowPosition.POS_CENTER_ALWAYS:) Pencerenin boyutu değişse de, pencereyi hep ekranın ortasında tutar.)

$(P $(B GtkWindowPosition.POS_CENTER_ON_PARENT:) Eğer ikinci bir pencere varsa bu pencerenin ana pencereyi ortalamasını sağlar.)

$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("maximize");
    pencere.setPosition(GtkWindowPosition.POS_CENTER_ALWAYS); 
    // ekranın ortasında açılmasını sağlar
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX setIconFromFile) Pencereye Simge Eklemek $(C setIconFromFile))
$(P 
Eğer pencereye simge(icon) eklemek isterseniz $(HILITE setIconFromFile) işlevini kullanabilirsiniz.  $(BLUE int) türünde değer döndürür ve $(BLUE string) türünde parametre alır. Parametre olarak ekleyeceğiniz resmin yolunu yazarsınız.
)
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("deneme");
    pencere.setIconFromFile("/home/canalpay/den.png"); 
    // Pencereye simge koymaya yarar.
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX setOpacity) Pencereyi Saydamlaştırmak $(C setOpacity(double değer)))
$(P Pencereyi saydamlaştırmak için $(HILITE setOpacity) işlevi  kullanılır. 0 ile 1 arasındaki $(BLUE double) değerler alır. Değer 1'e yaklaştıkça saydamlığı azalır.)
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("Saydam Pencere Yapımı");
    pencere.setOpacity(0.9); //Pencerenin saydamlığı oldukça azdır.
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX setSizeRequest) Pencere Boyutlandırma $(C setSizeRequest(int en, int boy)))
$(P
Kullanımı resize() ile aynıdır. Tek farkı fare imleci ile pencerenin boyutu büyütülebilir ama öntanımlı boyuttan daha küçük yapılamaz.
)
$(P Ayrıca bir sonraki işlev için resize yerine bunun kullanılması gerekecektir.)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("setSizeRequest örneği");
    pencere.setSizeRequest(450, 450);
    pencere.show();
    Main.run;
    return 0;
}
---
$(H5 $(IX setResizable) Boyutlandırılamayan Pencereler $(C setResizable(bool değer)))
$(P
Pencere boyutlandırılabilsin mi yoksa boyutlandırılamasın mı diye ayarlamak için $(HILITE setResizable()) işlevi kullanılır. "Resizable" sözcük anlamı "tekrar boyutlandırılabilir"dir. Parametre olarak $(BLUE bool) değer alır. Eğer parametre olarak false değeri girilirse boyutlandırılamaz. Eğer true değeri girilirse boyutlandırılabilir.
)
$(UYARI setResizable işlevini doğru kullanabilmek için boyutlandırmayı $(B setSizeRequest) işlevi ile yapmak zorundasınız.) 
$(P Örnek :)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("Boyutlandırılamayan Pencere");
    pencere.setSizeRequest(450, 450);
    pencere.setResizable(false); 
    //false değeri girerek boyutlandırılamayacağını belirtmiş olduk
    pencere.show();
    Main.run;
    return 0;
}
---

$(H5 $(IX X düğmesi) X Düğmesine Kapama Görevi Verme)
$(P
Eğer daha önceki örnekleri konsol üzerinde çalıştırdıysanız $(B X) düğmesine bastığınızda hala programın çalışmaya devam ettiğini görmüşsünüzdür. Programdan çıkmak için de $(I Ctrl + C) tuşuna basmış olmalısınız. Ama biz $(B X) düğmesine bastığımızda programın çıkmasını istiyoruz.)
$(P $(B X) düğmesine bastığımızda çıkmamız için şu kod parçacığını eklememiz gerekiyor.)

$(IX addOnHide)

---
    pencere.addOnHide( delegate void(Widget aux){ exit(0); });
---

$(P Bu kod parçacığının çalışması için de $(C std.c.process) ve $(C gtk.Widget) modüllerini eklememiz gerekiyor.
)

$(P Örnek :)

---
import gtk.Window;
import gtk.Main;
import gtk.Widget;
import std.c.process;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window
    ("[X] Düğmesine Bas ve Program Sonlandırılsın!");
    pencere.setSizeRequest(450, 450);
    pencere.setResizable(false);
    pencere.addOnHide( delegate void(Widget aux){ exit(0); });

    pencere.show();
    Main.run;
    return 0;
}
---
Macros:
        SUBTITLE=Pencere İşlemleri

        DESCRIPTION=Yapabileceğimiz Pencere İşlemlerini Tanıyalım. 
        KEYWORDS=d programlama dili ile görsel programlama gtk gtkd öğrenmek tutorial pencere işlemleri
