#!/bin/sh

# extract-multichar-symbols-from-lexc.sh

# Script to extract multicharacter symbols candidates from LEXC code

# Usage:
#    cat lexicon.lexc | scripts/extract-multichar-symbols-from-lexc.sh

gawk 'BEGIN { pos["+N"]="+N"; pos["+V"]="+V"; pos["+Ipc"]="+Ipc"; pos["+Pron"]="+Pron";
  prefregex="((P[VN][^\\+]+\\+)|(Rdpl[SW]\\+))";
  sufregex="(\\+(N|V|Pron|Num|Ipc)";
} 
{ line=$0;
  sub("!.*$", "", line);
  if(match(line, "^[^;]+;", f)!=0)
    {
      line2=f[0]; # print line2;
      match(line2, "^([^ ]+) ", f);
      lex=f[1]; # print lex;
      n=split(lex, f, ":");
      for(i=1; i<=n; i++)
         {
           m=patsplit(f[i], ff, "@[^@]+@");
           for(j=1; j<=m; j++)
             flags[ff[j]]++;
           m=patsplit(f[i], ff, "[[:lower:]][0-9]+");
           for(j=1; j<=m; j++)
             specs[ff[j]]++;
           m=patsplit(f[i], ff, "\\^([[:upper:]]|[[:digit:]])+");
           for(j=1; j<=m; j++)
             trigs[ff[j]]++;
         }
      if(n==2)
        {
          # m=patsplit(f[1], ff, "P[NV]/[^\\+]+\\+");
          m=patsplit(f[1], ff, "[^\\+@]+\\+");
          for(j=1; j<=m; j++)
             tags[ff[j]]++;
          m=patsplit(f[1], ff, "\\+[^\\+@]+");
          for(j=1; j<=m; j++)
             tags[ff[j]]++;
        }
    }
}
END { PROCINFO["sorted_in"]="@ind_str_asc";
  print "!! Tags";
  for(tag in tags)
     {
       check="";
       if(match(tag, "\\+$")!=0)
         if(match(tag, prefregex)==0)
           check=" ! Check: Prefix?";
         else
           check="";
       printf "%s%s\n", tag, check;
     }
  print "";
  printf "!! Flags !!\n\n";
  for(flag in flags)
     # print flag;
     if(match(flag, "@(.)\\.([^\\.]+)(\\.([^@]+))?@", f)!=0)
       {
         type=f[1]; var=f[2]; val=f[4];
         fparse[var][val][type]++;
       }
  for(var in fparse)
     {
       printf "!! %s\n", var;
       for(val in fparse[var])
          {
            if(val!="")
              printf "!  %s.%s\n", var, val;
            for(type in fparse[var][val])
               if(val!="")
                 printf "@%s.%s.%s@\n", type, var, val;
               else
                 printf "@%s.%s@\n", type, var;
            # print "";
          }
       printf "\n";
     }

  print "";
  print "!! Morphophonemic special characters";
  for(spec in specs)
     print spec;
  print "";
  print "!! Triggers";
  for(trig in trigs)
     print trig;
  print "";
}'

