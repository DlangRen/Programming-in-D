Ddoc

$(DERS_BOLUMU Merhaba GtkD)

$(P
Bu dersimizde gtkD ile pencere oluşturabilmek için gerekli modülleri öğreneceğiz.
)

$(P
En basit pencere, içi boş penceredir. İlk önce içi boş bir pencere nasıl oluşturulur onu öğreneceğiz.
Sizce bir pencere oluşturmak için neler yapmak gerekir?  Hızlıca düşünürsek:
)

$(OL

$(LI
Gtk işlevlerini kullanmadan önce bir işlev çağırmamız gerekiyorsa  o işlevi çağırmalıyız. (Sizce gerek var mıdır $(GULEN ) )
) 

$(LI
Pencere oluştur demeliyiz.
)
$(LI
Pencereyi göster demeliyiz.
)
$(LI
Bu yaptıklarımızı çalıştır demeliyiz.
)
)

$(P
Bunları sağlayan kod parçacığı aşağıda :
)
---
import gtk.Window;
import gtk.Main;

int main(string[] args)
{
    Main.init(args);
    auto pencere = new Window("deneme");
    pencere.show();
    Main.run;

    return 0;
}
---
$(P
Örneğimizde neler yaptık bakalım:
)

$(P
$(IX gtk.Window)
$(IX gtk.Main)
İlk olarak iki tane modülü programımıza dahil ettik. Bunlar $(C gtk.Window) ve $(C gtk.Main).
Sonra D'nin ana işlevi olan main işlevini tanımladık. Ama burada main işlevini tanımlarken $(BLUE string[]) türünde bir argüman tanımladık. Burada argümanın hangi türden tanımlandığı önemlidir.)
$(P Şimdi sıra tanımlanan argümanı kullanmaya geldi.  Dersimizin ilk bölümlerinde pencereleri oluşturmadan önce; daha doğrusu gtk'nin işlevlerini kullanmadan önce başka bir işlev çağırmamız gerektiğinden söz etmiştik. Bu işlevi her gtk uygulamasında çağırmamız gerekir. Şimdi bu işlev hangi modülde bulunur, adı nedir, parametre alır mı, alırsa hangi türden parametre alır gibi soruların yanıtlarını alacağız.)
$(P
$(IX init)
Tanıyacağımız ilk işlev, $(HILITE Main.init). Bu işlev $(C gtk.Main) modülünde bulunuyor. Parametre olarak da D uygulamasının ana işlevini tanımlarken kullandığımız argümanı kullanıyor. Ve parametre türü olarak da sadece $(BLUE string[]) türü kabul ediyor.  Kısaca: )

---
void Main.init (string[] args);
---

$(P Gtk işlevlerini kullanmak için gtk.Main modülünde bulunan $(HILITE Main.init) işlevini kullandıktan sonra sıra penceremizi oluşturmaya geldi. Pencereyi oluşturabilmek için ilk önce $(C gtk.Window) modülündeki $(I Window) sınıfını kuruyoruz. Bunun için şu satırı yazmıştık : )

---
    auto pencere = new Window("deneme");
---

$(P Koddan anlaşıldığı üzere bu sınıfın  kurucusu tanımlı ve parametre türü olarak $(BLUE string) değer alıyor. Kurucudaki parametre, oluşturacağımız pencerenin başlığını tanımlar.) 
$(P
$(IX show)
Artık uygulamamızın sonuna doğru geldik. Bundan sonraki işlev yine $(C gtk.Window) modülünde tanımlı. Daha önce pencere adı ile kurduğumuz sınıfın $(HILITE show) işlevine erişiyoruz. Show sözcüğünün Türkçe anlamı görüntüle, göster demektir. Biz de oluşturduğumuz pencereyi göstermek için $(B pencere.show;) kodunu yazıyoruz.)
$(P
$(IX run)
Ve sonunda bu gtk uygulamasını çalıştırmak için gtkD ile ilişkili olan son kod satırımızı yazıyoruz. Bu kod satırında gtk uygulamasını çalıştır anlamına gelen $(HILITE Main.run;) kodunu yazıyoruz. Bu kod parçası yine $(C gtk.Main) modülünde bulunuyor.
)



$(H5 $(IX derleme) $(IX dmd) Peki Bu GtkD Kodlarını Nasıl Çalıştıracağız? )


$(P
Bu örneği merhaba.d adında çalışma alanınıza kaydettikten sonra şu şekilde
derleyebilirsiniz:
)

$(SHELL_SMALL
dmd merhaba.d -I/gtkD/yolu/src -L-ldl -L-L/gtkD/yolu/src -L-lgtkd
)

$(P
Yukarıda dikkat etmeniz gereken kısım “/gtkD/yolu” kısmıdır ki onu gtkD'yi nereye
kurduysanız, o yol (path) şeklinde değiştirmeniz gerekmektedir. Örneğin ben
~/projects/gtkD klasörü altında kurduğum için şu şekilde derledim:
)

$(SHELL_SMALL
dmd merhaba.d -I~/projects/gtkD/src -L-ldl -L-L~/projects/gtkD/src -L-lgtkd
)

$(P
merhaba.d dosyasını derledikten sonra da terminalde ./merhaba yazarak pencerenizi
görebilirsiniz.
)


Macros:
        SUBTITLE=Merhaba gtkD

        DESCRIPTION=İlk GtkD programınız

        KEYWORDS=d programlama dili ile görsel programlama gtk gtkd öğrenmek tutorial merhaba dünya

