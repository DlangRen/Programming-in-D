Ddoc

$(DERS_BOLUMU Oyunlarda hareket)

$(P
Bu derste oyunlarda hareket konusu inceleyeceğiz. Daha önceki dersimizde vektörler
için bir oyun nesnesinin konum bilgilerini tutan basit bir yapı olduğunu bilmeniz
yeterli demiştik. Bu derste vektörler konusunda temel bazı bilgiler öğreneceğiz.
)

$(ALTBASLIK $(IX lineer cebir) Lineer cebir nedir)

$(P
Lineer cebir vektörleri inceleyen matematik koludur. Eğer oyunumuzda bir yarış
arabasının hızı, kameranın yönü gibi bilgilere ihtiyacımız varsa vektörleri
kullanmak durumundayız.
)

$(P
Lineer cebiri daha iyi anladığınız takdirde vektörlerin davranışları üzerinde
daha fazla kontrol sahibi olabilirsiniz.
)

$(ALTBASLIK $(IX vektör) Vektör nedir?)

$(P Oyunlarda vektörler konum, yön ve hız bilgisi tutarlar. İşte size iki
boyutlu örnekler)

$(P
<img src="$(ROOT_DIR)/image/vektorler1.png" width="550" />
)

$(P Konum vektörü Sonic oyun karakterinin merkezden 3 metre doğuda
ve 4 metre güneyde durduğunu gösteriyor. Hız vektörü dakikada uçağın 2
kilometre yukarı ve 3 kilometre sağa hareket ettiğini gösteriyor. Yön vektörü
geminin sola doğru işaret ettiğini gösteriyor)

$(P Sizin de görebileceğiniz üzere vektörün kendisi aslında bir dizi sayıdan
oluşuyor, kullanıldığı yere göre bir anlam kazanıyor.Örneğin $(HILITE vektör (-1, 0))
şekildeki gibi bir geminin yönü olabileceği gibi, bulunduğunuz konuma 1 kilometre
uzaktaki bir binanın konumu ya da saatte 1km hızla hareket eden bir salyangozun hızı
da olabilir.)

$(P Bu yüzden vektörleri kullanırken birimlerini de belirlemek önemli. Şimdi temel
olarak vektörlerin ne olduğunu öğrendiğimize göre onları nasıl kullanacağımızı
öğrenmenin zamanı geldi)

$(ALTBASLIK Vektörlerde toplama)

$(P Vektörleri toplamak için vektörün her bileşenini ayrı ayrı toplamak gerekiyor.
Örneğin:)

$(SHELL
  (0,1,4) + (3,-2,5) = (0+3, 1-2, 4+5) = (3,-1,9)
)

$(P Peki vektörleri neden toplamak isteriz? Vektörleri toplamanın nedenlerinden
bir tanesi fizik entegrasyonunu yapabilmek içindir. Oyun içinde her fiziksel nesne
konum, hız, ivme gibi bilgileri tutabilmek için vektörleri kullanacaktır. Oyunun
her karesinde (genellikle saniyenin 1/60'ı kadar bir sürede) hızı konuma ve ivmeyi
hıza eklemeliyiz.)

<img src="$(ROOT_DIR)/image/vektorler2.png" width="550" />

$(P Burada gene SDL'in koordinat sistemine göre düşünüyoruz. Yani y ekseni aşağı
doğru bakıyor. Yukarıya hareket etmek demek y değerinin azalması demek) 

$(P Aslında Maryo ekranın altında durduğuna göre, konumu (0, 480) gibi bir değer
olmalı (Ekran çözünürlüğümüzün 640x480 olduğunu varsayarsak) Ama biz hesaplamalarda
kolaylık olsun diye bulunduğu konumu (0, 0) noktası kabul edeceğiz)

$(P İlk karede hızını (1, -3) konumuna (0, 0) ekleyerek yeni konumunu (1, -3)
buluyoruz. Daha sonra ivmesini (0, 1) hıza (1, -3) ekleyerek yeni hızını (1, -2)
buluyoruz)

$(P
İkinci karede de aynısını yapıyoruz. Hızını (1, -2) konuma (1, -3) ekleyerek
yeni konumu (2, -5) buluyoruz. Daha sonra ivmeyi (0, 1) hıza (1, -2) ekleyerek
yeni hızı (1, -1) olarak buluyoruz.
)

$(P
Genellikle oyunlarda oyuncu karakterin ivmesini klavye veya oyun çubuğu kullanarak
kontrol eder, oyun da yeni hız ve konum bilgilerini vektörleri toplayarak
hesaplar)

$(ALTBASLIK Vektörlerde çıkartma)
$(P
Vektörlerde çıkartmayı da toplamaya benzer şekilde yapıyoruz. Vektörlerin çıkartarak
bir konumdan bir diğer konumu işaret eden bir vektör buluyoruz. Örneğin oyuncumuz
(1, 2) konumunda elinde bir lazer silahı ile duruyor ve düşman robotu (4, 3)
noktasında olsun. Lazerin oyuncuyu vurabilmek için katetmesi gereken mesafeyi
gösteren vektörü oyuncunun konumunu robotun konumundan çıkararak bulabilirsiniz.
$(SHELL
(4,3)-(1,2) = (4-1, 3-2) = (3,1)
)
)
<img src="$(ROOT_DIR)/image/vektorler3.png" width="550" />

$(ALTBASLIK Skaler vektör çarpımı)
$(P
Vektörler söz konusu olduğunda skaler derken vektörü oluşturan her sayıya skaler
diyoruz. Örneğin (3,4) bir vektörken, 5 skaler. Oyunlarda bir vektörü bir skalerle
çarpabilmek oldukça işimize yarayacak. Örneğin oyuncu hareket ederken oyuna daha
gerçeklik katmak için oyuncunun hızına karşı gösterilen hava direncini
hesaplayabiliriz. Bunu da oyuncunun hızını her karede 0.9 ile çarparak buluruz.
Bunu yapmak için vektörün her bileşenini skaler ile çarpıyoruz. Eğer oyuncunun
hızı (10,20) ise yeni hızı şu şekilde bulabiliriz:
$(SHELL
0.9*(10,20) = (0.9*10, 0.9*20) = (9,18)
)
)

$(ALTBASLIK Kodlamaya başlayalım)
$(P
Bu dersimize önceki derste kodladığımız kod üzerinde çok az değişiklik yaparak
devam edeceğiz. Eğer daha önceki dersi kodladıysanız o dersin üzerinde değişiklikler
yaparak devam edebilirsiniz. Eğer kodlamadıysanız <a href="$(KODLAR)/ders1.zip">buradan</a> sıkıştırılmış dosyayı indirerek projenin ana dizininde açmanız yeterli. Bir önceki dersin kaynak kodlarını içeren $(HILITE test) isminde bir dizin
oluşacak.
)

$(ALTBASLIK oyun.d dosyasının içinde)
$(P $(C class TemelOyun)'un üzerinde bunları girin)

---
class Top : Oyuncu
{
    this(Grafik2D grafik, Vector2 konum)
    {
        // Oyuncu sınıfının kurucu işlevini çağırıyoruz
        super(grafik, konum);
    }
}
---
$(P Burada yaptığımız hiç bir şey yok aslında. $(B Top) sınıfını
$(B Oyuncu) sınıfından türetiyoruz. $(B Top) sınıfının kurucu işlevinde de
devraldığımız $(Oyuncu) sınıfın kurucu işlevini çağırıyoruz.)

$(P Bilgilerinizi tazelemek için türeme ile ilgili dershanedeki
<a href="http://ddili.org/ders/d/tureme.html">bu dersi</a>
tekrar gözden geçirmek isteyebilirsiniz)

$(P class Oyun: TemelOyun'un altındaki ilk { den sonra Oyuncu oyuncu kısmını
aşağıdaki gibi değiştirin)

---
    Top top;
    Vector2 topHızı;
---

$(P Oyun sınıfının içerikYükle() işlevini aşağıdaki gibi değiştirin)

---
        super.içerikYükle();

        // oyuncuya ait içeriği yükle
        auto topkonum = Vector2(0, 0);
        top = new Top(içerik.yükle("top.png", true), topkonum);
        topHızı = Vector2(2, 2);
---

$(P Burada da ilk derste öğrendiklerimiz dışında yaptığımız tek şey
içerik.yükle() işlevine geçtiğimiz ikinci parametre true saydam bir
grafik yüklemek istediğimizi belirtiyor)

$(P Oyun sınıfının çiz işlevini de artık olmayan oyuncu nesnemiz yerine
topu çizdirecek şekilde değiştirelim)

---
        /// Nesneleri göster
        // topu çiz
        top.çiz(çizici);
---

$(P Bu noktaya kadar yaptığımız basitçe penguen resmi yerine saydam bir
top grafiği yüklemekti. Herhangi bir hata yapıp yapmadığınızı test etmek için
Ubuntu altında şu komutları vermeniz yeterli)

$(SHELL
$ make ornek
$ cd bin
$ ./ornek
)

$(ALTBASLIK Topu hareket ettirmek)

$(P Oyun sınıfının güncelle() işlevinin en sonuna $(COMMENT // Oyun mantığı)
yazan kısmın hemen altına topun güncellenme işlevini ekleyelim.)
---
        // Oyun mantığı
        topuGüncelle();
---
$(P Bu işlevin hemen altındaki } parantezinden sonra topun güncellenme işlevini
ekleyelim)

$(IX yansıtma)

---
    private void topuGüncelle()
    {
        top.konum += topHızı;

        // alta mı geldik
        if (top.konum.y + top.yükseklik >= ekranyükseklik)
            // alta geldiysek hızı y ekseninde yansıtmamız yeterli
            topHızı.yansıt(Vector2(0, 1));

        // sağa mı geldik
        if (top.konum.x + top.genişlik >= ekrangenişlik)
            // sağa geldiysek hızı x ekseninde yansıtmamız yeterli
            topHızı.yansıt(Vector2(1, 0));

        // üste mi geldik
        if (top.konum.y <= 0)
            // üste geldiysek hızı y ekseninde yansıtıyoruz
            topHızı.yansıt(Vector2(0, 1));

        // sola mı geldik
        if (top.konum.x <= 0)
            // sola geldiysek hızı x ekseninde yansıtıyoruz
            topHızı.yansıt(Vector2(1, 0));
    }
---

$(P Daha önce oyunun her karesinde hızı konuma ekliyoruz demiştik. İşte topun
güncelle metodunda bunu yapıyoruz. Topun ilk konumu (0,0) noktasıydı. Oyun
başladığında top sağa ve aşağı doğru hareket edecek)

$(P Alta gelip gelmediğimizi topun y konumunu, topun yüksekliğine ekleyerek
hesaplayabiliriz. Eğer bu değer ekranyüksekliğine büyük ya da eşitse topu y
ekseninde yansıtıyoruz. Top alt tarafa hem sağdan hem de soldan yaklaşabilir)

$(P Şimdi işin en püf noktasına geldik. Bir vektörü yansıtmak ne demek)

<img src="$(ROOT_DIR)/image/vektorler4.png" width="550" />

$(P Şekilde yeşil renkli vektörü y ekseni üzerinde yansıttığımız zaman elde
ettiğimiz vektör turuncu renkte olan vektör. yansıt işlevine geçtiğimiz
  Vector2(0, 1) parametresi vektörü y ekseninde yansıtmak istediğimizi belirtiyor.)
$(P Bu vektörün uzunluğunun bir birim olduğunu kolayca görebiliriz. Uzunluğu bir birim olan vektörlere birim vektör deniliyor. Dikkat ederseniz topun sağdan ya da soldan
gelse de y ekseninde yansıttığımızda istediğimiz hareketi elde edebiliyoruz)

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
Eğer her şey yolunda gittiyse ekranınınızda sağa sola hareket eden bir top görmeniz
lazım. Mutlu kodlamalar! <img src="$(ROOT_DIR)/image/gulen.png" />
)


<div align="center">
<img src="$(ROOT_DIR)/image/oyunlardahareket.png" width="550"/></div>

Macros:
SUBTITLE=Oyunlarda Hareket

DESCRIPTION=Oyunlarda hareket

KEYWORDS=d programlama dili ile görsel programlama sdl öğrenmek tutorial


