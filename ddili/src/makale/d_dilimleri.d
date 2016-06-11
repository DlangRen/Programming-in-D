Ddoc

$(H4 D Dilimleri)

$(P
  $(B Yazar:) Steven Schveighoffer
$(BR)
  $(B Çevirmen:) $(LINK2 http://acehreli.org, Ali Çehreli)
$(BR)
  $(B Çeviri Tarihi:) Mayıs 2011
$(BR)
  $(B İngilizcesi:) $(LINK2 http://dlang.org/d-array-article.html, D Slices)
)

$(P
D dilinin en hoş olanaklarından birisi dilimleridir $(ASIL slice). D'den başka bir dil kullandığım zamanlarda hep D dilimlerini arıyorum. Yazımlarının kısalığı ve hızlı olmalarının yanında dilimler çok da kullanışlıdırlar.
)

$(P
Burada D dilimlerinin ve dizilerinin iç yapılarını anlatacağım. Bunları okuduğunuzda D dilimlerinin doğru kullanımlarını ve onların normal dizilerden temelde ne kadar farklı olduklarını göreceğinizi umuyorum.
)

$(H5 Taşmalı Bir Sorun)

$(P
Diziler çoğu dilin bir iç olanağıdır; kendi elemanlarına sahiptirler ve referans türü olarak kullanılırlar. Bütün bu dil yapısına "dizi" adı verilir ve bunlar üzerindeki işlemlerin (değer atama, dinamik dizilere veri ekleme, uzunluk alma vs.) dizi türünün özel işlemleri oldukları söylenir.
)

$(P
D'nin geçmişi C'ye dayanır; diziler C'de yan yana duran veriler olarak tanımlanırlar. C'de dizilere ve dizilerin bölümlerine referans olarak gösterge $(ASIL pointer) kullanılır. C dizilerine erişim sağlayan göstergeler dizinin elemanlarına sahip değillerdir. Desteklenen bütün işlemler, göstergenin belirli miktar ilerisindeki veya gerisindeki verinin değerinin okunması veya o değerin değiştirilmesidir.
)

$(P
C dizilerinin söz dizimini bildiğinizi düşünüyorum; yine de dizi yazımları başka dillerde farklı olduğundan önce C dizilerinin kullanımlarını göstermek istiyorum:
)

---
dizi[0] = 4; /* 'dizi' dizisinin ilk elemanını 4 yapar */
x = dizi[1]; /* 'dizi' dizisinin ikinci elemanının değerini
                x'e kopyalar */
---

$(P
Bunun dışındaki bütün işlemler (uzunluk alma, ekleme, yer ayırma, sonlandırma) kütüphane işlevlerine, tahminlere ve belgelere dayanır. Bunun yanlışı nerededir? C dizilerinin en büyük sorunu, diziye ait olmayan verilere bile gösterge ile erişilebilmesidir. Sıfırdan küçük olan sıra numaraları bile kullanılabilir! Üstelik dizi için kullanılan gösterge türü ile tek değişken için kullanılan gösterge türü aynıdır. Örneğin gösterge türündeki bir işlev parametresi bir dizi olabileceği gibi tek bir değişken de olabilir. Bu, ara bellek taşırma saldırılarının $(ASIL buffer overflow attacks) dayandığı sorundur. Bu konuda daha ayrıntılı bilgi için Walter Bright'ın $(LINK2 http://drdobbs.com/blogs/cpp/228701625, C's Biggest Mistake) (C'nin En Büyük Hatası) makalesini okuyabilirsiniz.
)

$(H5 Dilimler)

$(P
Peki D bu durumu nasıl düzeltir? D dizileri bir çok açıdan C dizilerine benzerler. Hatta D, C'nin göstergeli dizi söz dizimini de destekler. Ancak D, C dizi söz dizimi üzerine kurulu olan $(I dilim) adında yeni bir tür getirir. Dilim, bir dizinin (dinamik olsun olmasın) belirli bir bölümüdür; hem o bölümü gösteren göstergeyi hem de o bölümün uzunluğunu bir arada tutar. Veri uzunluğunun biliniyor olmasının ve verinin depolandığı belleğin çöp toplayıcı tarafından sahipleniliyor olmasının etkisiyle, dilimler çeşitli bellek hatalarına karşı korumalı olan son derece güçlü ve dinamik bir kavramdır. Ek olarak, D dilimlerinin işlevsellikleri, ilk parametreleri dilim olan işlevler yazılarak arttırılabilir. Bu olanak, dilin iç türlerine nitelik ve üye işlev gibi çağrılabilen yeni işlevler eklemeye yarar. Başka dillerdeki eşdeğerlerinin gariplikleri veya yavaşlıkları ile karşılaştırıldıklarında, D dilimlerinin hoş ve kısa söz dizimleri ile çok hızlı işleyen kodlar üretilebilir.
)

$(P
D dilimlerinin nasıl kullanıldıklarına bakalım:
)

---
import std.stdio;

void main()
{
    int[] a;             // a bir dilimdir

    a = new int[5];      // en az 5 elemanı bulunan dinamik
                         // bir tamsayı dizisi için yer ayır
                         // ve bana ilk 5 tanesine eriştiren
                         // bir dilim ver.  D'de bütün veriler
                         // ilklenirler; int'lerin ilk
                         // değerleri 0'dır; o yüzden bu
                         // dizide beş tane 0 vardır

    int[] b = a[0..2];   // Bu bir 'dilimleme' işlemidir. b,
                         // a'nın ilk iki elemanına erişim
                         // sağlamaktadır. D'de sınırın sağ
                         // tarafı "açıktır"; bu yüzden a[2]
                         // dilime dahil değildir.

    int[] c = a[$-2..$]; // c, a'nın son iki elemanına erişim
                         // sağlamaktadır; $, dilimleme ve
                         // indeksleme işleminde uzunluk
                         // anlamına gelir

    c[0] = 4;            // bu a[3]'ü de değiştirir
    c[1] = 5;            // bu a[4]'ü de değiştirir

    b[] = c[];           // a[]'nın ilk iki elemanına son iki
                         // elemanının değerlerini (4, 5) atar

    writeln(a);          // "[4, 5, 0, 4, 5]" yazar

    int[5] d;            // d, program yığıtında duran sabit
                         // uzunluklu bir dizidir
    b = d[0..2];         // dilimler sabit uzunluklu dizilere
                         // de erişim sağlayabilirler!
}
---

$(P
Dizinin oluşturulmasıyla ilgili açıklamayı şaşırtıcı bulabilirsiniz: "en az 5 elemanı bulunan dinamik bir tamsayı dizisi için yer ayır ve bana ilk 5 tanesine eriştiren bir dilim ver". Neden yalnızca "5 elemanı bulunan dizi için yer ayır" değil? Deneyimli programcılar bile bazen D'nin dizi kavramlarıyla ilgili karışıklıklar yaşarlar; haksız oldukları söylenemez. Göründüklerinin aksine, D dilimleri normal dinamik dizi türleri $(I değillerdir) (en azından perde arkasında). Dilimler, her türlü diziye (dinamik olsun olmasın) güvenli ve basit bir $(I arayüz) sunarlar. D dilimleri hakkındaki belki de en yaygın olan yanılgıya geçelim.
)

$(H5 Sorumlusu Kim?)

$(P
D dilimleri hemen hemen bütün açılardan dinamik dizilere benzerler—normalde işlevlere referans olarak gönderilirler ve dinamik dizilerin sahip olmaları beklenen bütün işlevlere ve niteliklere sahiptirler. Ancak bir açıdan çok farklıdırlar. Dilim diziye $(I sahip değildir), ona $(I erişim sağlar). Bunun anlamı, dilimin verilerin oluşturulmalarından ve sonlandırılmalarından sorumlu olmadığıdır. Dinamik dizilerin belleklerinden sorumlu olan, D $(I çalışma ortamıdır) $(ASIL D runtime).
)

$(P
Peki D'nin gerçek dinamik dizi türü nerededir? Dinamik dizi kavramı çalışma ortamı içinde gizlidir ve aslında resmi bir türü yoktur. Dilimler yeterlidir; hatta veri ile ne yapılmak istendiğini çalışma ortamı anlayabildiği için, dinamik dizilerin başlıca tür olmadıklarının farkına bile varılmaz. Dahası, çoğu D programcısı D dilimlerinin dinamik dizilerle $(I aynı) tür olduklarını düşünür—dilimler D'nin resmi tanım belgelerinde bile dinamik dizi türü olarak geçerler! Elemanlara sahip olunmadığı gerçeği çok ince bir noktadır ve kolayca gözden kaçabilir.
)

$(P
Bunun doğurduğu bir sonuç; $(C length)'in dizilerin değil, dilimlerin niteliği olduğudur; yani $(C length) dizinin değil, dilimin uzunluğunu bildirir. Bu, dile yeni başlayanlara karışık gelen bir konudur. Örneğin aşağıdaki kodda bununla ilgili olan büyük bir yanlışlık vardır:
)

---
import std.stdio;

void kısalt(int[] dizi)
{
    if(dizi.length > 2)
        dizi.length = 2;
}

void main()
{
   int[] dizi = new int[5];
   kısalt(dizi);
   dizi.kısalt();      // üye işlev gibi de çağrılabilmektedir
   writeln(dizi.length); // 5 yazar
}
---

$(P
Gönderilen $(C dizi)'nin uzunluğunu 2 olarak değiştiriyor gibi görünse de o işlevin aslında hiçbir etkisi yoktur (bunu $(C writeln)'ın çıktısında görüyoruz). Bunun nedeni, verinin referans olarak gönderilmiş olmasına karşın dilimin parçası olan göstergenin ve uzunluğun değer olarak gönderilmiş olmalarıdır. Bir çok dilde bütünüyle referans olarak gönderilen dizi türleri vardır. Örneğin C# ve Java dizileri, referans olarak gönderilen $(C Object) nesneleridir. C++'ın $(C vector) türü; hem veriyi hem de nitelikleri ya hep birden referans olarak, ya da hep birden değer olarak geçirir.
)

$(P
Bu sorunu gidermek için iki çözüm vardır. Ya dilim $(C ref) anahtar sözcüğü ile açıkça referans olarak gönderilir ya da sonuç dilim asıl dilime atanmak üzere işlevden döndürülür. Örneğin dilimin referans olarak gönderilmesi için işlev şöyle değiştirilir:
)

---
void kısalt(ref int[] dizi)
---

$(P
Bu değişikliği yaptığımızı düşünelim; kısaltma işleminden sonra ikinci elemandan ötedeki verilere ne olur? D'de dilimler verilere sahip olmadıklarından o elemanlar dinamik diziye ait olmaya devam ederler ve geçerliliklerini korurlar. Bunun temel nedeni, aynı veriye başka bir dilim tarafından da erişim sağlanıyor olabilmesidir! $(I Tek) dilim veriye sahip olmadığından, hiçbir dilim veriye başka hangi dilimler tarafından erişim sağlandığı yolunda tahminde bulunamaz.
)

$(P
Peki o veriye artık hiçbir dilim erişim sağlamadığında ne olur? Bu, D'nin çöp toplayıcısı ile ilgili bir konudur. Artık hiçbir dilim tarafından erişim sağlanmayan dinamik dizilerin sonlandırılmaları çöp toplayıcının görevidir. Hatta, D'nin dilimlerinin var olabilmeleri büyük ölçüde çöp toplayıcı sayesindedir; bellek sızıntısı, dilimlerin birbirlerinin üzerlerine yazmaları, veya dizi yaşam süreçleri gibi kaygılara hiç düşmeden dinamik dizileri istediğiniz gibi dilimleyebilirsiniz.
)

$(H5 Dilimlere Eleman Eklemek)

$(P
Gerçek dinamik dizilerde olduğu gibi D dilimlerine de eleman eklenebilir. Ekleme ve birleştirme için $(C ~) işleci kullanılır. Dizilerin ekleme ve birleştirme işlemleri aşağıdaki gibidir:
)

---
int[] a;     // boş dilim hiçbir veriye erişim sağlamaz ama
             // kendisine yine de eleman eklenebilir

a ~= 1;      // eleman eklenir; elemanları tutmak için
a ~= 2;      // otomatik olarak yeni bir dizi oluşturulur

a ~= [3, 4]; // başka bir dizi eklenir; burada 'dizi hazır
             // değeri' (array literal) ekleniyor
a = a ~ a;   // a'yı kendisi ile birleştirir; şimdi a'nın
             // durumu şudur: [1, 2, 3, 4, 1, 2, 3, 4]

int[5] b;    // program yığıtındaki sabit uzunluklu bir dizi
a = b[1..$]; // şimdi a, b'nin bir dilimidir
a ~= 5;      // bu işlemden önce a yığıttaki verilere erişim
             // sağlamakta olduğundan, sonuna eklemek yeni
             // yer ayrılmasına neden olur ve herşey
             // beklendiği gibi çalışır
---

$(P
Performansa önem veren okuyucular o dört eleman eklendiğinde neler olup bittiğini merak edeceklerdir. Dilim kendi verilerine sahip olmadığına göre her eleman ekleme işleminde yeni bellek ayrılması nasıl önlenebilir? D dilimlerinin temel bir şartı etkin olmalarıdır; aksi taktirde programcılar tarafından benimsenmezlerdi. D'nin bu konuda getirdiği çözüm programcılar tarafından hemen hemen hiç farkedilmez; ve dilimler işte bu yüzden gerçek dinamik dizilere çok benzerler.
)

$(H5 Nasıl Çalışır)

$(P
"En az 5 elemanı bulunan dinamik bir dizi için yer ayır" dediğimi hatırlıyor musunuz? İşte çalışma ortamı bu noktada devreye girer. Gereken bellek bir $(I bellek sayfasına) $(ASIL page) (32 bitlik x86 sistemlerinde 4096 baytlık bölge) sığdığında, bellek ayıran birim hep 2'nin katları uzunlukta bellek bölgeleri ayırır; daha fazla bellek gereken durumlarda ise yeteri kadar sayfa ayırır. Yani bir dizi ayrıldığında çoğu durumda asıl gerekenden daha fazla yer ayrılmış olabilir. Örneğin toplam 20 bayt yer tutan beş adet int için yer gerektiğinde aslında 32 baytlık yer ayrılır. Bunun sonucunda da 3 int'lik daha yer var demektir.
)

$(P
Kolayca görülebileceği gibi, dizinin yerini değiştirmeye gerek kalmadan eleman eklemek mümkündür. Ancak, mevcut başka verilerin üzerine yazılmasını $(ASIL stomping) önlemek de şarttır. Hatırlarsanız, dilimin o verinin başka dilimler tarafından da eriştirilip eriştirilmediğini bilemiyor olmasının yanında, kendisinin bile dizinin hangi bölümüne erişim sağladığından haberi yoktur (baştaki elemanlara da erişim sağlıyor olabilir ortadakilere de). Bu düzeneği doğru olarak işletebilmek için, çalışma ortamı bellek bölgesinin ne kadarının $(I kullanımda) olduğunu ayırdığı bellek bloğunun içine yazar. (Bunun sonucunda da boş olan yer aslında daha azdır. Örneğin yukarıdaki örnekte yeni bellek ayırmak gerekmeden kullanılabilecek tamsayı adedi aslında 7'dir.)
)

$(P
Bir dilime eleman eklemek istediğimizde, çalışma ortamı önce bloğun eklenebilir olduğuna (yani $(I kullanımda) alanının geçerli olduğuna) ve dilim ile geçerli verilerin aynı noktada $(I sonlandıklarına) bakar (dilimin nerede başladığının önemi yoktur). Çalışma ortamı yeni verinin bellek bölgesinin son tarafına sığıp sığmayacağına da bakar. Eğer bu iki durum da geçerliyse, yeni veri dizinin sonundaki boş yere yazılır ve bloğun ne kadarının $(I kullanımda) olduğunu gösteren değer buna uygun olarak arttırılır. İki durumdan birisi bile geçersizse hem dizideki eski verileri hem de yeni verileri alabilecek kadar büyük yeni bir bellek bölgesi ayrılır ve bütün veriler buraya kopyalanırlar. Peki eski bloğa ne olur? Eğer onu kullanan başka dilimler varsa hiçbir şey olmaz. Eğer ona erişim sağlayan başka hiçbir referans yoksa o bölge artık çöp olarak kabul edilir ve çöp toplayıcının bir sonraki temizlik işlemi sırasında, daha sonradan başka bir amaçla kullanılmak üzere hazır hale getirilir. Dilimler diğer dilimleri geçersiz hale getirmeden böylece başka yere taşınabilirler. Bu durum, dizi taşıma ve vector'e eleman ekleme işlemlerinin aynı elemanlara erişim sağlamakta olan başka referansları (göstergeleri $(ASIL pointer) ve erişicileri $(ASIL iterator)) geçersiz hale getirdikleri C ve C++ dillerindeki durumlardan çok farklıdır.
)

$(P
Sonuçta hem hızlı hem de bir çok açıdan kullanışlı olan bir ekleme işlemi sağlanmış olur. Hız veya veri bozulması gibi kaygılardan arınmış olarak dilimlere istediğiniz biçimde ekleme yapabilirsiniz. Dilimin erişim sağladığı verinin ne yığında $(ASIL heap), program yığıtında $(ASIL stack), veya ROM'da bulunup bulunmadığının ne de $(C null) olup olmadığının bilinmesi gerekir. Ekleme işlemi programcı açısından her zaman için başarıyla sonuçlanır (yeterli bellek olduğunu kabul edersek); duruma göre farklı olabilen işlemler perde arkasında çalışma ortamı tarafından halledilir.
)

$(H5 Belirsizlik)

$(P
Ekleme işleminin deneyimli D programcılarını bile yanıltan bir özelliği, bu işlemin sonucunun belirsizmiş gibi algılanabilmesidir.
)

$(P
Verilen diziye belirtilen sayıda A yazan (gerekiyorsa ekleyen) ve doldurduğu diziyi döndüren şöyle bir işlev olsun:
)

---
import std.stdio;

char[] A_doldur(char[] dizi, size_t adet)
{
   if(dizi.length < adet)
      dizi.length = adet; // uzunluğu, bütün A'ları tutacak
                          // kadar arttır
   dizi[0..adet] = 'A';   // bütün elemanları A yap
   return dizi[0..adet];  // sonucu döndür
}

void main()
{
   char[] dizgi = new char[10];  // bunun için ayrılan bloğun
                                 // kapasitesi 15 elemandır
   dizgi[] = 'B';
   A_doldur(dizgi, 20); // başka yere taşınması gerekir (20 > 15)
   writeln(dizgi);      // "BBBBBBBBBB"
   A_doldur(dizgi, 12); // taşınmadan uzayabilir (12 <= 15)!
   writeln(dizgi);      // "AAAAAAAAAA"
}
---

$(P
$(C A_doldur) işlevinin hatası nedir? Hatası yoktur; peki uzunluğun arttırılması dizinin taşınmasını gerektiriyorsa ne olur? O durumda işleve gönderilen dizi değil, taşınmış olan dizi A'larla doldurulur. Bu da aynı dizinin tekrar kullanılacağı durumlarda veya gönderilen dizinin A'larla doldurulmasının istendiği durumlarda şaşırtıcı olmaktadır. Sonuçta, $(C dizi[])'nin bulunduğu bellek bloğunun taşıma gerekmeden eklenebilmesine bağlı olarak gönderilen dizi A'larla doldurulmuş olabilir de olmayabilir de.
)

$(P
Biraz düşününce, bu belirsizliği önlemenin tek yolunun dizinin her ekleme işleminde kopyalanması olduğunu görürüz—yeni verinin bir yere yazılmasının gerektiği doğrudur ama sistem, veriye erişim sağlayan her dilimin hesabını tutamaz. Neyse ki bu durumun etkisini azaltacak iki seçenek vardır:
)

$(OL

$(LI İşlevin dönüş türünü tekrar dilime atamak. Dikkat ederseniz bu işlevin en önemli sonucu dönüş türüdür; dilimin kullanılıp kullanılmadığının işlev açısından önemi yoktur.)

$(LI İşleve gönderilen dilimi artık kullanmamak. Gönderilen dilim bir daha kullanılmazsa onunla ilgili bir sorun da kalmaz.)

)

$(P
İşlevin yazarı da bu sorunları önleyebilir. Dikkat edilirse, bu sorun yalnızca gönderilen dilime ek yapıldıktan veya uzunluğu değiştirildikten $(B sonra) dilimin başlangıçtaki bölümüne yazıldığında ortaya çıkmaktadır. Bu durum önlenebildiğinde dilimlerle ilgili bu belirsizlik de ortadan kalkmış olur. Çalışma ortamının dilimi nasıl kullanacağıyla ilgili bilgi edinmeye yarayan nitelikleri biraz sonra göreceğiz. Gönderilen dilimin değiştirilip değiştirilmeyeceğinin belirsiz olduğu da işlevin belgesinde belirtilebilir.
)

$(P
Son bir seçenek, gönderilen dilimin değişeceğini göstermiş olmak için işlev parametresini $(C ref) olarak tanımlamaktır. Dilimin sağ değer $(ASIL rvalue) olabildiği gibi durumlarda bu her zaman mümkün olmayabilir. Ayrıca bu, aynı veriye erişim sağlamakta olan başka referanslar için de çözüm olamaz.
)

$(H5 Meta Bilgiyi Kaydetmek $(ASIL Caching))

$(P
Dilimlerle ilgili başka bir konu, ekleme işleminin hızlı olması ama yeterince hızlı olamamasıdır. Blokla ilgili meta bilginin (başlangıç adresinin, uzunluğunun ve kullanımda olan miktarın) her ekleme işleminde tekrardan okunması gerekir. Bunun anlamı, her ekleme işlemi sırasında çöp toplayıcının bellek bölgeleri içinde O(lg(n)) karmaşıklığında bir arama yapılacak olduğudur (çöp toplayıcının evrensel kilidinin sahiplenilmesi de gerekir). Oysa istenen, her eklemenin amortize sabit zamanda $(ASIL amortized constant time) gerçekleşmesidir. Bu hedefe, bildiğim kadarıyla yalnızca D'de bulunan ve meta bilgiyi kaydetmeye dayanan bir yöntemle ulaşılır.
)

$(P
D2'de varsayılan depolama biçimi iş parçacığına özeldir $(ASIL thread local). Bunun sonucunda, yığındaki verinin tek iş parçacığına mı ait olduğunu (çoğu böyledir) veya bütün iş parçacıkları tarafından mı paylaşıldığını artık tür sisteminden öğrenebiliyoruz. Bundan yararlanarak, blokla ilgili meta bilginin kilit gerektirmeyen ve her iş parçacığına özel olan bir kayıt $(ASIL cache) olarak saklanması mümkün olabilmektedir. Bu kayıt, blok meta bilgisinin son sorgulamalarının belirli sayıdaki cevabını saklar ve böylece bir dilimin sonuna eklenip eklenemeyeceği hızlıca öğrenilebilir.
)

$(P
Bu kilitsiz sorgulama yöntemi, ekleme işlemini elemanların üstüne yazma tehlikesini taşıyan D1'den bile daha hızlı hale getirmiştir.
)

$(H5 Dilim Üyeleri ve $(C Appender))

$(P
D dilimlerinin bu ilginç davranışları, ekleme sonucunda ne olacağının baştan bilinebilmesi ihtiyacını da doğurur. Bunu karşılamak için dilimlere çok sayıda nitelik ve işlev eklenmiştir.
)

$(P
$(C size_t reserve(size_t n)): Dilime n adet eleman barındırabilecek kadar yer ayırır. Eğer dilim taşınmadan eklenebiliyorsa ve n adet elemana yeri varsa (burada n, mevcut ve yeni eklenecek olan elemanların toplamıdır) hiçbir değişiklik olmaz. Dönüş değeri, dilimin kapasitesidir.
)

---
int[] dilim;
dilim.reserve(50);
foreach(int i; 0..50)
    dilim ~= i;        // taşıma gerekmez
---

$(P
$(C size_t capacity): Dilimin ekleme sonucunda kaç eleman tutabileceğini belirtir. Eğer dilime taşıma gerekmeden eklenemiyorsa bu değer 0'dır. Eğer 0 değilse, döndürülen değer mevcut elemanların adedini de içerir.
)

---
int[] dilim = new int[5];
assert(dilim.capacity == 7);  // mevcut 5 eleman dahil
int[] dilim2 = dilim;
dilim.length = 6;
assert(dilim.capacity == 7);  // taşımadan eklemek kapasiteyi
                              // değiştirmez
assert(dilim2.capacity == 0); // dilim2'ye taşımadan eklenemez
                              // yoksa dilim'in altıncı
                              // elemanının üstüne yazar
---

$(P
$(C assumeSafeAppend():) Dilimin sonuna eklenmesinin güvenli olduğunu çalışma ortamına bildirir. Bunun etkisi, dizinin ne kadarının kullanımda olduğunu belirten meta bilginin bu dilimin sonuna göre ayarlanmasıdır.
)

---
int[] dilim = new int[5];
dilim = dilim[0..2];
assert(dilim.capacity == 0); // güvenli değildir çünkü bu
                             // blokta geçerli olan başka
                             // veriler bulunmaktadır
dilim.assumeSafeAppend();
assert(dilim.capacity == 7); // kullanımda olan eleman bilgisi
                             // 2 olarak değiştirilmiştir
---

$(P
D dilimlerine ekleme işlemlerini yine de yeterince hızlı bulmuyorsanız bir seçeneğiniz daha vardır. $(C std.array.Appender), elemanları çalışma ortamından blokla ilgili bilgi edinmeyi gerektirmeden ve en hızlı biçimde ekler. $(C Appender), $(I çıkış aralığı) kavramını ekleme işlemi olarak sunar (normalde çıkış aralığı olarak kullanıldıklarında dilimler kendi elemanlarının üzerine yazarlar). Aralıklar ve $(C Appender) hakkında daha fazla bilgi için $(LINK2 http://d-programming-language.org/, D belgelerine) bakabilirsiniz. ($(I Çevirmenin notu: Aralıklarla ve $(C Appender) ile ilgili Türkçe bilgiler için de $(LINK2 /ders/d/araliklar.html, Aralıklar dersine) bakabilirsiniz.))
)

$(H5 Sonuç)

$(P
D'nin dizileri ve dilimleri, ustaların ve yeni başlayanların ihtiyaç duyacakları dizi türleriyle ilgili bütün kullanımları son derece zengin olanaklar halinde sunarlar. D dilimleri, değerlerinin ancak başka diller kullanılmak zorunda kalındığında farkedildiği, çok hızlı ve kullanışlı olanaklardır. D'yi henüz iyi tanımayan programcıların hiç olmazsa D'nin dilimlerine biraz zaman ayırmalarını ve dizi programcılığının ne kadar kolay olabileceğini görmelerini öneririm.
)

$(HR)

$(P
$(I David Gileadi, Andrej Mitrovic, Jesse Phillips, Alex Dovhal, Johann MacDonagh, ve Jonathan Davis'e bu makale üzerindeki görüşleri ve önerileri için teşekkür ederim.)
)

$(P
© 2011 by Steven Schveighoffer
Creative Commons License
This work is licensed under a $(LINK2 http://creativecommons.org/licenses/by-nd/3.0/, Creative Commons Attribution-NoDerivs 3.0 Unported License).
)

Macros:
        SUBTITLE="D Dilimleri", Steven Schveighoffer

        DESCRIPTION=Steven Schveighoffer'in D en kullanışlı olanaklarından olan dilimlerin ayrıntıların anlattığı "D Slices" makalesinin Türkçe çevirisi 'D Dilimleri'

        KEYWORDS=d programlama dili makale d steven schveighoffer d slices dilim
