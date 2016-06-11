Ddoc

$(H4 Eleman Erişimi Üzerine)

$(P
  $(B Yazar:) $(LINK2 http://erdani.org, Andrei Alexandrescu)
$(BR)
  $(B Çevirmen:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Çeviri Tarihi:) Ocak 2011
)

$(H5 Çevirmenin Notu)

$(P
Bu yazının konusu İngilizce kaynaklarda "iteration" olarak geçer ve aslında iki işlemi kapsar:
)

$(UL
$(LI topluluk elemanlarına erişmek)
$(LI topluluğun başka elemanlarına geçmek)
)
$(P
İngilizce kaynaklar bu iki işlem arasından "ilerleme"yi öne çıkartan "iterate" sözcüğünü kullandıkları halde ben daha önceki yazılarımla ve çevirilerimle uyumlu olabilmek için "iteration"ın karşılığı olarak "erişme", "iterator"ın karşılığı olarak da "erişici" sözcüklerini kullandım.
)

$(P
Türkçeleştirdiğim bazı terimlerin İngilizce asıllarını parantezler içinde gri olarak ekledim.
)

$(P
Anlaşılmalarını kolaylaştırmak için kod örneklerini de Türkçeleştirdim, ama arayüzleri belirleyen işlevlerin isimlerini İngilizce olarak bırakmaya karar verdim; o işlevlerin Türkçelerini ise kod açıklamaları olarak belirttim.
)

$(HR)


$(H5 Özet)

$(P
İleriye doğru erişme kavramının öncülüğünü Lisp'in tekli bağlı listeleri yapmıştır. Ondan sonra gelen nesne yönelimli topluluk tasarımları, elemanlara sıra ile art arda erişilmesini $(ASIL sequential access) Iterator tasarım örüntüsüyle $(ASIL design pattern) ve erişiciler aracılığıyla sunmuşlardır. Erişiciler her ne kadar güvenli ve mantıklı olsalar da; arayüzleri, topluluklardan bağımsız algoritmaların esnek, genel, ve etkin olarak yazılabilmelerine engel olur. Örneğin bir topluluğu sıralama, ikili yığın $(ASIL binary heap) olarak düzenleme, hatta tersine çevirme gibi işlemlerin yalnızca o topluluğun Iterator türü ile sağlanması beklenemez. Hemen hemen aynı dönemlerde C++'nın $(I Standard Template Library)'si (STL) kendi erişici sıradüzenini tanımlamış ve topluluklardan bağımsız algoritmaların o sıradüzen aracılığıyla gerçekleştirilebileceklerini göstermiştir. Ancak; STL erişicilerinin güvenlikten yoksunluk, kullanım güçlüğü, tanım güçlüğü, ve C++ diline fazla bağlı olma gibi sakıncaları vardır. Bu sakıncalar, onların başka diller tarafından benimsenmelerini kısıtlamıştır. Ben; Iterator örüntüsünün ve STL'nin üstünlüklerini bir araya getiren bir arayüz öneriyorum ve STL'deki algoritmaları da kapsayan bu soyutlamaları D dilinde gerçekleştirerek bu arayüzün mantıklı olduğunun kanıtlarını sunuyorum.
)

$(P
Standard Template Library'ye, Iterator tasarım örüntüsüne, veya fonksiyonel dillere yabancı olanları dışlamış olmamak için bu makale biraz uzunca oldu.
)

$(H5 Giriş)

$(P
Bu makale, $(I ilerleme) işlemine taze bir bakış açısı getirir. İlerlemenin günümüz dillerindeki durumunu tartışacağım, ve salt ileri yönde ilerlemenin genel algoritmalar için yeterli olmadığı fikrini tekrar ortaya koyacağım (bu fikir Alexander Stepanov'a aittir [13]). Daha sonra, ilerleme kavramına, başka dillerde ve kütüphanelerde bulunan soyutlamalar üzerine kurulu olan yeni bir yaklaşım önereceğim. Önerdiğim düzenek hem mantıklı ve ifade gücüne sahip, hem de basit ve şimdiye kadar farkedilmediği halde barizdir.
)

$(P
D'nin standart kütüphanesi için algoritmalar yazmaya başladığımda, önce C++'nın STL'sini örnek almıştım. STL, temel bazı sorulara çarpıcı yanıtlar getirir; bu yüzden benim STL'yi seçme kararım çok kolay olmuştu. Ama ilk gerçekleştirmem umduğum gibi çıkmamıştı. Önceki bir örneğin üstüne kurulu olmasına rağmen, STL'nin D'ye taşınmış hali de neredeyse C++'daki kadar uzun ve zor kullanılır bir hale gelmişti.
)

$(P
O ilk denemeyi bir kenara bıraktım. İkinci tasarımıma STL'de olduğu gibi göstergelerden $(ASIL pointer), akımlardan, veya başka dillerde olduğu gibi tekli bağlı listelerden değil; doğrudan üst düzey kavramlardan başladım. Sonuçta ortaya çıkan taze, basit, ve güzel çözümü sizlerle paylaşma gereği duydum.
)

$(H5 İlerlemek Yetmez)

$(P
Neyi sevmem bilir misiniz? İç çamaşırlı imparatorları. Bakalım:
)

$(C_CODE
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x]
               ++ qsort (filter (>= x) xs)
)

$(P
Yukarıdakine benzer kodlar fonksiyonel dillerin üstünlüğünü gösterme amacıyla her durumda kullanılmışlardır. O kod Haskell dilinde fonksiyonel biçimde yazılmış olan, ve bazılarının inanışına göre de mevcut Haskell bilgisi gerektirmeden anlaşılabilecek olan bir quicksort gerçekleştirmesidir. İlk satır: boş listenin $(C qsort)'u boş listedir. İkinci satır (dar sütuna sığsın diye bölünmüş olarak): $(C x) ile başlayan ve ardından gelen başka $(C x)'lerin ($(C xs)) $(C qsort)'u üç listenin bileşimidir ($(C ++)): $(C xs) içinde $(C x)'ten küçük olanların sıralanmışı, $(C x)'in kendisi, ve $(C xs) içinde $(C x)'ten büyük veya ona eşit olanların sıralanmışı. Kolaysa quicksort'u kendi Üzünçlü dilinizle iki satırda yazmayı deneyin!
)

$(P
Haskell'i ne kadar beğensem de, o örnek karşısında hayranlık ve öfkeyle karışık hisler duyuyorum. C'nin değerli taraflarının, dizi dışına taşma hataları üzerine kurulu örneklerle gösterilmesi karşısında duyduğum hislerin aynısı...
)

$(P
Yukarıdaki $(C qsort) ile ilgili bir kaç yetersizlik vardır. Birincisi, $(C qsort) aslında qsort değildir. İlk defa tanıtıldığı Hoare'un makalesine [8] göre qsort, bir $(I yerel) algoritmadır. Hoare'un $(I yerel bölümleme) $(ASIL in-place partition) işlemi, makalesinin getirdiği en büyük katkı olma yanında, qsort'un da özünü oluşturur. $(C qsort) ise yerel olmadığı için olsa olsa quicksort'tan esinlenmiş bir uygulama olarak kabul edilebilir. (İyi bir uygulama olduğu da söylenemez. O kadar yan işlem kullanmaktadır ki komik olarak bile kabul edilemez—listenin iki kere ilerlenmesinin ve o birleştirmelerin bedava olduğunu mu sanıyorsunuz?) İkincisi, dayanak $(ASIL pivot) olarak ilk elemanı kullanan $(C qsort) açık olarak kötü bir seçim yapmakta ve böylece çoğunlukla sıralanmış olan verilerle karşılaştığında karesel $(ASIL quadratic) performans garanti etmektedir. Doğrusu, giriş verileri nadiren rasgeledir. Veriler örneğin daha önceden sıralanmışlardır, sonradan yeni elemanlar eklenmiştir, ve tekrar sıralanmaları gerekmiştir. Doğru çözüm, dayanak elemanını rasgele seçmektir; ama tekli bağlı listeden rasgele bir eleman seçmek hiç de küçümsenecek bir işlem olmadığı için, rasgele eleman seçmek $(C qsort)'u üç satırdan çok daha uzun hale getirir.
)

$(P
Geldik $(C qsort)'la ilgili ve bu makalenin konusunu da oluşturan üçüncü noktaya: $(C qsort) ince bir mesaj veriyor: tekli bağlı listeler ve ileri yönde ilerleme bütün ihtiyaçlarınızı karşılar. Bu doğru değildir ve böyleymiş gibi gösterilmeye çalışılmamalıdır.
)

$(P
Her durum karşısında tekli bağlı liste (S-list) kullanımını Lisp başlatmıştır. S-list'ler asıl veriden ve bir-sonraki-elemana-referans'tan oluşan çiftleri değişik biçimlerde bir araya getirirler. Üstelik S-list'ler, $(I kapalılık) $(ASIL closure) özelliğine sahip oldukları için [1] (buradaki $(I kapalılık), işlev kapamaları $(ASIL function closures) ile karıştırılmamalıdır), ne kadar karmaşık olursa olsun her veri yapısını bir $(I yönlü graf) olarak kodlayarak ifade etme yeteneğine sahiptirler. Talihsiz bir ek bilgi olmasa aslında çok da güçlü bir olanaktır—algoritma karmaşıklığı çokterimli $(ASIL polynomial) hale gelebilir.
)

$(P
Algoritmaların çokterimli yavaşlıkları gibi konular S-list'lerin gücüne gölge düşürmek için fazla sıkıcı bulunmuş olmalı ki; bazı fonksiyonel programcıların kafalarına, aslında çoğu algoritmanın özünde bulunan dizi ve eşleme tablosu $(ASIL associative array) gibi veri yapılarını hor görecek fikirler yerleştirilmiştir. Lisp ve başka fonksiyonel dillerde de diziler bulunur ama hemen hemen her durumda S-list'lere sağlanan olanaklardan mahrum ikinci sınıf vatandaş konumundadırlar. Fonksiyonel diller üzerine çok yazı okudum ve hatırı sayılır derecede fonksiyonel kod da yazdım; sonunda bir şey farkettim—bir çok tasarımcı, neden yaptıklarını hiç düşünmeden algoritmaların özünde $(I sırayla arama) $(ASIL linear search) yöntemini uyguluyorlardı. Hatta, Scheme dilini kullanan saygın programlama kitabı (benim de en sevdiklerimden olan) "Structure and Interpretation of Computer Programs" [1] arama yapılan her noktada sırayla aramayı kullanır, ve dizilerden yalnızca bir noktada ve o da kapalılığı desteklemedikleri için dikkate alınmamaları gerektiğini belirtmek için sözeder.
)

$(P
Alan Perlis'in "Lisp programcıları her şeyin değerini bilirler, hiçbir şeyin bedelini bilmezler" derken neyi düşündüğünü bilmiyorum ama benim naçizane görüşüme göre, fonksiyonel dillerin tekli bağlı listelere fazlaca bağlı olmaları ve dizileri ve eşleme tablolarını göreceli olarak göz ardı etmeleri güçlülük değil, zayıflıktır.
)

$(P
Ne yazık ki yalnızca ileri yönde ilerleyerek erişme $(ASIL forward access) kavramı nesneye yönelik programlamaya da yayılmıştır.
)

$(H5 The Gang of Four (GoF) Iterator Örüntüsü)

$(P
Iterator örüntüsü, topluluk elemanlarına erişmekte kullanılan bir arayüz tanımlar. Gang of Four'un (GoF) $(LINK2 http://www.informit.com/store/product.aspx?isbn=0201633612, Design Patterns: Elements of Reusable Object-Oriented Software) [7] kitabında tanıtılan Iterator örüntüsünün temelinde "sırayla erişme" vardır:
)

$(UL
$(LI
Bir topluluğun elemanlarına, topluluğun nasıl gerçekleştirildiğinden bağımsız olarak sırayla erişme yöntemi.
)
)

$(P
Yazarlar konunun ayrıntılarına girdikçe bu basit tanımı sırasız erişime de izin verme gibi önemli biçimlerde değiştirirler, ama bunu bir sisteme oturtmazlar:
)

---
interface Iterator
{
    void First();    // Başlat(): Erişimi tekrar başlat
    void Next();     // İlerlet(): Bir sonraki elemana geç
    bool IsDone();   // Bitti_mi(): Sonuna geldik mi?
    T CurrentItem(); // ŞimdikiEleman(): Şimdiki elemana eriş
}
---

$(P
Günümüzün nesne yönelimli kütüphanelerinin çoğu bu kalıba uyar. Bazıları $(C First) metodunun yerine başka bir $(C Iterator) döndüren örneğin $(C Clone) isminde daha genel bir metot kullanır: Böylece ilerleme sırasında bazı noktalar hatırlanmak istendiğinde bağımsız $(C Iterator) nesneleri oluşturulabilir ve farklı değişkenler olarak saklanabilir. Bu, ilerlemeyi $(C First) ile başından başlatmaktan daha genel bir yöntemdir.
)

$(P
Özetle, fonksiyonel ve nesne yönelimli diller belirgin ilerleme biçimleri kullanırlar. Aralarında bazı farklar bulunsa da ikisi de ileri yönde ilerlemeye odaklanmıştır. Bu şekilde odaklanmak, geriye doğru veya rasgele erişimli ilerlemenin gerekliliğini gözden kaçırmaya neden olabilir. Bir toplulukta geriye doğru GoF yöntemi ile ilerleyebilmek, bütün topluluk kopyalanmadığı sürece olanaksızdır. Eğer STL gelmese, bununla da yetinilmek zorunda kalınırdı.
)

$(H5 STL Biçiminde İlerleme)

$(P
Dick Fosbury, atletizm dünyasını 1968 olimpiyatlarındaki yüksek atlama tekniği ile şaşırtmıştı. O güne kadar bilinen atlama tekniklerinden farklı olarak sırt üstü ve sırtını geriye doğru eğerek atlıyordu. Fosbury'nin tekniğinin çok farklı olması nedeniyle acil olarak bir komite kurulmuş ve sonunda tekniğin geçerli olduğu kabul edilmişti. Sonuçta Fosbury hem altın madalyayı kazanmış hem de tarih yazmış oldu. Günümüzde hemen hemen bütün yüksek atlamacılar Fosbury'nin tekniğini uygular.
)

$(P
STL bunun benzerini erişici örüntüsü ile gerçekleştirmiştir. Yaklaşımının tazeliğine bakıldığında STL erişicilerinin Iterator örüntüsünün aynısı olmadıkları düşünülebilir. STL, erişicilere çok daha verimli bir açıdan yaklaşmıştır. Klasik Iterator örüntüsü, topluluklara sırayla erişim ile ilgilenir ve algoritmaları kendi başlarının çarelerine bakmak zorunda bırakır. Oysa STL, algoritmaları en genel ve evrensel biçimleri ile tanımlamaya odaklanır. Erişiciler veri yapılarını algoritmalara bağlarlar.
)

$(P
STL'den önceki topluluklar GoF biçiminde ilerleme sunuyorlardı; bazıları eleman numarası ile erişim de sağlıyordu. Alexander Stepanov, algoritmaların veri yapılarından önde geldiklerini ve o yüzden öncelikle algoritmalara odaklanılması gerektiğini farketti. Kullandıkları verilerin yapılarını algoritmalar belirlerlerdi. Stepanov, yapıların topluluklardan bağımsız olarak tanımlanmaları gerektiğini de farketti. Böyle bir bağımsızlık, her algoritmanın her topluluk türü için ayrı ayrı tanımlanmasının sonucunda oluşan algoritma adedindeki aşırı artışı önler.
)

$(P
$(I m) algoritmanın $(I n) topluluğa bağlı olduğu durumda $(I m x n) algoritma gerçekleştirilmesi gerekir. $(I m) algoritmanın $(I n) topluluktan bağımsız olduğu durumda ise $(I m + n) gerçekleştirme vardır; bu da kod bakımı açısından çok daha az iş anlamına gelir. STL'nin erişici tasarımının temelinde algoritmalarla toplulukların birbirlerinden bağımsız hale getirilmeleri yatar. Farklı algoritmaların farklı erişim biçimleri gerektirdikleri farkedilmiştir. Bazıları ileri yönde ilerlemeyi, bazıları çift yönde ilerlemeyi, bazıları rasgele erişimi, vs. gerektirmektedirler. Buna bağlı olarak STL, erişici çeşitlerini içeren bir sıradüzen tanımlama yolunu seçmiştir.
)

$(P
"Erişici çeşitleri" kavramı yenidir ama sıkıcıdır da: gökyüzü mavidir, su ıslaktır, ve farklı algoritmalar farklı erişim yöntemleri ile iyi işlerler. İlginç olan, farklı erişim çeşitlerinin varlığı değildir; ilginç olan, bu çeşitlerin sayısının çok $(I az) olmasıdır. Eğer 50 algoritma 30 çeşit erişim gerektirseydi, o tasarım üstesinden gelinemez bir durumda olurdu. Erişim çeşitleri işlev parametrelerine benzer: sayıları çok fazla ise bir yerde bir yanlışlık var demektir. STL yalnızca beş tane erişim çeşidi kullanarak çok sayıda algoritma yazılabildiğini göstermiştir:
)

$(UL

$(LI $(I Giriş erişicileri), dosya ve ağ akımlarında olduğu gibi tek geçişli giriş durumunu modellerler)

$(LI $(I Çıkış erişicileri), sırayla erişimli dosyalarda ve ağ akımlarında olduğu gibi tek geçişli çıkış durumunu modellerler)

$(LI $(I İleri yönde erişiciler), tekli bağlı liste erişimini modellerler)

$(LI $(I Çift yönlü erişiciler), çift bağlı liste (ve beklenmedik şekilde) UTF kodlamalı dizgi erişimini modellerler)

$(LI $(I Rasgele erişiciler), dizi erişimini modellerler)

)

$(P
Bu beş erişici çeşidinin kavramsal sıradüzeni oldukça basittir: Şekil 1'de görüldüğü gibi, en temelde giriş ve çıkış erişicileri bulunur; daha yetenekli olan başka çeşit erişiciler bir öncekinin yetenekleri üzerine kuruludur.
)

$(MONO
   InputIterator        OutputIterator
$(ASIL GirişErişicisi)     $(ASIL ÇıkışErişicisi)
             ↖         ↗
           ForwardIterator
         $(ASIL İleriYöndeErişici)
                  ↑
         BidirectionalIterator
          $(ASIL ÇiftYönlüErişici)
                  ↑
         RandomAccessIterator
       $(ASIL RasgeleErişimliErişici)
)

$(P $(B Şekil 1) STL'deki erişici çeşidi sıradüzeni)

$(H6 Göstergeleri Temel Almak)

$(P
Erişici çeşitlerini belirlemek ve onları bir sıradüzene yerleştirmek, STL'nin klasik erişici kalıplarını geride bırakmasını sağlamıştır. STL'nin belirleyici bir başka özelliği, isimli işlevlerden oluşan bir arayüz kullanmak yerine, C++'nın göstergeleri üzerine kurulmuş olmasıdır.
)

$(P
$(C erisici) ismindeki bir STL erişicisinin (veya C++ göstergesinin) erişim sağladığı değere $(C *erisici) söz dizimi ile erişilir. $(C erisici)'yi bir sonraki değere ilerletmek için $(C ++erisici) veya $(C erisici++) yazılır. Bir erişiciyi kopyalamak, onu başka bir erişiciye atayarak sağlanır. Son olarak, değer aralığının tüketilip tüketilmediği, erişicinin aralığın sonunu gösteren başka bir erişici ile karşılaştırılması ile sağlanır. GoF erişicilerinin tersine, ve göstergelerin bir dizinin sonuna geldiklerinden haberlerinin olmamasına benzer şekilde, C++ erişicileri de aralığın sonuna geldiklerini kendileri bilemezler.
)

$(P
Çift yönlü erişiciler, bir soldaki elemana ilerlemeyi sağlayan $(C --erisici) yazımını desteklerler; rasgele erişiciler buna ek olarak tamsayı eklemeyi ($(C erisici = erisici + 5) gibi), eleman numarası ile rasgele erişimi ($(C erisici[5]) gibi), ve erişiciler arasındaki uzaklık farkını ($(C int kalan = son - erisici) gibi) da desteklerler. Bu düzenek, dillerin iç olanaklarından olan göstergelerin, en güçlü erişici çeşidi olan rasgele erişiciler olarak kullanılabilmelerini sağlamıştır. Eğer bir göstergeyseniz, $(C RandomAccessIterator) soyluluğuna sahipsiniz demektir.
)

$(P
Yukarıdaki temel işlemler hep sabit zamanda işlerler. $(C erisici += n) işlemi, aslında rasgele erişim sağlamayan erişicilerle bile $(C ++iter) işlemini $(C n) kere tekrarlayarak sağlanabilirdi. Ancak bu yöntem $(I O(n)) zaman alacağı için, $(C erisici += n) işleminin sabit zamanda olduğunu varsayan algoritmalar bundan çok kötü bir şekilde etkilenirlerdi.
)

$(P
İsimli işlev kullanan geleneksel bir arayüz yerine gösterge yazımını kabul etmiş olması, STL'nin kabul edilmesini hızlandıran dahiyane bir karar olmuştur. STL algoritmalarının hiçbir özel işlem gerektirmeden göstergelerle doğrudan işleyebilmeleri, onların dizilerle de kullanılabilmelerini sağlamıştır. Daha da iyisi, erişici kullanan kodların gösterge kullanımına benziyor olması, programcıların kodları kolayca anlamalarına ve yazmalarına yardım etmiştir. Bu erişicilerin bu kadar akla yatkın olmaları, ANSI/ISO standart komitesinin STL'nin C++98 standardına eklenmesi teklifini alışılmış uzun komite sürecinden geçirmek yerine hemen kabul etmesine neden olmuş; ve tarihi bir olay haline gelmiştir. Çoğu kişiye göre STL mevcut topluluk ve algoritma kütüphanelerinin en iyisidir. STL'nin bu başarıyı hem de isimsiz işlev $(ASIL lambda function) olanağı bulunmayan bir dil ile gerçekleştirmesini, bir kolu arkasına bağlanmış bir boksörün bir üst kilonun şampiyonunu yenmesine benzetebiliriz.
)

$(H5 STL Erişicilerinin Sorunları)

$(P
Zamanla STL deneyimi arttı ve doğal olarak sorunların farkına varılmaya ve bunların üstesinden gelme yolları aranmaya başlandı. STL'nin, algoritmaları en genel ve en geniş alanda uygulanabilir olarak tanımlama hedefi, en başındaki kadar önemliydi; ancak o hedefe ulaşmanın başka yollarının da bulunabileceği gittikçe açıklık kazanmaya başladı.
)

$(H6 Çiftleme Gereği)

$(P
STL'nin soyutlamasının temelinde göstergelerin bulunuyor olmasının bir sonucu, kullanışlı bir iş yapabilmek için tek değil, iki erişici gerekmesidir. Tek erişici yeterli değildir çünkü topluluk dahilinde kalınacağından emin olunamayacağı için o erişici hiçbir yöne ilerletilemez. (Bu, dizilerin $(I gösterge ve dizi uzunluğu çifti) olarak geçirilmeleri gereken C biçimi kodlamaya benzer.)
)

$(P
Çoğu erişicinin çiftler halinde geçirilmelerinin gerekiyor olması, onları bir araya getiren bir soyutlamanın eksikliğine işaret etmektedir. Böyle bir soyutlama olmadıkça erişici kullanan kodlar bazı güçlükleri göğüslemek zorundadırlar. Örneğin erişiciler üzerine kurulu olan kodlar, birbirlerine bağlanmaya elverişli değillerdir. STL bir aralığı belirleyen iki erişicinin farklı parametreler olmalarını beklediği için, işlevlerin sonuçları başka STL işlevlerine doğrudan geçirilemezler; parametre olarak geçirmek için her adımda isimli değişkenler tanımlamak gerekir.
)

$(H6 İlerleme ve Erişme)

$(P
STL'de $(C *erisici) ifadesinin $(C T)'nin $(C const) olup olmadığına bağlı olarak ya değişikliğe izin veren ya da vermeyen bir $(C T) referansı olması gerekir. Bazen erişilmekte olan verinin değiştirilmesi olanaksızdır; örneğin topluluk salt okunur bir topluluktur veya veri bir giriş akımından okunmaktadır.
)

$(P
Abrahams ve başka yazarlar [3] STL deneyimlerine dayanan ve ilerleme ile erişme kavramlarını birbirlerinden bağımsız hale getiren bir öneri getirirler. Önerileri, erişicileri ikinci bir çeşit sıradüzende tanımlama üzerine kuruludur. Bu yeni çeşit sıradüzen, Şekil 1'deki klasik erişici sıradüzeninden bağımsızdır. Kısaca:
)

$(UL

$(LI $(B Okuma erişicileri): $(C degisken = *erisici) yazılabilir)

$(LI $(B Yazma erişicileri): $(C *erisici = degisken) yazılabilir)

$(LI $(B Değiş tokuş etme erişicileri): $(C iter_swap(erisici1, erisici2)) yazılabilir)

$(LI $(B $(C lvalue) erişicileri): $(C adres = &(*erisici)) yazılabilir; yani, erişilmekte olan elemanın bellekteki adresi alınabilir)

)

$(P
Şekil 2 bu sıradüzeni göstermektedir. Her birisi Şekil 1'deki klasik sıradüzenden bir erişici çeşidi ile birleştirilebilir. Örneğin, çift yönlü ve değiş tokuş etmeye izin veren bir erişici tanımlanabilir ve kullanılabilir.
)

$(MONO
                  Readable             Writable
               $(ASIL Okunabilen)         $(ASIL Yazılabilen)
              ↗           ↖        ↗
  Readable Lvalue          Swappable
$(ASIL Okunabilen Lvalue) $(ASIL Değiş Tokuş Edilebilen)
               ↖           ↗
              Writable Lvalue
           $(ASIL Yazılabilen Lvalue)
)

$(P
$(B Şekil 2) Abrahams ve başka yazarların [3] STL için önerdikleri erişim sıradüzeni
)

$(H6 Güvenlik Eksikliği)

$(P
STL erişicileri bir kaç yönden güvensizdirler. Bir aralığı belirleyen iki erişicinin doğru olarak bir araya getirilmeleri bütünüyle kullanıcının sorumluluğundadır. Erişici çiftleri oluştururken yanlışlık yapmak çok kolaydır ve bunun denetlenmesi pahalı bir işlemdir. Bir erişicinin aralığın dışına taşacak şekilde ilerletildiğinin denetlenmesi de pahalıdır. Hatta böyle denetimler erişicilerin temel işlemlerinden hiçbirisi için doğal da değillerdir. Neden? Çünkü erişiciler göstergeler üzerine kurulmuşlardır ve göstergeler $(I de) doğal olarak denetlenemezler. (Erişicilerin geçersiz hale gelme sorunları da vardır—bir topluluk değiştiğinde, o topluluğun elemanlarına erişim sağlamakta olan erişicilerin işi bozulur; ama bu erişicilerle ilgili bir konu olmaktan çok bir bellek modeli konusudur.)
)

$(P
"Güvenli" STL gerçekleştirmeleri, böyle güvenlik sorunlarına "iri erişiciler"—erişici çiftleri— üzerine kurulu tasarımlar yoluyla özenle eğilirler. Böyle gerçekleştirmeler, göstergelere dayalı soyutlamaların göstergelerin sorunlarını da beraberlerinde getirdiklerinin sessiz tanıklarıdırlar. Az da olsa güvenliğin pahalı yöntemler ve veriler gerekmeden sağlanabilmesi arzulanırdı.
)

$(H6 Gariplikler)

$(P
C++'nın çeşitli gariplikleri erişici tanımlamayı ve kullanmayı gereksizce güçleştirir. Erişicileri doğru olarak tanımlamak çok güç olduğu için Boost salt bu amaca yönelik bir kütüphane tanımlar [2]. Üstelik erişiciler yalnızca üç temel işlem gerçekleştirmek zorundadırlar (karşılaştırma, ilerletme, ve eriştirme). Erişici kullanan kodlar da çok karmaşık olabilirler. Örneğin erişicilere karşı olan kişiler aşağıdaki gibi kodları örnek gösterirler:
)

$(C_CODE
vector&lt;int&gt; v = ...;
for (vector&lt;int&gt;::iterator i = v.begin(); i != v.end(); ++i)
{
   ... burada *i kullanilir ...
}
)

$(P
O kod, eleman numarası ile erişen eski tür döngülerle veya GoF türü isimli işlev kullanan erişicilerle karşılaştırıldığında söz dizimi açısından daha kalabalıktır. ($(C for_each)'in bu konuya çözüm getirdiği yanılgısında değilim, ve lütfen bana bu konuda kızgın mesajlar göndermeyin.)
)

$(P
Erişicilere dayalı başka sıkıntılar da vardır. Giriş erişicilerinin ve ileri yönde erişicilerin yazımları aynı olsa da aralarında ince anlamsal farklar vardır—ileri yönde erişicilerini kopyalamak erişim durumunun bir kopyasını saklar, ama bir giriş erişicisini kopyalamak aynı erişim durumunun başka bir görünümünü oluşturur. Bu da şaşırtıcı olabilen çalışma zamanı hatalarına neden olur.
)

$(P
Erişici kullanımını geliştirmek amacıyla Adobe [4] ve Boost [12] birbirlerinden bağımsız olarak $(I aralık) $(ASIL range) denen ve iki erişiciyi bir araya getiren soyutlamalar tanımladılar. Doğal olarak, bu erişicilerin aynı topluluğa (veya akıma) ait olmaları gerekir. Bir çift bekleyen algoritmalar artık bir aralık kullanabilirler, ve böylece çiftleme hataları hem aza indirgenmiş hem de böyle hataların yakalanmaları kolaylaşmış olur. Aralık kullanan bir algoritma olduğunda örneğin
)

$(C_CODE
sort(v.begin(), v.end());
)

$(P
yazmak yerine artık şöyle yazılır:
)

$(C_CODE
vector&lt;int&gt; v;
...
// v'nin "tamami" uzerinde calisir
sort(v);
)

$(P
Algoritmaların çok kullanıldığı durumlarda aralıklar kodu çok kolaylaştırırlar. Aralıklar, işlevlerin birleştirebilmelerini de sağlarlar. Bunlar önemli gelişmeler olsalar da, Adobe/Boost aralıkları STL'nin tasarımındaki bütün eksiklikleri gideremezler.
)

$(P
Eğer dayanaksız bir kuram geliştirmeme izin verilirse, STL'nin C++ göstergelerinin bir genellemesi olmasının ince bir sorunu vardır: ayrıntılı tasarımı, C++'ya ondan kopartılamayacak kadar bağlıdır. Bu da C++'yı iyi derece bilmeden STL'nin anlaşılmasını çok zor hale getirir; C++'yı derinlemesine anlamadan STL'yi tanımak isteyen yeni başlayanların karşılarına bazıları önemli bazıları ise tesadüfi ayrıntılardan oluşmuş bir duvar örülür; bu duvar da kişiyi daha ileri gitmekten soğutur. STL günümüzde hâlâ yaygın değildir: C++ programcıları arasında çok saygındır, ama genelde programcılık alanında neredeyse hiç tanınmaz. STL'den sonra ortaya çıkan diller bile hâlâ "çıtayı göğüsleyen" atlama tekniğini kullanmaktadırlar. Neden? Bence başka dil veya arayüz yazarlarının STL örneklerini incelerken "Garip... Bunu zaten yapabiliyoruz... Bunun yazımı çok uzun... Şuna bak, çok acayip... Aman boşver. Gel $(C Find)'ı $(C Array)'in bir üye işlevi yapalım" diye düşünmüş olduklarını hayal edebiliriz.
)

$(H5 CDJ#++)

$(P
C++, C#, Java, ve D'den esinlenmiş olan ve bu yazıdaki örneklerde kullanılan sözde dile CDJ#++ diyeceğim. Amacım bu yazıyı dilden bağımsız hale getirmek ve yazım kuralları ve küçük ayrıntılar yerine tasarıma odaklanmak. Diller benzer işleri farklı biçimlerde hallederler; o yüzden CDJ#++'nın kurucu ve sonlandırıcı işlevleri yoktur, bağımsız tür üretim $(ASIL generic type creation) ve kullanım ayrıntılarına girmez, arayüzleri öylesine tanımlar, ve parametreleri işlevlere referans olarak geçirme $(ASIL pass-by-reference) seçime bağlıdır.
)

$(P
Olanakları hiçbirisine doğrudan denk olmasa da, yukarıdaki dillerden herhangi birisini biliyorsanız CDJ#++'nın kullanımını kolaylıkla anlayacaksınız.
)

$(H5 İlerleme İşlemine Yeni Bir Bakış Açısı)

$(P
STL erişicilerinin güvenlik sorunları GoF erişicilerinde bulunmaz. Bir topluluğun elemanlarına erişmek için bir çift GoF erişicisi gerekmediği için, o tasarımda çiftleme hataları olamaz. Ayrıca, $(C IsDone), $(C Next), ve $(C CurrentItem) işlevlerinin içlerine aşağıdaki hayalî erişicide görüldüğü gibi küçük denetimler eklemek oldukça kolaydır.
)

---
class DiziErişicisi
{
public:

    bool IsDone() {            // Bitti_mi()
       assert(baş <= son);
       return baş == son;
    }

    void Next() {              // İlerlet()
       assert(!IsDone());
       ++baş;
    }

    T CurrentItem() {          // ŞimdikiEleman()
       assert(!IsDone());
       return *baş;
    }

private:

   T* baş;
   T* son;
}
---

$(P
GoF arayüzü doğal olarak daha sağlamdır ve bunun için hızdan ödün verilmemektedir. Buradaki kazanç, aralığı belirleyen sınırların bir birim halinde birleştirilmiş olmaları ve bu sayede daha üst düzey ve daha güvenli bir arayüz sağlamalarıdır.
)

$(P
GoF türü arayüzler bazı durumlarda erişiciler kadar hızlı olabilirler ama bazen daha yavaştırlar. Örneğin $(C IsDone) içindeki karşılaştırma erişicilerde olduğu kadar hızlıdır. Ancak, $(C DiziErişicisi) bir STL erişicisinin iki katı kadar yer tutar; bu da erişicinin tek bir elemanı gösterdiği durumlarda belirgin bir etkidir. (Örnek olarak büyük bir diziyi ve onun elemanlarını gösteren erişicileri düşünebilirsiniz.) Yine de çoğu durumda STL erişicileri de çiftler halinde kullanıldıkları için öyle durumlarda yer kaybından söz edilemez.
)

$(P
STL, erişmenin $(C IsDone), $(C Next), ve $(C CurrentItem) ile sınırlı olmadığını da etkin bir şekilde ortaya koymuştur. STL ve GoF erişicilerinin getirdikleri fikirler üzerine kurulu olan etkin, esnek, basit, ve kullanışlı bir erişici oluşturmaya çalışalım. STL'nin yaptığı gibi gösterge soyutlamasına bağlı kalmak yerine, burada GoF'un yaklaşımını örnek almak daha iyidir. Böyle bir erişici türü, etkinlikten çoğu durumda ödün vermeden hem daha akıllı hem de daha güvenli olabilir. Ama STL'nin çok yararlı olan erişici gruplarını da kullanalım. Önceki örnekte görüldüğü gibi, bu yeni erişicinin sınırlardan, yani aralığın başından ve sonundan haberinin olması gerekecektir. Buna bağlı olarak, bu aday soyutlamaya "aralık", özelleşmiş hallerine (giriş, çıkış, ilerleme, çift uçlu, ve rasgele erişimli) de "grup" $(ASIL category) diyeceğiz.
)

$(H6 Erişimi ve İlerlemeyi Birbirlerinden Ayırmak)

$(P
Abrahams ve başka yazarların yukarıdaki "İlerleme ve Erişme" başlığındaki önerileri ne kadar akla yatkın olsa da; bu yazı erişimden çok ilerleme ile ilgilidir. Şimdi böyle bir ayrımın yararını erişimin ayrıntılarına fazlaca girmeyi gerektirmeden gösterecek olan küçük bir soyutlama adımı atalım: Aralıkların erişime göre gruplanmalarını, aralık elemanlarının türünü $(C T) ile gösterdiğimiz $(C Ref&lt;T&gt;) isminde bir tür arkasına gizleyeceğiz. $(C Ref&lt;T&gt;) çok basit olarak $(C T)'nin takma ismi veya bir $(C T) referansı olabileceği gibi; okuma, yazma, değiş tokuş, veya adres alma işlemlerinin bazılarını veya tümünü birden sağlayan bir aracı tür de olabilir. Temelde, $(C Ref&lt;T&gt;) Şekil 2'deki gruplamaları oluşturmaya yarayan bir türdür. Aşağıda gösterilen aralık grupları $(C T)'ye olduğu kadar $(C Ref)'e de bağlı olabilirler.
)

$(H6 Tek Geçişli Aralıklar)

$(P
İşimize klavyeden tuş girişi, ağ pakedi okuma, veya C'nin $(C fgetc) arayüzü gibi durumlarda karşılaşılan ardışık akımlarla başlayalım. $(C IsDone)/$(C CurrentItem)/$(C Next) üçlüsünü bunlar için gerçekleştirmek kolaydır: $(C IsDone), girişin sonlanıp sonlanmadığını denetler ve tek elemanlık bir ara belleği doldurur; $(C CurrentItem), bu belleğin içeriğini döndürür; ve $(C Next), $(C IsDone)'ın bir sonraki çağrılışında yeni bir eleman okuması gerektiğini bildiren bir bayrak kullanır. Bu tek geçişli aralık arayüzünü temel işlemlerinin isimlerini de farklı seçerek tanımlayalım. (Bu yeni isimlerin daha uygun olduklarını arayüz geliştikçe anlayacağız.)
)

---
interface OnePassRange        // TekGeçişliAralık
{
   bool empty();              // boş_mu()
   Ref<T> front();            // baştaki()
   void popFront();           // baştakiniÇıkart()
}
---

$(P
Yukarıdaki "interface" (arayüz) anahtar sözcüğünü biraz serbestçe kullanıyorum. Seçilen dile bağlı olarak açıkça arayüz olabileceği gibi, otomatik arayüz veya ördek türü [10] de olabilir (örneğin "$(C empty), $(C front), ve $(C popFront) işlevleri varsa bir giriş aralığıdır" gibi bir kabulde olduğu gibi).
)

$(P
$(C OnePassRange) aşağıdaki döngüdeki gibi kullanılabilir:
)

---
OnePassRange r = ...;
for (; !r.empty(); r.popFront()) {
   ... burada r.front() kullanılır ...
}
---

$(P
Böyle giriş aralıkları $(C map) ve $(C reduce) gibi güçlü algoritmalarda kullanılmaya elverişlidirler bile. Ama daha basit bir örnek olarak $(C find) algoritmasına bakalım:
)

---
OnePassRange find(OnePassRange r, T değer)
{
   for (; !r.empty(); r.popFront()) {
      if (r.front() == değer) break;
   }
   return r;
}
---

$(P
$(C find)'ın tanımı çok basittir—belirtilen aralığı değer bulunana veya aralık tükenene kadar ilerletir. Aralığın bulunan değerden başlayan bölümünü de döndürür.
)

$(P
Dikkat ederseniz, tek geçişli aralıklar giriş için de çıkış için de kullanılabilirler—bu; kullanılan $(C Ref&lt;T&gt;)'nin okuma, yazma, veya her ikisine birden izin verip vermemesine bağlıdır. Yazmaya izin veren tek geçişli aralığa $(C WOnePassRange) dersek, $(C copy) algoritmasını şöyle tanımlayabiliriz:
)

---
WOnePassRange copy(OnePassRange kaynak, WOnePassRange hedef)
{
   for (; !kaynak.empty(); kaynak.popFront(), hedef.popFront()) {
      assert(!hedef.empty());
      hedef.front() = kaynak.front();
   }
   return hedef;
}
---

$(P
$(C copy), gerekiyorsa kopyalamaya devam edilebilsin diye hedef aralığın geri kalanını döndürmektedir.
)

$(H6 İlerleme Aralıkları)

$(P
İlerleme aralıkları, en çok fonksiyonel dillerin ve GoF erişicilerinin gerçekleştirmelerine benzerler: bellekte bulunan veriler üzerinde baştan sona doğru ilerlemek.
)

---
interface ForwardRange : OnePassRange   // İlerlemeAralığı
{
   ForwardRange save();                 // kaydet()
}
---

$(P
$(C ForwardRange), $(C OnePassRange)'in bütün temel işlemlerine sahiptir; ek olarak ilerleme işleminin belirli bir andaki durumunu kaydetmeye yarayan $(C save) işlevi de vardır.
)

$(P
Aralığın sıradan bir kopyası neden kullanılamaz?
)

---
void işlev(ForwardRange r)
{
   ForwardRange bakKopyaladım = r;
   ...
}
---

$(P
$(C save) işlevinin iki amacı vardır. Birincisi, Java gibi referans türleri kullanan dillerde $(C bakKopyaladım) gerçek bir kopya değildir—bir takma isimdir; yani asıl $(C Range) nesnesine erişim sağlayan bir başka referanstır. Öyle olduğu için asıl nesne ancak bir işlev çağrısı ile kopyalanabilir. İkincisi, C++ gibi değer türleri kullanan dillerde parametrelerin işlevlere geçirilmeleri sırasındaki kopyalama ile aralığın durumunu kaydeden kopyalama arasında fark bulunmaz. O yüzden bunu $(C save) işlevi ile açıkça yapmak kodun anlaşılırlığı açısından yararlıdır. (Bu; yazım açısından aynı, ama anlam açısından farklı olan STL'deki ilerleme ve giriş erişicileri arasındaki sorunu da çözer.)
)

$(P
Çok sayıdaki ilginç algoritmayı artık bu ilerleme aralığı arayüzünü kullanarak tanımlayabiliriz. Aralıklar kullanan algoritmaların neye benzediklerini görmek için yan yana aynı olan elemanları bulan $(C tekrarlananıBul) gibi bir işlevin nasıl yazıldığına bakalım:
)

---
ForwardRange tekrarlananıBul(ForwardRange r)
{
   if (!r.empty()) {
      auto s = r.save();
      s.popFront();
      for (; !s.empty(); r.popFront(), s.popFront()) {
         if (r.front() == s.front()) break;
      }
   }
   return r;
}
---

$(P
$(C auto s = r.save();) deyimi işletildikten sonra $(C s) ve $(C r) artık birbirlerinden bağımsızdırlar. $(C ForwardRange) yerine $(C OnePassRange) kullanılmaya çalışılsaydı $(C OnePassRange)'in $(C save) işlevi bulunmadığı için kod derlenemezdi. Eğer $(C ForwardRange) $(C save)'i çağırmak yerine kopyalamayı seçseydi kod bir $(C OnePassRange) ile de derlenirdi ama çalışma zamanında yanlış sonuçlar üretirdi. (Nedeni: Döngü daha ilk adımda dururdu, çünkü $(C r) ve $(C s) birbirlerine bağlı olacaklarından $(C r.front()) ve $(C s.front()) eşit olurlardı.)
)

$(H6 Çift Uçlu Aralıklar)

$(P
Aralık özellemelerinin bir sonraki düzeyinde $(C front) ve $(C popFront) işlevlerinin benzerleri olarak çalışan $(C back) ve $(C popBack) işlevlerini sunan çift uçlu aralıklar var.
)

---
interface DoubleEndedRange : ForwardRange   // ÇiftUçluAralık
{
   Ref<T> back();                           // sondaki()
   void popBack();                          // sondakiniÇıkart()
}
---

$(P
Değiş tokuş edilebilen elemanlardan oluşan çift uçlu bir aralığın elemanlarını ters sıraya dizen $(C reverse) algoritmasına bakalım:
)

---
void reverse(DoubleEndedRange r)            // tersineÇevir()
{
   while (!r.empty()) {
      swap(r.front(), r.back());
      r.popFront();
      if (r.empty()) break;
      r.popBack();
   }
}
---

$(P
Çok kolay. Aralıklar, algoritma yazmanın yanında yeni başka aralıklar tanımlamaya da yararlar. Örneğin çift uçlu bir aralığı ters sırada ilerlemeye yarayan $(C Retro) ismindeki yeni bir aralık, $(C front)'u $(C back)'e, $(C popFront)'u da $(C popBack)'e bağlamak kadar kolaydır:
)

---
struct Retro<DoubleEndedRange>             // GeriyeDoğru
{
   private DoubleEndedRange r;
   bool empty() { return r.empty(); }      // boş_mu()
   Ref<T> front() { return r.back(); }     // baştaki()
   void popFront() { r.popBack(); }        // baştakiniÇıkart()
   Ref<T> back() { return r.front(); }     // sondaki()
   void popBack() { r.popFront(); }        // sondakiniÇıkart()
}
---

$(P
$(B NOT:) "retro" ("geçmişe doğru) ismi aslında tam uymuyor ama daha doğru olan "reverser" ("tersine çevirici") da zorlama gelmişti.
)

$(H6 Rasgele Erişimli Aralıklar)

$(P
Aralıkların en güçlüsü olan rasgele erişimli aralıklar, tek uçlu aralık işlemlerine ek olarak eleman numarası ile erişme ve sabit zamanda erişme olanaklarını da sunarlar. Bu tür aralıklar hem dizilerdeki gibi ardışık hem de STL'nin $(C deque)'indeki gibi ardışık olmayan yapıları kapsarlar. Rasgele erişimli aralıklar $(C ForwardRange)'in temel işlevleri üzerine $(C at) ve $(C slice) işlevlerini de getirirler. $(C at), belirtilen numaralı elemana erişim sağlar; $(C slice), belirtilen iki numara arasındaki alt aralığı verir.
)

---
interface RandomAccessRange : ForwardRange // RasgeleErişimliAralık
{
   Ref<T> at(int i);                       // numaralıEleman()
   RandomAccessRange slice(int i, int j);  // altAralık()
}
---

$(P
Buradaki çarpıcı ayrıntı; $(C RandomAccessRange)'in $(C DoubleEndedRange)'in değil, $(C ForwardRange)'in üzerine kurulu olmasıdır. Neden? Nedeni sonsuzluktur. On ile bölünmekten kalan değerleri üreten bir aralık düşünelim: 0, 1, 2, ..., 9, 0, 1 ... Belirli bir eleman numarasına karşılık gelen seri elemanını hesaplamak kolaydır ve bu açıdan $(C RandomAccessRange) tanımına uyar. Ancak, "son" elemanı bulunmadığı için bu aralık bir $(C DoubleEndedRange) olamaz. Dolayısıyla, rasgele erişimli aralıklar sonsuz olup olmamalarına bağlı olarak farklı işlemlerin üzerine kuruludurlar.
)

$(P
Çoğu algoritma alt aralıkların sabit zamanda oluşturulabilmelerini bekler. Örneğin $(C quicksort) sabit zamanda rasgele erişim bulunmadığında iyi bir dayanak $(ASIL pivot) seçemez, ve girişi rastgele bir yerden ikiye ayırabilmek için de alt aralık işlemini sabit zamanda yapması gerekir.
)

$(P
Aralıklar için önerilmekte olan sıradüzen Şekil 3'te görüldüğü gibidir.
)

$(MONO
                    OnePassRange
                $(ASIL TekGeçişliAralık)
                        ↑
                   ForwardRange
                $(ASIL İlerlemeAralığı)
                   ↗         ↖
       DoubleEndedRange    RandomAccessRange (sonsuz)
       $(ASIL ÇiftUçluAralık)    $(ASIL RasgeleErişimliAralık)
               ↑
  RandomAccessRange (sonlu)
  $(ASIL RasgeleErişimliAralık)
)

$(P $(B Şekil 3) Önerilmekte olan aralık grupları sıradüzeni
)

$(H5 Aralık Deneyimleri)

$(P
Güzel bir soru: Yukarıda tanımlanan aralıklar örneğin STL'yi gerçekleştirebilecek ifade gücüne sahip midirler? Hatta daha fazlasını verebilirler mi? Daha alt düzey soyutlamalar oldukları için erişicilerin aralıklardan daha becerikli oldukları açıktır. Buna rağmen, benim deneyimlerime göre aralıkların ifade yeteneklerinin az derecede düşük olması, getirdikleri üst düzey soyutlamaların ve güvenliliklerin yararları yanında önemsiz kalmaktadır.
)

$(H5 Aralıkların Ek Nitelikleri)

$(P
Şimdiye kadar tanımladığımız aralık arayüzleri çok sayıda algoritmayı topluluklardan bağımsız olarak gerçekleştirebilecek kadar ve bu yüzden de şaşırtıcı derecede yeteneklidirler. Yine de bazı yararlı temel işlemler garipsenecek kadar eksiktir. Örneğin çoğu rasgele erişimli aralık ve diğer aralıkların bazıları aslında $(C length) (uzunluk) bilgisini de sunabilirler. Hatta, uzunluk kavramı başından sonuna kadar ilerleyerek bir giriş aralığı tarafından da sağlanabilir, ama bazı topluluklar uzunluk işlemini doğal olarak sabit zamanda gerçekleştirirler.
)

$(P
İlginç olarak, uzunluk işlemi belirli bir aralık çeşidine bağlı değildir. Uzunluğun rasgele erişimli aralıklarda şart, diğer aralıklarda şart olmadığı düşünülebilir. Ancak, uzunluğu bulunmayan rasgele erişimli aralıklar da vardır. Yukarıdaki "Rasgele Erişimli Aralıklar" başlığı altında sözü geçen 10 ile bölünme aralığının uzunluğunun bulunmadığı açıktır, ama o kadar açık olmayan durumlarla da karşılaşılabilir. Örneğin bir dizi üzerinde gerçekleştirilmiş olan döngüsel ara belleği $(ASIL circular buffer) düşünün. Bu aralığın $(C i)'inci elemanına sabit zamanda erişilebilir—bu, dizinin $(C (i % n)) ile hesaplanan elemanıdır. Ama bu ara belleğin uzunluğunun $(C n) olduğunu söylemek şaşırtıcı olabilir: kullanıcılar $(C n) adım ilerleyerek dizinin sonuna erişeceklerini düşünebilirler, ama öyle olmaz. Öte yandan, bazı giriş akımlarının bile uzunlukları bulunabilir—örneğin 100 adet rasgele sayı üreten bir aralık.
)

$(P
Bu yüzden $(C length) aralıklar için ek bir niteliktir. Eğer olabiliyorsa aralık tarafından sunulmalıdır ama şart koşulmamalıdır. Aralık algoritmaları da aralıkların $(C length)'i sunmalarının şart olup olmadığına kendileri karar verebilirler.
)

$(P
Deneyimler doğrultusunda kullanışlılığı görülen bir başka nitelik, sonsuzluktur. Sonsuz bir aralığın $(C empty()) işlevi her zaman için $(C false) döndürür. Çoğu dilde bunu algılamak zordur; o yüzden sonsuzluğu belirten Bool türünde ayrı bir $(C isInfinite) (sonsuz_mu) niteliği sunulabilir. Sonsuzluk kavramının aralık arayüzlerinin önemli bir parçası olduğunu düşünmesem de D'de bunun çok kolay sağlanabildiğini ve bazen çok yararlı olabildiğini söyleyebilirim. "Rasgele Erişimli Aralıklar" bölümünde değinildiği gibi; rasgele erişimli aralıklar, çift uçlu aralıklar ve sonsuzluk kavramı arasında bir ilişki vardır: rastgele erişimli bir aralık sonsuzsa, ilerleme aralıklarının üzerine kuruludur; değilse, çift uçlu aralıkların üzerine kuruludur.
)

$(P
Daha az karşılaşılan aralık işlemleri, $(C lookahead) (ileriye_bak) ve $(C putback) (geri_koy) gibi işlemlerdir. Bir giriş aralığı, belirli sayıya kadar ilerideki elemanlara bakmaya, veya elemanları aralığa geri koymaya izin verebilir. C'nin ardışık dosya arayüzünde en azından tek karakter destekleyen $(C ungetc) işlevi vardır. $(C lookahead) ve $(C putback), ayrıştırma $(ASIL parsing) işiyle ilgilenen akımlar gibi uygulamalarda kullanışlıdırlar.
)

$(H5 Üst Düzey Aralıklar)

$(P
Parametre olarak başka işlevler alan veya döndüren üst düzey işlevlere benzer şekilde; üst düzey aralıklar da başka aralıkları bir araya getiren veya kullanan, ve kendileri de aralık arayüzü sunan yapılardır. Başka aralıkları farklı şekillerde sunan aralıklar oluşturmak kolaydır, kullanışlıdır, ve eğlencelidir. Hatta üst düzey aralıkların ilk çıktığı zaman STL'den beklenenleri sonunda karşıladıklarını da söyleyebiliriz. STL ilk çıktığı zamanlarda, ihtiyaca uygun olarak yazılmış olan erişicilerin bir çok sorunu çözeceğine inanılmış ve böyle erişiciler yazılmıştı. Ne yazık ki o tür erişicilerin başarısı yarım kalmıştır. Bunun nedeninden emin değilim ama erişicilerin tanım güçlüğünün ve yazımlarının uzunluğunun payı olduğunu sanıyorum.
)

$(P
Aralık tanımlamak ve kullanmak ise çok kolaydır. Aslında çoğu algoritmanın ürettiği sonuç, belirli bir ihtiyaca uygun olan bir aralıktır. Örnek olarak üst düzey bir işlev olan klasik $(C filter)'a (süz) bakalım: parametre olarak bir aralık ve o aralıktaki elemanların hangilerinin seçileceklerini belirleyen bir kıstas işlevi alır. $(C filter)'ın kendi yaptığı iş çok azdır—o, yalnızca bir aralık kurar ve döndürür; süzme işi ise adına $(C Filter) diyebileceğimiz döndürülen aralığın işlemleri ile gerçekleştirilir.
)

$(UL

$(LI
$(B Tembellik.) Üst düzey aralıklar işlemlerini hevesli olarak değil, fonksiyonel dillerin de yeğledikleri gibi tembel olarak yapabilirler. Örneğin bir STL algoritması olan $(C set_union)'a bakalım; sıralanmış olan iki aralık alır ve her iki aralıktaki elemanların bileşiminden oluşan ve yine sıralanmış olan bir aralık üretir; bu işi doğrusal $(ASIL linear) zamanda gerçekleştirir. $(C set_union) heveslidir—döndüğü zaman bütün işini bitirmiştir. Bu yöntemin iki sakıncası vardır. Birincisi, hedef aralığın oluşturulması ve belki de bellek ayrılması gerekmektedir. Bu da $(C set_union)'ın ürettiği elemanlara sırayla bakılacağı ama belki de hepsinin gerekmeyeceği gibi durumlarda hem bellek hem de zaman açısından savurganlıktır. İkincisi, işini tamamlayabilmek için bütün giriş elemanlarını okuması gerektiği için $(C set_union) sonsuz aralıklar üzerinde kullanılamaz.
)

$(P
Tembel değerlendirmelerin bir yararı olarak modüler birleşimlere $(ASIL modular composition) olanak vermesi gösterilir. Bunun nedeni, tembel değerlendirmelerin güçlü üreticilerin ürettikleri büyük veri alanlarına ait olan değerlerin seçiciler tarafından seçilebilmelerine olanak tanımasıdır. Hughes'ün güzelce açıkladığı [9] bu yarar, $(C MapReduce) algoritmasının [6] Google'ın ünlü gerçekleştirmesinde de görülmektedir. Tembel değerlendirmeler D'nin standart kütüphanesinde de olabilen her yerde ve oldukça etkili bir biçimde kullanılmaktadır.
)

$(LI
$(B Aralık Yeteneklerinin Korunması.) Bir $(C r) aralığını ters sırada ilerleyen $(C Retro)'yu hatırlayalım. Asıl aralığın çift uçlu bir aralık olması gerektiği açıktır. Soru: Asıl aralık rasgele erişim de sağlıyorsa $(C Retro) da rasgele erişim sağlamalı mıdır? Bu sorunun yanıtı kesinlikle evettir. Genel bir kural olarak, üst düzey aralıklar asıl aralığa da bağlı olmak üzere sunabildikleri en üst aralık çeşidini sunmalıdırlar. Bu kurala göre $(C Retro) aşağıdaki gibi işlemelidir:
)

---
struct Retro<DoubleEndedRange> {

   ... burası önceki ile aynı ...

   static if (isRandomAccess(DoubleEndedRange)// rasgeleErişimli_mi()
           && hasLength(DoubleEndedRange)) {  // uzunluğuVar_mı()

      Ref<T> at(unsigned i) {
         return r.at(r.length() - 1 - i);
      }

      DoubleEndedRange slice(int i, int j) {
         return r.slice(r.length() - j, r.length() - i);
      }
   }

   static if (hasLength(DoubleEndedRange)) {  // uzunluğuVar_mı()
      unsigned length() {
         return r.length();
      }
   }
}
---

$(P
Yukarıda bir CDJ#++ olanağı olan $(C static if)'ten yararlanıyorum: Koşul doğru olduğunda blok içindeki kod derlenir, değilse programa dahil edilmez. $(C hasLength) ve $(C isRandomAccess) kıstasları, asıl aralığın $(C length) sunup sunmadığını ve rasgele erişimli bir aralık olup olmadığını derleme zamanında iç gözlemden $(ASIL introspection) yararlanarak bildirmektedirler. $(C DoubleEndedRange)'in $(C length)'i sunup sunmayacağının da $(C r)'ye bağlı olduğuna dikkat edin.
)

$(P
Arayüzlerin duruma göre böyle zenginleştirilmeleri dilin statik iç gözlem düzeneklerini oldukça zorlar. Bunun Java veya C#'ta nasıl yapıldığını bilmiyorum ama C++'da çok güç olsa da yapılabiliyor. Öte yandan $(C static if) D'de vardır ve $(C isRandomAccess) ve $(C hasLength) gibi kıstasları gerçekleştirmeyi çok kolaylaştırır. Dinamik dillerde ise dinamik iç gözlemle ilgili böyle sorunlar yoktur; kullanıcılar aralık nesnelerinin yetenekleri hakkında kolayca bilgi edinebilirler.
)

$(P
Statik iç gözlem çok güzel olanaklar sağlar. Örneğin $(C Retro) asıl aralık olarak yine kendisini $(C Retro&lt;Retro&lt;BirAralık&gt;&gt;) biçiminde kullanıyor olsa, onun yerine hiç hesap yapılmadan doğrudan $(C BirAralık) kullanılabilir.
)

$(LI
$(B Chain (Zincir)). Üst düzey aralık örneklerinden olan $(C Chain), birden fazla ve farklı çeşitlerden olabilen aralığı tek bir aralıkmış gibi sunar. $(C Chain) sanki tek bir aralıkmış gibi, asıl aralıklar arasında geçiş yapıldığının farkında bile olunmadan kullanılır. $(C Chain)'in yetenekleri doğal olarak asıl aralıkların yeteneklerinin bir kesişimidir. Örneğin $(C Chain)'in $(C length) işlevinin olabilmesi için asıl aralıkların hepsinin de $(C length) işlevlerinin olması gerekir. Eğer bütün aralıklar rasgele erişim sağlıyorlarsa $(I ve) uzunlukları varsa $(C Chain) de rasgele erişim sağlayabilir. Öyle bir durumda $(C Chain)'in $(I n)'inci elemanına erişmek, $(C Chain)'in asıl aralıklarının sayısına bağlı kalmak zorundadır. (Bu da bir algoritma karmaşıklığı sorunu oluşturabilir.) $(C Chain), oldukça ilginç işlemlerin önünü açar. Örneğin $(C sort(Chain(a, b, c))) ifadesi, üç tane fiziksel dizi üzerine kurulmuş olan mantıksal bir diziyi sıralayabilir. $(C Chain) üzerinde ilerlemek tembel bir işlem olsa da, $(C sort)'un kendisi tembel olmadığı için döndüğünde üç dizi içindeki elemanlar sıralanmış olurlar.
)

)

$(H5 Üç Noktalı Algoritmalar)

$(P
STL'deki bazı algoritmalar üç erişici kullanırlar; birisi aralığın başını, diğeri bir orta noktasını, sonuncusu da sonunu belirler. Örneğin STL'nin $(C nth_element) ve $(C rotate) algoritmalarının arayüzleri şöyledir:
)

---
void nth_element(RIt baş, RIt orta, RIt son);
void rotate(FIt baş, FIt orta, FIt son);
---

$(P
Yukarıdaki $(C RIt) bir rasgele erişim erişicisi ve $(C FIt) bir ilerleme erişicisidir. $(C orta), $(C baş) ile $(C son) arasında olmak zorundadır. $(C nth_element), aralığın en küçük $(C orta - baş) adet elemanını aralığın baş tarafına taşır, ve $(C orta)'nın $(C (orta - baş))'ıncı en küçük elemanı göstermesini sağlar. $(C nth_element)'ın yararı bunu aralığı hiç sıralamadan yapmasıdır; bütün işi, yalnızca $(I n)'inci en küçük elemanı bulmaktır. Aralığı sıralamak ve ondan sonra $(C orta) elemana bakmak da işe yarar, ama $(C nth_element) $(C sort)'tan çok daha az sayıda işlem yaptığı için büyük verilerle uğraşırken önemlidir. ($(C nth_element) indeksli arama $(ASIL index searching) ve en yakın komşu $(ASIL nearest neighbors) gibi algoritmalarda da kullanılır.)
)

$(P
İsmi garip olsa da $(C rotate) benim en sevdiğim algoritmalardandır. Aralıktaki elemanların [$(C orta), $(C son)&#41; arasındakilerini [$(C baş), $(C orta)&#41; arasındakilerden daha önce olacak şekilde yer değiştirir. Başka bir deyişle, $(C rotate) bir $(I öne getirme) işlemidir: [$(C orta), $(C son)&#41; bölümü aralığın başına getirilir. Dikkatsizce yazıldığında çok uzun zaman alabilse de $(C rotate) aslında çok az sayıda veri aktaran akıllı bir algoritmadır.
)

$(P
$(B NOT:) $(C bring_to_front)'un (başa_getir) $(C rotate)'ten çok daha uygun bir isim olduğunu düşünüyorum.
)

$(P
Bu tür işlevleri aralıklarla nasıl kullanabiliriz? Bu konu benim için uzunca bir süre içinden çıkılmaz bir sorun oluşturmuştu. Sonunda basit bir gerçeği farkettim: üç noktalı algoritmalar aslında kavramsal olarak üç erişici değil, $(C sol) ve $(C sağ) diyebileceğimiz iki aralık almaktadırlar. Soldaki aralık [$(C baş), $(C orta)&#41;'dan, sağdaki aralık da [$(C orta), $(C son)&#41;'dan oluşur. $(C nth_element) ve $(C rotate)'i bu gözlemin ışığında sonunda aşağıdaki gibi tanımlamaya karar verdim ve gerçekleştirdim:
)

---
void nth_element(RR sol, RR sağ);
void rotate(FR sol, FR sağ);
---

$(P
Yukarıdaki $(C RR) bir rasgele erişim aralığı ve $(C FR) bir ilerleme aralığıdır. O işlevler belirli bir aralıkla örneğin şöyle kullanılabilirler:
)

---
Aralık r = ...;
nth_element(r.slice(0, 5), r.slice(5, r.length));
rotate(r.slice(0, 5), r.slice(5, r.length));
---

$(P
Aynı mantık $(C partial_sort) gibi diğer STL algoritmalarına da uygulanabilir. Tam bu çözümü kabul edecekken bunun başka olanaklar da sunduğunu farkettim. Yukarıdaki işlevleri aşağıdaki gibi tanımladığımızı düşünelim:
)

---
void nth_element(R1 sol, R2 sağ);
void rotate(R1 sol, R2 sağ);
---

$(P
Şimdi $(C R1) ve $(C R2), yan yana olmaları veya aynı çeşitten olmaları bile gerekmeyen farklı herhangi iki aralıktır. (Yan yana olmaları algoritmalar için yararlı bir bilgi oluşturmaz.) Artık elimizde çok daha güçlü algoritmalar vardır. Örneğin $(C nth_element) bir aralığın en küçük $(I n) elemanını değil, bellekte yan yana bile bulunmayan iki aralığın en küçük $(I n) elemanını bulabilir! Daha da iyisi, $(C nth_element)'ın aldığı $(C R2)'nin artık rasgele erişimli bir aralık olması da gerekmemektedir—bir giriş aralığı olması yeterlidir. $(C nth_element)'ın gerçekleştirmesi bu durumun farkına varabilir ve $(C R2)'nin yeteneklerine uygun olarak farklı algoritmalar kullanabilir.
)

$(P
Üç erişici yerine iki aralık kullanıldığında hem aynı sorun çözülmekte, hem de daha büyük işlevsellik kazanılmaktadır.
)

$(H5 Zayıflıkları)

$(P
Bildiğimiz bir dildeki yöntemleri yeni öğrenmekte olduğumuz bir dile uygulayışımıza benzer şekilde, ben ve başka bir çok kişi STL erişicilerinden aralıklara geçerken erişiciler üzerine kurulu olan tasarımları doğal olarak aralıklara da uygulamaya çalıştık. Bunun sonucunda da aralıklara kolayca geçirilemediklerini farkettiğimiz bazı erişici algoritmalarıyla karşılaştık. Bunun bir örneği, birden fazla topluluk erişicisini indeksler aracılığıyla erişecek şekilde saklayan Boost'un MultiIndex'idir [11]. Onu tek elemanlı aralıklarla gerçekleştirmek, her bir indeks için harcanan alanı iki katına çıkartır.
)

$(P
Farkettiğim başka bir zayıflık, $(C find) gibi tek erişici döndüren STL algoritmalarında görülür:
)

---
It find(It baş, It son, E değer)
---

$(P
Yukarıdaki $(C It) tek geçişli bir erişicidir ve $(C E) de onun eriştirdiği elemanın türüdür. STL'deki $(C find), $(C baş) ile $(C son) arasında $(C *erisici == değer) koşulunu sağlayan ilk $(C erisici)'yi döndürür. Döndürülen o erişici de aralığın baş tarafını oluşturmak için $(C baş) ile, son tarafını oluşturmak için de $(C son) ile bir arada kullanılabilir.
)

$(P
Böyle bir yetenek aralıklarda bulunmaz. Aralık kullanan $(C find)'ın bildirimi şöyledir:
)

---
Aralık find(Aralık r, E değer)
---

$(P
Bu $(C find), aralığı $(C değer)'i bulana kadar başından tüketir ve geri kalanını döndürür. Bunun sonucunda da bulunan değerden ancak sonrasına erişilebilir, öncesine değil.
)

$(P
Neyse ki bu sorun da $(C Until) (BulanaKadar) isminde yeni bir aralık tanımlayarak çözülebilir. $(C Until) başka bir $(C aralık) ve bir $(C değer) alır, ve aralığın baş tarafından $(C aralık.front() == değer) koşulunun sağlandığı noktaya kadarki aralığı döndürür. Tembel değerlendirmelerin sağladıkları kazanç ile!
)

$(P
Doğal olarak, erişicilerin yapabildikleri ama aralıkların yapamadıkları başka şeyler de olacaktır. Neyse ki bunların sayısı çok değil gibi görünüyor ve aralık tasarımları, erişicilerle uygulanabilen kurnazlıklardan fazla yoksun kalmıyorlar.
)

$(P
Aralıkların kullanılan dilin bellek modeline bağlı bir zayıflığı, bir topluluğa erişim sağlamakta olan mevcut aralıkların o topluluk değiştikçe geçersiz hale gelmeleridir. STL erişicilerinin geçersiz hale gelme kuralları kesin olarak belirlidir, ama bu duruma düşüp düşmedikleri denetlenemez. Bir topluluk erişicisinin topluluk değişti diye geçersiz hale gelmesine rağmen kullanılması tanımsız davranıştır. Aynı sorun aralıklarda da bulunur. ("İlerleme İşlemine Yeni Bir Bakış Açısı" bölümünde anlatıldığı gibi, aralıklar geçersiz erişici çiftlerine izin vermedikleri için yine de erişicilerden daha güvenlidirler.) Bu konuda daha fazla araştırma yapmamış olsam da güvenlik denetimlerinin aralıklara erişicilerden daha kolay ekleneceklerine inanıyorum.
)

$(H5 Sonuç)

$(P
Bu yazı; hem GoF erişicilerinin güvenliliklerine ve tanım ve kullanım kolaylıklarına, hem de STL erişicilerinin ifade gücüne sahip olan aralıkları anlatır. Aralıklar tanım ve kullanım kolaylığı sunarlar, tembel değerlendirmelerden yararlandırırlar, ve ilginç yeni olanaklar sunarlar.
)

$(H5 Teşekkür)

$(P
Bu yazı, şimdiye kadar edindiğim en değerli eleştirilerden geçti. Yazıyı eleştirenlerin bazılarının yazıyı teknik ve edebi açılardan benden daha iyi yazabilecek olduklarını biliyorum. Eğer bu yazıyı beğenmediyseniz eleştiriden geçmemiş halinin çok daha kötü olduğunu bilmek isteyebilirsiniz.
)

$(P
Tabii ki okuduğunuz yazıyı beğendiğinizi umuyorum; bunun için çok çalıştım. Aynı amaç için aynı derecede çok çalışan şu kişilere büyük teşekkür borcum var: Adam Badura, Walter Bright, Ali Çehreli, Emil Dotchevski, Tony Van Eerd, Neil Groves, Craig Henderson, Daniel Hulme, Scott McMurray, Scott Meyers, Bartosz Milewski, Rob Stewart, ve Andrew Sutton.
)

$(P
Normalde eleştirmenler arasında ayrım yapmak istemem. Ama bu sefer Rob Stewart'ı ayrıca anmam gerekiyor. Rob yazının ilk taslağının neredeyse her paragrafı üzerinde fikir belirtti ve bütün yazının yapısı ile ilgili üst düzey yorumlar getirdi. Eğer ilk yazı bir bina olmuş olsaydı; Rob'ın yorumları her bir tuğlasını kapsamış, mimari tasalarına değinmiş, ve en sonunda da şehir ve bölge planlamacılığı konularını çözmüş olurdu.
)

$(H5 Referanslar)

$(P
[1] Harold Abelson ve Gerald J. Sussman. Structure and Interpretation of Computer Programs. MIT Press, Cambridge, MA, USA, 1996.
)

$(P
[2] David Abrahams, Jeremy Siek, ve Thomas Witt. $(LINK2 http://boost.org/doc/libs/1_40_0/libs/iterator/doc/, Boost.Iterator Kütüphanesi). 2003.
)

$(P
[3] David Abrahams, Jeremy Siek, ve Thomas Witt. $(LINK2 http://www.boost.org/doc/libs/1_40_0/libs/iterator/doc/new-iter-concepts.html, New Iterator Concepts). 2006.
)

$(P
[4] Adobe. $(LINK2 http://stlab.adobe.com/, Adobe Source Library).
)

$(P
[5] Andrei Alexandrescu. $(LINK2 http://dlang.org/phobos/std_algorithm.html, Phobos Kütüphanesi'nin std.algorithm Modülü). 2009.
)

$(P
[6] Jeffrey Dean ve Sanjay Ghemawat. "Mapreduce: Simplified Data Processing on Large Clusters." Commun. ACM, 51(1):107–113, 2008.
)

$(P
[7] Erich Gamma, Richard Helm, Ralph Johnson, ve John Vlissides. $(LINK2 http://www.informit.com/store/product.aspx?isbn=0201633612, Design Patterns: Elements of Reusable Object-Oriented Software). Addison-Wesley, Boston, MA, 1995.
)

$(P
[8] Sir Charles Antony Richard Hoare. "Quicksort." The Computer Journal, 5(1):10–16, 1962.
)

$(P
[9] John Hughes. "$(LINK2 http://www.cs.chalmers.se/~rjmh/Papers/whyfp.html, Why Functional Programming Matters)." Comput. J., 32(2):98–107, 1989.
)

$(P
[10] Andrew Koenig. "$(LINK2 http://www.ddj.com/cpp/184401971, Templates and Duck Typing)." Dr. Dobb's Journal, June 2005. .
)

$(P
[11] Joaquín M. López Muñoz. $(LINK2 http://www.boost.org/doc/libs/1_40_0/libs/multi_index/doc/index.html, Boost.MultiIndex Kütüphanesi). 2003.
)

$(P
[12] Thorsten Ottosen. $(LINK2 http://boost.org/doc/libs/1_39_0/libs/range/, Boost Range Kütüphanesi). 2003.
)

$(P
[13] Alexander Stepanov ve Meng Lee. "$(LINK2 http://www.stepanovpapers.com/STL/DOC.PDF, The Standard Template Library)." Technical report, WG21 X3J16/94-0095, 1994.
)

Macros:
        SUBTITLE="Eleman Erişimi Üzerine", Andrei Alexandrescu

        DESCRIPTION=Andrei Alexandrescu'nun 'On Iteration' makalesinin Türkçe çevirisi 'Eleman Erişimi Üzerine'

        KEYWORDS=d programlama dili makale d andrei alexandrescu iteration iterators erişiciler ranges aralıklar
