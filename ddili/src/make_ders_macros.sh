#!/bin/bash

butun_hedefler=$1
butun_ders_links=$2

# Once toplam ders adedini bulalim
total_ders=0
for hedef in $butun_ders_links; do
    let ++total_ders
done;

for hedef in $butun_hedefler; do
    ders_html=`echo /$hedef | sed 's/.d.macros.ddoc/.html/'`
    count=1

    echo > $hedef

    for link in $butun_ders_links; do
        if [ $link = $ders_html ]; then
            let prev=$count-1
            let next=$count+1

            echo -n 'DERS_NAV_GERI=$(LINK2 $(ROOT_DIR)' >> $hedef
            echo -n $butun_ders_links | awk "{print \$$prev}" >> $hedef
            echo ', [&nbsp;↢&nbsp;$(GERI_METIN)&nbsp;])' >> $hedef
            echo >> $hedef

            # Sonuncusunda [Ileri->] baglantisi secili olmasin
            if [ $count == $total_ders ]; then
                echo -n 'DERS_NAV_ILERI=' >> $hedef
                echo -n '[&nbsp;$(ILERI_METIN)&nbsp;↣&nbsp;]' >> $hedef
                echo >> $hedef
            else
                echo -n 'DERS_NAV_ILERI=$(LINK2 $(ROOT_DIR)' >> $hedef
                echo -n $butun_ders_links | awk "{print \$$next}" >> $hedef
                echo ', [&nbsp;$(ILERI_METIN)&nbsp;↣&nbsp;])' >> $hedef
                echo >> $hedef
            fi;

            cozum_html=`echo $ders_html | sed 's/.html/.cozum.html/'`

            echo 'COZUM_HTML=$(ROOT_DIR)'$cozum_html >> $hedef
            echo >> $hedef

        fi;
        let ++count ;
    done;
done;
