Ddoc

$(DERS_BOLUMU $(IX writeln) $(IX write) $(CH4 writeln) ve $(CH4 write))

$(P
Bundan önceki bölümde, yazdırılmak istenen dizginin $(C writeln)'e parantez içinde verildiğini gördük.
)

$(P
Programda $(C writeln) gibi iş yapan birimlere $(I işlev), o işlevlerin işlerini yaparken kullanacakları bilgilere de $(I parametre) adı verilir. Parametreler işlevlere parantez içinde verilirler.
)

$(P
$(C writeln) satıra yazdırmak için bir seferde birden fazla parametre alabilir. Parametrelerin birbirleriyle karışmalarını önlemek için aralarında virgül kullanılır.
)

---
import std.stdio;

void main() {
    writeln("Merhaba dünya!", "Merhaba balıklar!");
}
---

$(P
Bazen, aynı satıra yazdırılacak olan bütün bilgi $(C writeln)'e hep birden parametre olarak geçirilebilecek şekilde hazır bulunmayabilir. Böyle durumlarda satırın baş tarafları $(C write) ile parça parça oluşturulabilir ve satırdaki en sonuncu bilgi $(C writeln) ile yazdırılabilir.)

$(P
$(C writeln) yazdıklarının sonunda yeni bir satıra geçer, $(C write) aynı satırda kalır:
)

---
import std.stdio;

void main() {
    // Önce elimizde hazır bulunan bilgiyi yazdırıyor olalım:
    write("Merhaba");

    // ... arada başka işlemlerin yapıldığını varsayalım ...

    write("dünya!");

    // ve en sonunda:
    writeln();
}
---

$(P
$(C writeln)'i parametresiz kullanmak, satırın sonlanmasını sağlar.
)

$(P
$(IX //) $(IX açıklama) Başlarında $(COMMENT //) karakterleri bulunan satırlara $(I açıklama satırı) adı verilir. Bu satırlar programa dahil değildirler; programın bilgisayara yaptıracağı işleri etkilemezler. Tek amaçları, belirli noktalarda ne yapılmak istendiğini programı daha sonra okuyacak olan kişilere açıklamaktır.
)

$(PROBLEM_COK

$(PROBLEM

Buradaki programların ikisi de dizgileri aralarında boşluk olmadan birbirlerine yapışık olarak yazdırıyorlar; bu sorunu giderin

)

$(PROBLEM
$(C write)'ı da birden fazla parametreyle çağırmayı deneyin
)

)

Macros:
        SUBTITLE=writeln ve write

        DESCRIPTION=D dilindeki yazdırma işlevlerinden writeln ve write

        KEYWORDS=d programlama dili dersleri öğrenmek tutorial writeln write

SOZLER= 
$(aciklama)
$(islev)
$(parametre)
