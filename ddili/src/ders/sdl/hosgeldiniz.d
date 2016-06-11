Ddoc
$(DERS_BOLUMU Hoşgeldiniz)

$(P
D ile 2D oyun programlama dersine hoşgeldiniz. Bu derste D dili kullanarak 2D
oyun programlamaya bir başlangıç yapacağız.
)

  
$(P
Bir oyunun geliştirme aşamaları şu bölümlerden oluşuyor
)

$(UL
$(LI Oyun tasarımı ve senaryo)
$(LI Programlama)
$(LI Görsel Sanatlar)
  (Çizim, resim ve diğer sanatsal içerik)
)

$(P
Biz bunlardan programlama ile ilgileneceğiz. Bunu yaparken programlama dili
olarak D kullanacağız. 
)

$(P
Kullanacağımız grafik kütüphanesi ise SDL (Simple Direct Media Layer)
)

$(P
$(LINK http://www.libsdl.org)
)

$(P
Konuları takip edebilmek için sadece D programlama dilini bilmeniz
yeterli. Her ne kadar SDL grafik kütüphanesi kullanıyor olsak da
asıl amacım sadece 2D oyun programlama, oyun değişkenleri ile ilgili
temel kavramları anlatmak olacak.
)
$(P
SDL ile ilgili konuları sadece gerektiğinde ve $(I uzmanlar için)
bölümünde ek bilgi olarak anlatmayı düşünüyorum.  
)

$(ALTBASLIK Haydi başlayalım)

$(P
Başlamak için şu basit adımları izlemeniz yeterli:
)

$(OL
  $(LI D derleyicisini kurun)
  $(LI SDL için geliştirme kütüphanelerini kurun)
  $(LI Örnek projeyi bilgisayarınıza indirin)
)

$(P gerekli araçları kuralım)

$(P
  1- D derleyicisi:
)

$(P
Ubuntu altında Digital Mars derleyicisinin son sürümünü
)

$(P
$(LINK http://dlang.org/download.html)
)

$(P
adresinden indirerek otomatik olarak yazılım merkezi ile kurabilirsiniz.
)

$(P
Windows altında Digital Mars derleyicisinin son sürümünü
)

$(P
$(LINK http://dlang.org/download.html)
)

$(P
adresinden otomatik olarak kurabilirsiniz.
)


$(P
2- SDL geliştirme kütüphaneleri:
)

$(P
SDL geliştirme kütüphanelerini kurmak için Ubuntu altında konsolda
)

$(SHELL
$ sudo apt-get install libsdl1.2-dev libsdl-image1.2-dev
)

$(P
komutunu vermeniz yeterli.
)

$(P
  Windows altında, SDL geliştirme kütüphaneleri örnek proje
  ile beraber geliyor. Bu yüzden SDL ile ilgili kütüphaneleri
  indirmenize gerek yok.
)


$(P
  Ancak kolaylık olması açısından $(HILITE bin)
  dizininde bulunan $(COMMENT *.dll) uzantılı dosyaları
  $(C C:\WINDOWS\system32) dizinine kopyalamak isteyebilirsiniz.
)
  
$(P
3- Örnek projeyi indirelim:
)

$(P
Örnek projeyi indirmek için tarayıcınızla
)

$(P
$(LINK https://github.com/erdemoncel/oyun)
)

$(P
  adresini açıp sağ üst tarafta bulunan $(SUP Downloads) düğmesine tıklayıp
  $(SUP Download .tar.gz) ya da $(SUP Download .zip) seçerek projeyi
  indirmeniz yeterli
)

$(P
  Ya da eğer $(I github) kullanımını biliyorsanız basitçe:
)

$(SHELL
$ git clone git@github.com:erdemoncel/oyun.git
)

$(P
komutuyla projenin bir kopyasını bilgisayarınıza indirebilirsiniz.
)

$(ALTBASLIK Oyun döngüsü)


$(P
<img src="$(ROOT_DIR)/image/oyundongusu.jpg" align="right" alt="Oyun Döngüsü" />
  
Bir oyunun temel bileşeni bir oyun döngüsüdür. İster çok gelişmiş ya da
basit bir oyun olsun her oyun bir oyun döngüsü kullanır. Şimdi bir oyun
döngüsünün yapısını inceleyelim.
)

$(MINIBASLIK İlklendir :
)
$(P
Oyunda kullandığımız oyun değişkenlerinin ilk  değerlerini burada veriyoruz.
)

$(MINIBASLIK İçeriği Yükle :)  
$(P
Oyunumuzun ihtiyaç duyduğu 2D hareketli grafikler texture, oyuncu modelleri,
ses efektleri ve müzik gibi içeriği bu bölümde yüklüyoruz,
)

$(MINIBASLIK Güncelle :
)  
$(P
Burada oyuncunun klavye, oyun çubuğu ya da başka bir donanımla girdiği
girdileri kontrol ediyor ve oyunun her karesinde oyun değişkenlerini değiştiriyoruz.
)

$(MINIBASLIK Çiz :
)  
$(P
Burada oyunumuza grafik kartına ne gönderileceğini ve ekrana nasıl
çizileceğini söylüyoruz
)

$(ALTBASLIK Bir oyuncu oluşturmak)

$(P
Ekranda bir görüntü oluşabilmesi için çeşitli bilgileri saklamalıyız. Bir
oyuncunun konumu buna iyi bir örnek olabilir.
)

$(P Şimdi kağıt üzerinde bir oyuncu oluşturmak için neler yapmamız gerektiğini düşünelim. Bunları kağıda yazın <img src="$(ROOT_DIR)/image/gulen.png" /> 
)
  
$(P İlklendir bölümüne oyuncumuzun ekran üzerinde başlangıç konumunu belirleyen bir işlev ekleyelim.
)
  
$(MINIBASLIK
İlklendir
)


---
        oyuncuKonumunuBelirle()
---

$(P
Şimdi teknik olarak oyuncumuz mevcut. Oyunun $(C ilklendir()) metodunda
sağladığımız bilgilerle artık oyun karakterimizi istediğimiz yere hareket
ettirebiliriz. 
)

$(P Ama ekranda bir şey göremezsek bu iyi bir oyun sayılmaz <img src="$(ROOT_DIR)/image/gulen.png" />
)

$(P Ekrana bir şeyler çizebilmek için ilkönce çizeceğimiz
animasyonu ya da grafiği yüklemeliyiz.
)

  
$(MINIBASLIK
İçerik Yükle
)

---
       içerik.yükle(dosya)
---
$(P
Daha sonra oyunumuzu ekran kartının belleğinde çiziyoruz.
)

$(MINIBASLIK
Çiz
)

---
        oyuncuyu.çiz()
---

$(P
Oldukça basit. Peki oyunun içinde sürekli değişiklikler olmasını istersek
ne yapmamız lazım.
)

$(P Burada işte $(C güncelle()) metodu karşımıza çıkıyor. Güncelle
metodunu kullanarak ilk değerlerini verdiğimiz oyun değişkenlerini istediğimiz gibi
değiştirebiliyoruz. Güncelle metoduna bazı kodlar ekleyerek oyun içinde
tutulan istediğimiz bilgiyi değiştirebiliriz.
)

$(MINIBASLIK
Güncelle
)

---
        if (sağTuşBasılıMı)
           konumuGüncelle & animasyonuGüncelle
---

$(P
Örneğin klavyenin sağ tuşuna basınca oyun karakterimizin sağa doğru hareket
etmesini istiyorsak $(C güncelle()) metodunda sağ tuşun basılı olup
olmadığını denetliyoruz ve animasyonu güncelliyoruz. 
)

$(P Burada $(C animasyonuGüncelle()) kısmına sağa doğru
yürüyen bir oyuncu animasyonu koyabiliriz.
)


$(ALTBASLIK oyuncu.d dosyasının içinde)
$(P
Artık oyunumuzu kodlamaya başlayabiliriz.
)

$(P
İlkönce daha önce indirmiş olduğunuz proje dosyalarını bir sıkıştırma programı ile
açıp $(HILITE test) klasörünün içine gelin. Burada herhangi bir
editörle $(COMMENT oyuncu.d) isminde yeni bir dosya oluşturun. Ve içine şunları girin.
)

---
import sdl, vector2, cizici;

class Oyuncu
{
    // ilklendir
    this(Grafik2D grafik, Vector2 konum)
    {
    }

    void güncelle()
    {
    }

    void çiz(Çizici çizici)
    {

    }
}
---
$(P
Dikkat ederseniz biraz önce oyun döngüsünde bahsettiğimiz
  işlevlerin bazılarını $(B Oyuncu) sınıfımız için de yazmış olduk.
  <img src="$(ROOT_DIR)/image/gulen.png" />
)

$(P D derslerinden hatırlayacağınız gibi $(C this())
sınıfın kurucu işlevi ve sınıf üyelerine ilk değer ataması
burada gerçekleşiyor. D'nin böyle bir özelliği olduğu için
ekstradan bir $(C ilklendir()) işlevi yazmamıza gerek yok.
$(B Oyuncu) sınıfının değişkenlerine ilk değer atamasını
burada yapabiliriz.
)

$(P
Şimdi düşünelim. Bir oyun karakterinin ne gibi özellikleri
olmalı?
)


$(P
Herşeyden önce ekrana çizebileceğimiz bir 2D grafiğe ya da bir
animasyona sahip olmalı. Ayrıca konumunu belirten koordinatlara sahip
olmalı. 
)

$(P
İşte $(B Oyuncu) sınıfımız bu yüzden parametre olarak bir 2 boyutlu
grafik ve konum bilgisi alıyor. Burada şimdilik $(B Vector2) nin
ekran üzerinde bir oyun nesnesinin x ve y koordinatlarını tutan basit
bir yapı olduğunu bilmeniz yeterli.
)

$(P
Örneğin:
)
---
        auto oyuncuKonum = Vector2(6, 6);
---
$(P
  diyerek aşağıdaki $(I Calvin and Hobbes) çizgi romanının sevimli karakteri
$(I Hobbes)'un konumunu bir $(B Vector2) yapısında tutabiliriz.
)
$(P
<img src="$(ROOT_DIR)/image/sdlkoordinat.png" width="550"/>
)

$(P
  Burada hemen farkedebileceğiniz bir şey $(HILITE SDL'in  y ekseni alıştığımız koordinat
sisteminin tersine aşağı doğru bakıyor.) 
)
$(P
Ayrıca koordinat merkezi olarak oyuncu grafiğinin sol üst köşesini alıyoruz. (resimdeki kırmızı nokta ile işaretlenmiş kısım) 
)

$(P
$(C class Oyuncu)'nun altındaki ilk { den sonra bunları girin.
)
---
    // her oyuncunun bir 2D grafiği olmalı
    Grafik2D oyuncuGrafik;

    // oyuncunun ekranın sol üst köşesine göre göreceli konumu
    Vector2 konum;

    // oyuncunun durum
    bool aktif;

    // oyuncunun sağlık puanı
    int sağlık;

    // oyuncunun genişliği ve yüksekliği
    int genişlik;
    int yükseklik;
---

$(P
  $(B Vector2) yapısıyla bir nesnenin konumunun x ve y koordinatlarını tutabileceğimizi söylemiştik.
$(B Grafik2D) ise grafik bilgisini
tutan ve ekrana çizilebilen özel bir veri türü.
)

$(P
Oyuncumuzu çizdireceğimiz zaman oyuncuya ait $(B Grafik2D) iki boyutlu grafiğini
$(B Vector2) ile belirtilen konuma çizdireceğiz.
)

$(P
Şimdi yapmamız gereken oyuncunun ilk konumunu belirtmek ve oyuncuya ait
grafiğe bir ilk değer vermek.
)

$(P
$(B Oyuncu) sınıfının kurucu işlevini aşağıdaki gibi değiştirin.
)

---
    this(Grafik2D grafik, Vector2 konum)
    {
        oyuncuGrafik = grafik;

        // oyuncunun başlangıç konumu belirle
        this.konum = konum;

        // oyuncuyu aktif yapıyoruz
        aktif = true;

        // oyuncunun sağlık puanını belirle
        sağlık = 100;

        // her grafik nesnesinin bir w (genişlik) ve h (yükseklik) değeri
        // olduğu için oyuncumuzun genişlik ve yükseklik değerlerine bu
        // değerleri atayabiliriz
        genişlik = grafik.w;
        yükseklik = grafik.h;
    }
---

$(P
Oyuncumuzun ihtiyaç duyduğu ilk değerleri verdikten sonra artık oyuncuyu
çizdirebiliriz. Bunu da oyuncunun çiz yöntemine bir $(B Çizici)
  nesnesi geçerek yapıyoruz.)
$(P $(B Çizici) nesnesinin yaptığı kendine geçilen bir
iki boyutlu grafiği ekranın belirli bir konumuna çizdirmek. $(B Çizici)
sınıfının ayrıntıların merak ediyorsanız $(HILITE src) klasöründe bulan $(COMMENT cizici.d)
modülünü inceleyebilirsiniz.
)

$(P
Oyuncu sınıfının $(C çiz) işlevini aşağıdaki gibi değiştirin.
)

---
    void çiz(Çizici çizici)
    {
        çizici.çiz(oyuncuGrafik, konum);
    }
---

$(P
  $(B Oyuncu) sınıfıyla şimdilik işimiz bitti.
)

$(ALTBASLIK oyun.d dosyasının içinde)

$(P
  $(HILITE test) klasöründeki $(COMMENT oyun.d) dosyasını açın.
)
$(P
Kod içinde $(B Oyun) sınıfını bulduktan sonra $(C class Oyun : TemelOyun) un hemen altına {
dan sonra oyuncuyu ekleyin.
)
---
    Oyuncu oyuncu;
---
$(P
Oyuncuyu ekrana çizebilmek için önce oyuncuya ait grafiği yüklemeli
ve oyuncunun ilk konumunu belirlemeliyiz.)
  
$(P Sabitdisk üzerinde bulunan grafikleri okuyup oyuna yükleyeceğimiz için
bunları $(C içerikYükle()) metodunun hemen altında yapabiliriz.)
  
$(P $(C super.içerikYükle()) nin altına bu kodu ekleyin.
)
---
        // oyuncuya ait içeriği yükle
        auto oyuncuKonum = Vector2(288, 203);
        oyuncu = new Oyuncu(içerik.yükle("penguen.bmp"), oyuncuKonum);
---
$(P
Burada $(C içerik.yükle) kısmı dikkatinizi çekmiş olabilir. Oyunumuzun içerik
isimli bir yapısı var. Bir grafiği yüklemek için bu yapıya yüklemek istediğiniz
2D grafiğin ismini vermeniz yeterli.
)
$(P
$(C içerik.yükle()) işlevi bir $(B Grafik2D) döndürüyor. Ayrıca $(B Oyuncu) sınıfının
kurucu işlevi de parametre olarak bir 2D grafik ve oyuncunun konumunu belirten bir vektör alıyordu.

)
$(P
Oyuncuyu ekrana çizmeye hazırız. Oyun sınıfının $(C çiz) işlevine bu
kodu ekleyin.
)
---
        /// Nesneleri göster
        // oyuncuyu çiz
        oyuncu.çiz(çizici);
---
$(P
İşte bu kadar. Artık çizme bölümü de tamamlanmış oldu.
)

$(ALTBASLIK Oyunu çalıştırmak)

$(P
Programın kaynak kodunu derlemek için şu komutları girin:
)
$(P
Ubuntu altında konsoldan:
)

$(SHELL

$ make ornek
$ cd bin
$ ./ornek
)

$(P
Windows altında $(I Başlat->Çalıştır->) yolunu izleyerek buraya $(COMMENT cmd) yazın. Açılan konsolda:
)

$(SHELL
make ornek -f win32.mak
cd bin
ornek.exe
)


$(P
Eğer her şey yolunda gittiyse ekranınınızda sevimli bir penguen görmeniz
lazım <img src="$(ROOT_DIR)/image/gulen.png" />
)


<div align="center">
<img src="$(ROOT_DIR)/image/penguen.png" width="550"/></div>

$(ALTBASLIK Dersin kaynak kodu)

$(P
Programı derlerken herhangi bir sorun çıktıysa merak etmeyin. Dersin kaynak
kodunu <a href="$(KODLAR)/ders1.zip">buradan</a> indirebilirsiniz.
)

$(ALTBASLIK Uzman ipucu)
$(P
Yazının başında da belirttiğim gibi SDL ile ilgili konuları bu bölümde
anlatacağım. Bu yüzden bu bölümü okuyup okumamak sizin
zevkinize kalmış <img src="$(ROOT_DIR)/image/gulen.png" />
)

$(P
Amacımız ekranın arkaplan rengini değiştirmek.
$(B TemelOyun) sınıfı içinde $(COMMENT //Ekranı temizle)
                                 yazan kısmın hemen altına gelin.
)
$(IX SDL_FillRect)
$(IX SDL_MapRGB)
---
        SDL_FillRect(ekran, &ekran.clip_rect,
                     SDL_MapRGB(ekran.format, 0x00, 0x00, 0xFF));   
---

$(P
Burada $(C SDL_MapRGB) işlevinin aldığı ilk parametre $(I piksellerin biçimi),
ikincisi de rengi oluşturan $(HILITE r g b) değerleri.
Yani $(I kırmızı yeşil mavi) değerleri. İşlevin kendisi de bir $(c uint) tamsayı
döndürüyor.Yani bu kırmızı yeşil mavi değerlerinin birleşimi olan renk değerini
SDL'de bir $(c uint) işaretsiz tamsayı ile ifade edebiliyoruz. 
)

$(P
Eğer Gimp, Photoshop gibi çizim programları kullandıysanız renklerin
karşılıklarının 0 ile 255 arasında değişen $(I RGB) değerler ile ifade
edildiğini hatırlayacaksınız. Örneğin $(HILITE RGB(255, 0, 0)) kırmızı gibi.  
)

$(P
Biz de bu renk değeri kullanarak ekranı temizle işlevini, ekranı maviye
boyayacak şekilde değiştireceğiz. Burada sizin de farketmiş olabileceğiniz
gibi bu değerler onaltılık sayı sisteminde $(HILITE 0x) şeklinde yazılmış.
Bu yüzden ekranı maviye boyamak için ikinci renk değerini
$(HILITE 0xFF) olarak değiştirin.
)

$(P
Programı tekrar derlediğinizde artık ekranın maviye boyandığını göreceksiniz.
)

Macros:
        SUBTITLE=SDL'e Hoşgeldiniz

        DESCRIPTION=İlk SDL Programınız

        KEYWORDS=d programlama dili ile görsel programlama sdl öğrenmek tutorial

