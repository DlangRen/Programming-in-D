Ddoc

<div class="on_ust">

---

import std.stdio;

void main()
{
    writeln("Merhaba dünya!");
}

---

</div>

<div class="main_page_content">

<style>
div.kitaplar {
    float: left;
    margin: 0 0 1em 2em;
    padding: 2em;
    text-align: center;
}
</style>

<div class="kitaplar">
$(LINK2 /ders/d/index.html, <img style="border-width:0; float:left; margin:0 2em 1em 1em;" src="$(ROOT_DIR)/ders/d/cover_thumb.png" height="180"/>
$(BR)Türkçe)
</div>

<div class="kitaplar">
$(LINK2 /ders/d.en/index.html, <img style="border-width:0; float:left; margin:0 2em 1em 1em;" src="$(ROOT_DIR)/ders/d.en/cover_thumb.png" height="180"/>$(BR)English)
</div>
</div>

$(H4 $(LINK2 /ders/index.html, Bütün kitaplar))

$(H4 $(LINK2 /forum/, Forum))

Macros:
        SUBTITLE=Ana Sayfa

        DESCRIPTION=Türkçe D programlama dili kitabı, forum, dil ile ilgili belgeler, makaleler, kod örnekleri, forum, haberler, ve başka çeşitli bilgiler

        KEYWORDS=d programlama dili kitap ders forum

       BREADCRUMBS=$(BREADCRUMBS_INDEX)
