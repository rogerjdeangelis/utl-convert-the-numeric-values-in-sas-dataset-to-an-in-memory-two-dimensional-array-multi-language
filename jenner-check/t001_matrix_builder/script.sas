/*
 * Source: utl-convert-...-multi-language.sas (section 2, "input")
 * Builds SD1.HAVE, a 9x9 matrix dataset whose diagonal cells are 1 and
 * anti-diagonal cells are 2 (all other cells missing). Upstream writes it
 * to LIBNAME sd1 "d:/sd1"; here it is written to WORK so the step is
 * self-contained. The DATA step logic is unchanged from the post.
 */
data have;
 retain rec i j;
 array cols[9] a b c d e f g h k;
 do i=1 to 9;
    do j=1 to 9;
      cols[j]=.;
      if i=j then cols[j]=1;
      if j=(10-i) then cols[j]=2;
    end;
    rec=cats('R',put(100+i,z3.));
    output;
 end;
run;quit;

proc print data=have; run;
