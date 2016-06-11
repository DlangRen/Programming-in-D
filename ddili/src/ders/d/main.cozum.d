Ddoc

$(COZUM_BOLUMU Programın Çevresiyle Etkileşimi)

$(OL

$(LI

---
import std.stdio;
import std.conv;

int main(string[] parametreler) {
    if (parametreler.length != 4) {
        stderr.writeln(
            "HATA! Doğru kullanım: \n    ", parametreler[0],
            " bir_sayı işlem başka_sayı");
        return 1;
    }

    immutable birinci = to!double(parametreler[1]);
    string işlem = parametreler[2];
    immutable ikinci = to!double(parametreler[3]);

    switch (işlem) {

    case "+":
        writeln(birinci + ikinci);
        break;

    case "-":
        writeln(birinci - ikinci);
        break;

    case "x":
        writeln(birinci * ikinci);
        break;

    case "/":
        writeln(birinci / ikinci);
        break;

    default:
        throw new Exception("Geçersiz işlem: " ~ işlem);
    }

    return 0;
}
---

)

$(LI

---
import std.stdio;
import std.process;

void main() {
    write("Başlatmamı istediğiniz program satırını yazın: ");
    string komutSatırı = readln();

    writeln("Çıktısı: ", executeShell(komutSatırı));
}
---

)

)

Macros:
        SUBTITLE=Programın Çevresiyle Etkileşimi Problem Çözümleri

        DESCRIPTION=D dilinde programın ana fonksiyonu olan main'in parametreleri ve dönüş türü ile ilgili bölümün problem çözümleri

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial işlev fonksiyon function parametre main dönüş değeri problem çözüm
