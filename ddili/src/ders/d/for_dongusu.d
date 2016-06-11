Ddoc

$(DERS_BOLUMU $(IX for) $(IX döngü, for) $(CH4 for) Döngüsü)

$(P
$(LINK2 /ders/d/while_dongusu.html, $(C while) döngüsü) ile aynı işe yarar. Yararı, döngü ile ilgili bütün tanımların tek satırda yapılmasıdır.
)

$(P
$(C for) döngüsü $(C foreach) döngüsünden çok daha az kullanılır. Buna rağmen, $(C for) döngüsünün nasıl işlediği de iyi bilinmelidir. $(C foreach) döngüsünü daha sonraki bir bölümde göreceğiz.
)

$(H5 $(C while)'ın bölümleri)

$(P
Hatırlarsak, $(C while) döngüsü tek bir koşul denetler ve o koşul doğru olduğu sürece döngüye devam eder. Örneğin 1'den 10'a kadar olan bütün tamsayıları yazdıran bir döngü "sayı 11'den küçük olduğu sürece" şeklinde kodlanabilir:
)

---
    while (sayı < 11)
---

$(P
O döngünün $(I ilerletilmesi), $(C sayı)'nın döngü içinde bir arttırılması ile sağlanabilir:
)

---
        ++sayı;
---

$(P
Kodun derlenebilmesi için $(C sayı)'nın $(C while)'dan önce tanımlanmış olması gerekir:
)

---
    int sayı = 1;
---

$(P
Döngünün asıl işlemlerini de sayarsak, bütün bölümlerine değinmiş oluruz:
)

---
        writeln(sayı);
---

$(P
Bu dört işlemi $(I döngünün hazırlığı), $(I devam etme koşulunun denetimi), $(I asıl işlemleri), ve $(I ilerletilmesi) olarak açıklayabiliriz:
)

---
    int sayı = 1;           // ← hazırlık

    while (sayı < 11) {     // ← devam koşulu
        writeln(sayı);      // ← asıl işlemler
        ++sayı;             // ← döngünün ilerletilmesi
    }
---

$(P
$(C while) döngüsü sırasında bu bölümler şu sırada işletilirler:
)

$(MONO
hazırlık

koşul denetimi
asıl işlemler
ilerletilmesi

koşul denetimi
asıl işlemler
ilerletilmesi

...
)

$(P
Hatırlayacağınız gibi, bir $(C break) deyimi veya atılmış olan bir hata da döngünün sonlanmasını sağlayabilir.
)

$(H5 $(C for)'un bölümleri)

$(P
$(C for) döngüsü bu dört işlemden üçünü tek bir tanıma indirgeyen deyimdir. Bu işlemlerin üçü de $(C for) deyiminin parantezi içinde, ve aralarında noktalı virgül olacak şekilde yazılırlar. Asıl işlemler ise kapsam içindedir:
)

---
for (/* hazırlık */; /* devam koşulu */; /* ilerletilmesi */) {
    /* asıl işlemler */
}
---

$(P
Yukarıdaki $(C while) döngüsü $(C for) ile yazıldığında çok daha düzenli bir hale gelir:
)

---
    for (int sayı = 1; sayı < 11; ++sayı) {
        writeln(sayı);
    }
---

$(P
Bu, özellikle döngü kapsamının kalabalık olduğu durumlarda çok yararlıdır: döngüyü ilerleten işlem, kapsam içindeki diğer ifadeler arasında kaybolmak yerine, $(C for) ile aynı satırda durur ve kolayca görülür.
)

$(P
$(C for) döngüsünün bölümleri de $(C while)'ın bölümleriyle aynı sırada işletilirler.
)

$(P
$(C break) ve $(C continue) deyimleri $(C for) döngüsünde de aynı şekilde çalışırlar.
)

$(P
$(C while) ve $(C for) döngüleri arasındaki tek fark, $(C for)'un hazırlık bölümünde tanımlanmış olan değişkenin isim alanıdır. Bunu aşağıda açıklıyorum.
)

$(P
Çok sık olarak döngüyü ilerletmek için bir tamsayı kullanılır, ama öyle olması gerekmez. Ayrıca, döngü değişkeni arttırılmak yerine başka bir biçimde de değiştirilebilir. Örneğin belirli bir değer aralığındaki kesirli sayıların sürekli olarak yarılarını gösteren bir döngü şöyle yazılabilir:
)

---
    for (double sayı = 1; sayı > 0.001; sayı /= 2) {
        writeln(sayı);
    }
---

$(P
$(B Not:) Bu başlık altında yukarıda anlatılanlar teknik açıdan doğru değildir ama $(C for) döngüsünün hemen hemen bütün kullanımlarını karşılar. Bu, özellikle C'den veya C++'tan gelen programcıların kodları için geçerlidir. Aslında $(C for) döngüsünün noktalı virgüllerle ayrılmış olan üç bölgesi $(I yoktur): İlkini hazırlık ve koşul bölümlerinin paylaştıkları yalnızca iki bölgesi vardır. Bu söz diziminin ayrıntılarına burada girmek yerine, hazırlık bölümünde iki değişken tanımlayan aşağıdaki kodu göstermekle yetineceğim:
)

---
    for ($(HILITE {) int i = 0; double d = 0.5; $(HILITE }) i < 10; ++i) {
        writeln("i: ", i, ", d: ", d);
        d /= 2;
    }
---

$(P
Hazırlık bölümü sarı küme parantezleri arasındaki bölgedir. Dikkat ederseniz onunla koşulun arasında noktalı virgül yoktur.
)

$(H5 Döngünün üç bölümü de boş bırakılabilir)

$(P
Gereken durumlarda isteğe bağlı olarak, bu bölümler boş bırakılabilir:
)

$(UL
$(LI Bazen hazırlık için bir değişken tanımlamak gerekmez çünkü zaten tanımlanmış olan bir değişken kullanılacaktır
)
$(LI Bazen döngüyü sonlandırmak için döngü koşulu yerine döngü içindeki $(C break) satırlarından yararlanılır
)
$(LI Bazen döngüyü ilerletme adımı belirli koşullara bağlı olarak döngü içinde yapılabilir
)
)

$(P
Bütün bölümler boş bırakıldığında, $(C for) döngüsü $(I sonsuza kadar) anlamına gelir:
)

---
    for ( ; ; ) {
        // ...
    }
---

$(P
Öyle bir döngü, örneğin ya hiç çıkılmayacak şekilde, veya belirli bir koşul gerçekleştiğinde $(C break) ile çıkılacak şekilde tasarlanmış olabilir.
)

$(H5 Döngü değişkeninin geçerli olduğu kapsam)

$(P
$(C for) ile $(C while)'ın tek farkı, döngü hazırlığı sırasında tanımlanan ismin geçerlilik alanıdır: $(C for) döngüsünün hazırlık bölgesinde tanımlanan isim, yalnızca döngü içindeki kapsamda geçerlidir (ve onun içindekilerde), dışarıdaki kapsamda değil:
)

---
    for (int i = 0; i < 5; ++i) {
        // ...
    }

    writeln(i);   $(DERLEME_HATASI)
                  //   i burada geçerli değildir
---


$(P
$(C while) döngüsünde ise, isim $(C while)'ın da içinde bulunduğu kapsamda tanımlanmış olduğu için, $(C while)'dan çıkıldığında da geçerliliğini korur:
)

---
    int i = 0;

    while (i < 5) {
        // ...
        ++i;
    }

    writeln(i);   // ← 'i' burada hâlâ geçerlidir
---

$(P
$(C for) döngüsünün bu ismin geçerlilik alanını küçük tutuyor olması, bir önceki bölümün sonunda anlatılanlara benzer şekilde, programcılık hatası risklerini de azaltır.
)

$(PROBLEM_COK

$(PROBLEM

İç içe iki $(C for) döngüsü kullanarak, ekrana satır ve sütun numaralarını gösteren 9'a 9'luk bir tablo yazdırın:

$(SHELL
0,0 0,1 0,2 0,3 0,4 0,5 0,6 0,7 0,8 
1,0 1,1 1,2 1,3 1,4 1,5 1,6 1,7 1,8 
2,0 2,1 2,2 2,3 2,4 2,5 2,6 2,7 2,8 
3,0 3,1 3,2 3,3 3,4 3,5 3,6 3,7 3,8 
4,0 4,1 4,2 4,3 4,4 4,5 4,6 4,7 4,8 
5,0 5,1 5,2 5,3 5,4 5,5 5,6 5,7 5,8 
6,0 6,1 6,2 6,3 6,4 6,5 6,6 6,7 6,8 
7,0 7,1 7,2 7,3 7,4 7,5 7,6 7,7 7,8 
8,0 8,1 8,2 8,3 8,4 8,5 8,6 8,7 8,8 
)

)

$(PROBLEM
Bir veya daha fazla $(C for) döngüsü kullanarak ve $(C *) karakterini gereken sayıda yazdırarak geometrik şekiller çizdirin:

$(SHELL
*
**
***
****
*****
)

$(SHELL
********
 ********
  ********
   ********
    ********
)

$(P
vs.
)

)

)


Macros:
        SUBTITLE=for Döngüsü

        DESCRIPTION=D dilinin for döngüsünün tanıtılması

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial for döngüsü döngü

SOZLER=
$(deyim)
$(dongu)
$(kapsam)
