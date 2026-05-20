#!/bin/sh

# To create FST stems for the “initial” list”:
# •	[column 6][ column 1 ]:[column 6][column 2]\t[column 5] ;
# To create FST stems for the “person” list:
# •	[column 6][ column 1 ]:[column 6][column 3]\t[column 5] ;
# To create FST stems for the “elsewhere” list:
# •	[column 6][ column 1 ]:[column 6][column 4]\t[column 5] ;


gawk -F"\t" '{
  stem=$1;
  initial=$2;
  person=$3;
  elsewhere=$4;
  contlex=$5;
  flags=$6;
  notes=$7;

  if(match(contlex, "NA")!=0)
    pos="NA";
  if(match(contlex, "NI")!=0)
    pos="NI";

  if(contlex=="")
    check="CHECK";
  else
    check="";  

  if(notes!="")
    initlexc=sprintf("%s%s:%s%s %s ; ! %s\n", flags, stem, flags, initial, contlex, notes);
  else
    initlexc=sprintf("%s%s:%s%s %s ;\n", flags, stem, flags, initial, contlex);
  if(check=="")
    initstems[pos]=initstems[pos] initlexc;
  else
    initstems[pos]=initstems[pos] "! CHECK: " initlexc;

  if(notes!="")
    personlexc=sprintf("%s%s:%s%s %s ; ! %s\n", flags, stem, flags, initial, contlex, notes);
  else
    personlexc=sprintf("%s%s:%s%s %s ;\n", flags, stem, flags, initial, contlex);
  if(check=="")
    personstems[pos]=personstems[pos] elselexc;
  else
    personstems[pos]=personstems[pos] "! CHECK: " elselexc;

  if(notes!="")
    elselexc=sprintf("%s%s:%s%s %s ; ! %s\n", flags, stem, flags, initial, contlex, notes);
  else
    elselexc=sprintf("%s%s:%s%s %s ;\n", flags, stem, flags, initial, contlex);
  if(check=="")
    elsestems[pos]=elsestems[pos] elselexc;
  else
    elsestems[pos]=elsestems[pos] "! CHECK: " elselexc;

}
END {
  printf "!! Blackfoot noun stems\n"
  printf "\n";
  printf "LEXICON NOUN_STEMS\n";
  printf "@R.pos.NOUN@ NA_STEMS ;\n";
  printf "@R.pos.NOUN@ NI_STEMS ;\n";
  printf "@R.class.VAI@ NA_STEMS ;\n";
  printf "@R.class.VII@ NI_STEMS ;\n";
  printf "\n";


  for(p in initstems)
     {
       printf "LEXICON INIT_%s_STEMS\n", p;
       printf "%s\n", initstems[p];
     }
  for(p in personstems)
     {
       printf "LEXICON PERS_%s_STEMS\n", p;
       printf "%s\n", personstems[p];
     }
  for(p in elsestems)
     {
       printf "LEXICON %s_STEMS\n", p;
       printf "%s\n", elsestems[p];
     }
}'
