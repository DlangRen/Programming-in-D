Ddoc

$(H4 DUB ile Tanışalım)

$(P
  $(B Yazar:) $(LINK2 mailto:zafercelenk@gmail.com, Zafer Çelenk)
$(BR)
  $(B Tarih:) 28 Mart 2016
)

$(P
Program geliştirme sürecinde artarak çoğalan kodların, gerekli işlemlerden sonra çalıştırılıp çıktılarının gözlemlenmesi temel bir ihtiyaçtır. Bu süreç bir programcının programını geliştirmesi esnasında en çok tekrarladığı döngüdür. Bu döngü PHP, Python gibi dillerde sadece yaz-çalıştır şeklinde olmakla birlikte C++ ve D gibi derleyici ile kullanılan dillerde önce yaz sonra derle ve sonra çalıştır şeklinde üç adımdan oluşmaktadır. Zaman içinde geliştiriciler bu süreci daha kolay hale getirmek için yollar aramış ve programlamanın ilk zamanlarında $(C makefile)$(DIPNOT 1) komut dosyalarını kullanarak bu soruna bir çözüm getirmeye çalışmışlardır. Bu çözümde geliştirme sürecinde yazdığınız komutların çalışması için gerekli olan işlemler belli bir düzene göre oluşturulan $(C makefile) isimli dosyalara yazılır. Ardından $(C make)$(DIPNOT 1) isimli bir program ile bu dosya çalıştırılır ve programın sonucunu gözlemleyebilirsiniz.
)

$(P
Zamanla bilgisayarlar komut satırından görsel arayüzlere doğru geçip, tümleşik geliştirme sistemleri (IDE) ortaya çıkmaya başlayınca $(C makefile) yerine geliştirme ortamları bu işleri tek bir fonksiyon tuşu veya klavye kısayolu ile yapmaya başladı. İlk zamanlarda bu yeterli olsa da zamanla giderek artan hazır kod kütüphaneleri kullanılmaya başlandıkça programların çevreye bağımlılığı daha da artmaya başladı. Özellikle açık kaynak dünyasında ortaya çıkan ve herkesin özgürce kullanabilmesini sağlamak için genel kamu lisansı (GPL)$(DIPNOT 2) altında dağıtılan kütüphaneleri programlarımıza otomatik olarak eklemek ve onların da başka bağımlılıklarını yönetmek görsel arayüze sahip IDE’ler ile çok kolay olmuyordu. Bu durum geliştiricilerin yeniden komut satırının otomasyon gücüne yönelmelerine neden oldu.
)

$(P
Bunun üzerine yıllar önce geliştirilen $(C make) programının çok daha becerikli ve gelişmiş özelliklerle donatılmış yeni arkadaşları birer birer ortaya çıkmaya başladı. Örneğin Java dilinde çalışanlar için $(C ant) ve $(C maven) gibi araçlar öne çıkarken, C++ için $(C cpm), Python için $(C pip), hatta çok iyi bir IDE'ye sahip olan C# için $(C nuget) gibi araçlar bir anda oldukça popüler oldu. Bu araçlar yardımıyla sadece bir kaç komut kullanarak paket deposunda bulunan herhangi bir paketi bilgisayarınıza indirip projenize entegre edebiliyor ve çoğu zaman fazladan bir takım ayarlamalar yapmanıza gerek kalmadan kullanmaya başlayabiliyorsunuz.
)

$(P
Bu kısa tarihçeden sonra D dili için geliştirilmiş proje ve paket yönetim programı olan DUB$(DIPNOT 3) hakkında konuşmaya başlayabiliriz. DUB özellikle komut satırından projelerini yönetmeyi seven yazılımcılar için oldukça faydalı bir programdır ancak IDE üzerinde çalışan geliştiriciler tarafından da oldukça kullanışlı bulunacak yönleri vardır. Halen geliştirilme aşamasında olmakla beraber, bir çok özelliği ile kullanıma uygun ve gayet iyi çalışan bir programdır. DUB programının kurulumuna geçmeden önce ulaşabileceğiniz kaynakları sizinle paylaşmak istiyorum.
)

$(P
DUB projesi de diğer D projeleri (Phobos vs.) gibi açık kaynak kodlu ve kodlara herkesin ulaşabileceği bir şekilde $(LINK2 https://github.com/D-Programming-Language/dub, Github üzerinde geliştiriliyor). DUB programına resmi D dili sayfasından ulaşmanız da mümkün. Bunun dışında DUB kullanarak projelerinize ekleyebileceğiniz bir çok pakete $(LINK2 http://code.dlang.org, D paket deposu) üzerinden ulaşabilirsiniz. Bu paket deposu DUB ile projenize dahil edebileceğiniz paketleri gayet güzel bir şekilde kategori bazlı olarak ayırıp sizin kullanımınıza sunuyor.
)

$(P
DUB programının kurulumu oldukça kolay; $(LINK2 http://code.dlang.org/download, indirme bölümünden) kullandığınız sisteme göre uygun olan kurulum dosyasını indirip program kurulumunu otomatik olarak yapabilirsiniz. Dikkat etmeniz gereken nokta, DUB sadece bir yönetim programı. Eğer D programları derlemek istiyorsanız sisteminizde bir de $(C dmd) gibi bir D derleyicisi kurulu olmalı.
)

$(P
Kurulumdan sonra DUB artık kullanıma hazırdır. Temel DUB kullanımı için üç komutu bilmeniz yeterli, bu komutlardan birincisi yeni bir proje şablonu hazırlamanızı sağlayan $(C init) komutudur. Bu komutu kullanarak yeni bir proje oluşturabilirsiniz. Bunun için projenizi oluşturacağınız klasöre geçip komut satırından şu komutu vermelisiniz.
)

$(SHELL
$ dub init projem
)

$(P
Bu komuttan sonra DUB sizin için $(C projem) isimli bir klasör ve bu klasörün içine temel dosyalardan oluşan bir proje şablonu oluşturacaktır. Hiçbir değişiklik yapmadan oluşan bu projeyi çalıştırıp çıktısını ekranda görebilirsiniz. Bunun için aşağıdaki komutu vermelisiniz.
)

$(SHELL
$ dub run
)

$(P
Bu komutu bulunduğunuz proje klasörü içinde çalıştırdığınızda önce projeniz derlenir ve herhangi bir hata yoksa proje çalıştırılır. Projeniz eğer bir konsol projesi ise çıktısını ekranda görebilirsiniz. Bizim bu projemiz bir konsol projesi olduğu için bu komuttan sonra ekranda çıktısını görebiliriz. Bendeki çıktı şu şekilde:
)

$(SHELL
$ dub run
Performing "debug" build using dmd for x64.
projem ~master: building configuration "application"...
Linking...
Running ./projem
Edit source/app.d to start your project.
)

$(P
Ayrıca komut satırına doğrudan $(C dub) yazarsanız ön tanımlı olarak yine $(C dub run) komutu işletilir. $(C run) komutunun çıktısına baktığımızda ilk satırda DUB'un projemizi derlemek için kullandığı derleyici bilgisini görmekteyiz, ikinci satırda ise derleme ayarları için $(C application) isimli bir ayar setini kullandığı görünüyor. Derleme işleminden herhangi bir hata alınmadığı için üçüncü satırda bağlama işlemine geçtiğini görüyoruz ve son satırda DUB oluşan programı çalıştırarak görevini tamamlıyor.
)

$(P
Bunun dışında bazen programı doğrudan çalıştırmak yerine bir derleme işlemi yaparak her şeyin yolunda olup olmadığını görmek isteyebilirsiniz. Bunun için DUB'a vermeniz gereken komut şöyle olmalıdır.
)

$(SHELL
$ dub build
)

$(P
Bu komutu verdiğinizde DUB projenizi sadece derler ve eğer herhangi bir hata yoksa bağlama (Linking) işlemini yapmadan süreci sonlandırır.
)

$(P
Bu yazımda kısaca proje ve paket yönetim sistemlerinin tarihçesini ve D için geliştirilen DUB yönetim programını anlatmaya çalıştım. Bununla beraber DUB programının kurulumu ve temel kullanımı hakkında bazı bilgiler verdim. DUB hızlı, pratik ve kolay bir şekilde D projelerinizi yapılandırmayı ve ihtiyaç duyduğunuz kütüphaneleri kolay bir şekilde projenize eklemeyi vaat ediyor ve bana kalırsa bunu da gayet iyi yapıyor. Paket kurulumu ile ilgili örnekleri bir sonraki yazımda göstereceğim.
)

$(P
Bununla beraber projenizde DUB altyapısının kullanımı, hem ileride projenize yeni katılacak kişilerin kurulum ve ilk başlama maliyetlerini en aza indiriyor hem de projenizin farklı geliştiricilere dağıtılabilmesini ve yeniden yapılandırma sürecini çok kolaylaştırıyor. Kısaca deneyin, seveceğinizi düşünüyorum. ;$(PARANTEZ_KAPA). Yazı hakkındaki sorularınızı $(LINK2 http://ddili.org/forum, forum bölümünde) sorabilirsiniz.
)

$(P
Zafer ($(LINK2 mailto:zafercelenk@gmail.com, zafercelenk@gmail.com)).
)

<span style="font-size:.9em">

$(H5 Referanslar)

$(OL

<a name="dipnot1"></a>

$(LI
$(LINK2 http://e-bergi.com/y/Make-makefile, E-Bergi - Dosya İşlemleri Otomasyonu)
)

<a name="dipnot2"></a>

$(LI
$(LINK2 https://tr.wikipedia.org/wiki/GNU_Genel_Kamu_Lisansı, GNU Genel Kamu Lisansı)
)

<a name="dipnot3"></a>

$(LI
$(LINK2 http://code.dlang.org/download, DUB - The D package registry)
)

$(LI
$(LINK2 https://github.com/D-Programming-Language/dub, Github üzerinde DUB projesi)
)

$(LI
$(LINK2 http://code.dlang.org/download, DUB programının indirme sayfası)
)

)

</span>

Macros:
        SUBTITLE="D Dilindeki Tipleri Anlamak", Zafer Çelenk

        DESCRIPTION=Zafer Çelenk'in D'nin temel tiplerini tanıttığı yazısı.

        KEYWORDS=d programlama dili makale d zafer çelenk tip tür

DIPNOT=$(LINK2 #dipnot$1, $(SUP $1))
