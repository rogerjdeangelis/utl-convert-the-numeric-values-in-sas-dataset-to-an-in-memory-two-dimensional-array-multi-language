/*
 * Source: utl-convert-...-multi-language.sas (sections 2-3)
 * The post's centerpiece: convert the numeric values of a dataset into an
 * in-memory two-dimensional array, then walk it to sum the diagonal and the
 * anti-diagonal. Upstream builds the array from SD1.HAVE with the %utl_numary
 * macro (which pipes through the Windows clipboard, LIBNAME d:/sd1); here the
 * 9 numeric columns of HAVE are loaded straight into a 9x9 array so the step
 * is self-contained. The diagonal / anti-diagonal loop is unchanged from the
 * post; DIM(xy,1)/DIM(xy,2) are used to size the two dimensions.
 * Expected result matches the post: DIAGONAL=10, ANTI_DIAGONAL=18.
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

data _null_;
 array xy [9,9] _temporary_;
 do r=1 to 9;
   set have(keep=a b c d e f g h k) nobs=n;
   array rowvals[9] a b c d e f g h k;
   do cix=1 to 9;
     xy[r,cix]=rowvals[cix];
   end;
 end;
 diagonal=0;
 anti_diagonal=0;
 do i=1 to dim(xy,1);
    do j=1 to dim(xy,2);
      if i=j then diagonal = diagonal +xy[i,j];
      if i=10-j then anti_diagonal=anti_diagonal+xy[i,j];
    end;
 end;
 put diagonal= / anti_diagonal=;
run;quit;
