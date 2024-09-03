%let pgm=utl-convert-the-numeric-values-in-sas-dataset-to-an-in-memory-two-dimensional-array-multi-language;

%stop_submission;

Convert the numeric values in dataset to an in memory two dimensional array multi-language
One of the purposes of this post is to demonstrate the similarity between r and sas loops


While the problem can be solved easily without in-memory arrays,
using them provides significant advantages for accessing data and performing linear algebra
operations. Additionally, the SAS code that utilizes these arrays can be easily adapted to matrix
languages, making it versatile for such tasks.
Macro to create array statement on end

 CONTENTS

    0 problem
    1 sas & r code side by side
    2 input
    3 sas array
    4 r array
    5 macro numary

github
https://tinyurl.com/y963wwh7
https://github.com/rogerjdeangelis/utl-convert-the-numeric-values-in-sas-dataset-to-an-in-memory-two-dimensional-array-multi-language

Related pepos
https://github.com/rogerjdeangelis/utl-converting-your-sas-datastep-programs-to-r
https://github.com/rogerjdeangelis/utl-leveraging-your-knowledge-of-regular-expressions-to-wps-r-python-multi-language
https://github.com/rogerjdeangelis/utl-converting-common-wps-coding-to-r-and-python
https://tinyurl.com/2f5579tt
https://github.com/rogerjdeangelis/utl-classic-r-alternatives-for-the-apply-family-of-functions-on-dataframes-for-sas-programmers
https://github.com/rogerjdeangelis/utl_convert-sas-merge-to-r-code

/*___                    _     _
 / _ \   _ __  _ __ ___ | |__ | | ___ _ __ ___
| | | | | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_| | | |_) | | | (_) | |_) | |  __/ | | | | |
 \___/  | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
        |_|
*/


/************************************************************************************************************************/
/*                                    |                                                           |                     */
/*                                    |                                                           |                     */
/*              INPUT                 |          PROCESS                                          |    OUTPUT           */
/*                                    |                                                           |                     */
/*                                    | SAS                                                       |                     */
/*                                    | ===                                                       |                     */
/*                                    |                                                           |                     */
/*  options validvarname=upcase;      | data _null_;                                              | DIAGONAL      = 10  */
/*  libname sd1 "d:/sd1";             |  array xy %utl_numary(sd1.have,drop=rec i j);             | ANTI_DIAGONAL = 18  */
/*  data sd1.have;                    |  diagonal=0;                                              |                     */
/*   retain rec i j;                  |  anti_diagonal=0;                                         |                     */
/*   array cols[9] a b c d e f g h k; |  do i=1 to dim1(xy);                                      |                     */
/*   do i=1 to 9;                     |     do j=1 to dim2(xy);;                                  |                     */
/*      do j=1 to 9;                  |       if i=j then diagonal = diagonal +xy[i,j];           |                     */
/*        cols[j]=.;                  |       if i=10-j then anti_diagonal=anti_diagonal+xy[i,j]; |                     */
/*        if i=j then cols[j]=1;      |     end;                                                  |                     */
/*        if j=(10-i) then cols[j]=2; |  end;                                                     |                     */
/*      end;                          |  put diagonal= / anti_diagonal=;                          |                     */
/*      rec=cats('R',put(100+i,z3.)); | run;quit;                                                 |                     */
/*      output;                       |                                                           |                     */
/*   end;                             |                                                           |                     */
/*  run;quit;                         |  Macro creates this array statement                       |                     */
/*                                    |                                                           |                     */
/*                                    |  %put array xy                                            |                     */
/*  REC  I  J    A B C D E F G H K    |   %utl_numary(sd1.have,drop=rec i j)                      |                     */
/*                                    |                                                           |                     */
/*  R101 1 10    1 . . . . . . . 2    |  array xy   [9,9]                                         |                     */
/*  R102 2 10    . 1 . . . . . 2 .    |  (                                                        |                     */
/*  R103 3 10    . . 1 . . . 2 . .    |  1,.,.,.,.,.,.,.,2,                                       |                     */
/*  R104 4 10    . . . 1 . 2 . . .    |  .,1,.,.,.,.,.,2,.,                                       |                     */
/*  R105 5 10    . . . . 2 . . . .    |  .,.,1,.,.,.,2,.,.,                                       |                     */
/*  R106 6 10    . . . 2 . 1 . . .    |  .,.,.,1,.,2,.,.,.,                                       |                     */
/*  R107 7 10    . . 2 . . . 1 . .    |  .,.,.,.,2,.,.,.,.,                                       |                     */
/*  R108 8 10    . 2 . . . . . 1 .    |  .,.,.,2,.,1,.,.,.,                                       |                     */
/*  R109 9 10    2 . . . . . . . 1    |  .,.,2,.,.,.,1,.,.,                                       |                     */
/*                                    |  .,2,.,.,.,.,.,1,.,                                       |                     */
/*                                    |  2,.,.,.,.,.,.,.,1,                                       |                     */
/*                                    |  )                                                        |                     */
/*                                    |                                                           |                     */
/*----------------------------------------------------------------------------------------------------------------------*/
/*                                    |                                                           |                     */
/*                                    | %utl_rbeginx;                                             |                     */
/*                                    | parmcards4;                                               |sum diagonal: 10     */
/*                                    | library(haven)                                            |sum anti_diagonal:18 */
/*                                    | library(sqldf)                                            |                     */
/*                                    | source("c:/oto/fn_tosas9x.R")                             |                     */
/*                                    | have<-read_sas("d:/sd1/have.sas7bdat")[ ,4:12]            |                     */
/*                                    | diagonal<-0                                               |                     */
/*                                    | anti_diagonal<-0                                          |                     */
/*                                    | for ( i in seq(1,nrow(have),1) ) {                        |                     */
/*                                    |   for ( j in seq(1,ncol(have),1) ) {                      |                     */
/*                                    |     if ( i==j ) { diagonal <- diagonal + have[i,j] }      |                     */
/*                                    |     if ( i==(10L-j) )                                     |                     */
/*                                    |        { anti_diagonal <- anti_diagonal + have[i,j] }     |                     */
/*                                    |   }                                                       |                     */
/*                                    | }                                                         |                     */
/*                                    | print(paste("sum diagonal:",diagonal))                    |                     */
/*                                    | print(paste("sum anti_diagonal:",anti_diagonal))          |                     */
/*                                    | ;;;;                                                      |                     */
/*                                    | %utl_rendx;                                               |                     */
/*                                    |                                                           |                     */
/************************************************************************************************************************/

/*                   ___                          _            _     _        _                 _     _
/ | ___  __ _ ___   ( _ )    _ __    ___ ___   __| | ___   ___(_) __| | ___  | |__  _   _   ___(_) __| | ___
| |/ __|/ _` / __|  / _ \/\ | `__|  / __/ _ \ / _` |/ _ \ / __| |/ _` |/ _ \ | `_ \| | | | / __| |/ _` |/ _ \
| |\__ \ (_| \__ \ | (_>  < | |    | (_| (_) | (_| |  __/ \__ \ | (_| |  __/ | |_) | |_| | \__ \ | (_| |  __/
|_||___/\__,_|___/  \___/\/ |_|     \___\___/ \__,_|\___| |___/_|\__,_|\___| |_.__/ \__, | |___/_|\__,_|\___|
                                                                                 |___/
*/

/****************************************************************************************************************************/
/*                                                         |                                                                */
/*               SAS                                       |                   R                                            */
/*                                                         |                                                                */
/*  %utl_numary(sd1.have,drop=rec i j) -creates array      | Datatype and data structures complcate r & python (see 10L)    */
/*                                                         |                                                                */
/*  array xy %utl_numary(sd1.have,drop=rec i j);           | have<-read_sas("d:/sd1/have.sas7bdat")[ ,4:12]                 */
/*                                                         |                                                                */
/*  diagonal = 0;                                          | diagonal<-0                                                    */
/*  anti_diagonal = 0;                                     | anti_diagonal<-0                                               */
/*                                                         |                                                                */
/*   do i=1 to dim1(xy);                                   | for ( i in seq(1,nrow(have),1) ) {                             */
/*     do j=1 to dim2(xy);                                 |   for ( j in seq(1,ncol(have),1) ) {                           */
/*                                                         |                                                                */
/*      if i=j then diagonal = diagonal +xy[i,j];          |     if ( i==j ) { diagonal <- diagonal + have[i,j] }           */
/*      if i=10-j then anti_diagonal=anti_diagonal+xy[i,j];|     if ( i==(10L-j) ) {anti_diagonal<-anti_diagonal+have[i,j]} */
/*                                                         |                                                                */
/*      end;                                               |    }                                                           */
/*   end;                                                  | }                                                              */
/*                                                         |                                                                */
/*  put diagonal=;                                         | print(paste("sum diagonal:",diagonal))                         */
/*  put anti_diagonal=;                                    | print(paste("sum anti_diagonal:",anti_diagonal))               */
/*                                                         |                                                                */
/*  DIAGONAL      = 10                                     |                                                                */
/*  ANTI_DIAGONAL = 18                                     | sum diagonal: 10                                               */
/*                                                         | sum anti_diagonal:18                                           */
/*  %utl_numary(sd1.have,drop=rec i j);                    |                                                                */
/*                                                         |                                                                */
/*  Creates a numeric array out of a dataset               |                                                                */
/*                                                         |                                                                */
/*  For instance                                           |                                                                */
/*                                                         |                                                                */
/*  %put %utl_numary(sashelp.class,drop=name sex);         |                                                                */
/*                                                         |                                                                */
/*  Creates                                                |                                                                */
/*                                                         |                                                                */
/*  array xy [19,3] (14,69,112.5,13,56.5,84,13             |                                                                */
/*   ,65.3,98,14,62.8,102.5,14,63.5,102.5,12               |                                                                */
/*   ,57.3,83,12,59.8,84.5,15,62.5,112.5,13,62.5           |                                                                */
/*   ,84,12,59,99.5,11,51.3,50.5,14,64.3,90                |                                                                */
/*   ,12,56.3,77,15,66.5,112,16,72,150,12,64.8             |                                                                */
/*   ,128,15,67,133,11,57.5,85,15,66.5,112)                |                                                                */
/*                                                         |                                                                */
/****************************************************************************************************************************/
/*___    _                   _
|___ \  (_)_ __  _ __  _   _| |_
  __) | | | `_ \| `_ \| | | | __|
 / __/  | | | | | |_) | |_| | |_
|_____| |_|_| |_| .__/ \__,_|\__|
                |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
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


/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.HAVE total obs=9                                                                                                   */
/*                                                                                                                        */
/*  REC     I     J    A B C D E F G H K                                                                                  */
/*                                                                                                                        */
/*  R101    1    10    1 . . . . . . . 2                                                                                  */
/*  R102    2    10    . 1 . . . . . 2 .                                                                                  */
/*  R103    3    10    . . 1 . . . 2 . .                                                                                  */
/*  R104    4    10    . . . 1 . 2 . . .                                                                                  */
/*  R105    5    10    . . . . 2 . . . .                                                                                  */
/*  R106    6    10    . . . 2 . 1 . . .                                                                                  */
/*  R107    7    10    . . 2 . . . 1 . .                                                                                  */
/*  R108    8    10    . 2 . . . . . 1 .                                                                                  */
/*  R109    9    10    2 . . . . . . . 1                                                                                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*  Macro creates this array statement                                                                                    */
/*                                                                                                                        */
/*  %put array xy                                                                                                         */
/*   %utl_numary(sd1.have,drop=rec i j);                                                                                  */
/*                                                                                                                        */
/*  array xy   [9,9]                                                                                                      */
/*  (                                                                                                                     */
/*  1,.,.,.,.,.,.,.,2,                                                                                                    */
/*  .,1,.,.,.,.,.,2,.,                                                                                                    */
/*  .,.,1,.,.,.,2,.,.,                                                                                                    */
/*  .,.,.,1,.,2,.,.,.,                                                                                                    */
/*  .,.,.,.,2,.,.,.,.,                                                                                                    */
/*  .,.,.,2,.,1,.,.,.,                                                                                                    */
/*  .,.,2,.,.,.,1,.,.,                                                                                                    */
/*  .,2,.,.,.,.,.,1,.,                                                                                                    */
/*  2,.,.,.,.,.,.,.,1,                                                                                                    */
/*  );                                                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/


https://github.com/rogerjdeangelis/utl-converting-your-sas-datastep-programs-to-r
https://github.com/rogerjdeangelis/utl-leveraging-your-knowledge-of-regular-expressions-to-wps-r-python-multi-language
https://github.com/rogerjdeangelis/utl-converting-common-wps-coding-to-r-and-python
https://tinyurl.com/2f5579tt
https://github.com/rogerjdeangelis/utl-classic-r-alternatives-for-the-apply-family-of-functions-on-dataframes-for-sas-programmers
https://github.com/rogerjdeangelis/utl_convert-sas-merge-to-r-code


/*____
|___ /   ___  __ _ ___    __ _ _ __ _ __ __ _ _   _
  |_ \  / __|/ _` / __|  / _` | `__| `__/ _` | | | |
 ___) | \__ \ (_| \__ \ | (_| | |  | | | (_| | |_| |
|____/  |___/\__,_|___/  \__,_|_|  |_|  \__,_|\__, |
                                              |___/
*/

data _null_;
 array xy %utl_numary(sd1.have,drop=rec i j);
 diagonal=0;
 anti_diagonal=0;
 do i=1 to dim1(xy);
    do j=1 to dim2(xy);;
      if i=j then diagonal = diagonal +xy[i,j];
      if i=10-j then anti_diagonal=anti_diagonal+xy[i,j];
    end;
 end;
 put diagonal= / anti_diagonal=;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   DIAGONAL      = 10                                                                                                   */
/*   ANTI_DIAGONAL = 18                                                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _
| || |    _ __    __ _ _ __ _ __ __ _ _   _
| || |_  | `__|  / _` | `__| `__/ _` | | | |
|__   _| | |    | (_| | |  | | | (_| | |_| |
   |_|   |_|     \__,_|_|  |_|  \__,_|\__, |
                                      |___/
*/


%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")[ ,4:12]
diagonal<-0
anti_diagonal<-0
for ( i in seq(1,nrow(have),1) ) {
  for ( j in seq(1,ncol(have),1) ) {
    if ( i==j ) { diagonal <- diagonal + have[i,j] }
    if ( i==(10L-j) ) { anti_diagonal <- anti_diagonal + have[i,j] }
  }
}
print(paste("sum diagonal:",diagonal))
print(paste("sum anti_diagonal:",anti_diagonal))
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* sum diagonal: 10                                                                                                       */
/* sum anti_diagonal:18                                                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___
| ___|   _ __ ___   __ _  ___ _ __ ___     __ _ _ __ _ __ __ _ _   _
|___ \  | `_ ` _ \ / _` |/ __| `__/ _ \   / _` | `__| `__/ _` | | | |
 ___) | | | | | | | (_| | (__| | | (_) | | (_| | |  | | | (_| | |_| |
|____/  |_| |_| |_|\__,_|\___|_|  \___/   \__,_|_|  |_|  \__,_|\__, |
                                                               |___/
*/

filename ft15f001 "c:/oto/utl_numary.sas";
parmcards4;
%macro utl_numary(_inp,drop=trt);

/*
 %let _inp=sd1.have;
 %let drop=i j;
*/

 %symdel _array / nowarn;

 %dosubl(%nrstr(
 filename clp clipbrd lrecl=64000;
 data _null_;
 file clp;
 set &_inp(drop=&drop) nobs=rows;
 array ns _numeric_;
 call symputx('rowcol',catx(',',rows,dim(ns)));
 put (_numeric_) ($) @@;
 run;quit;
 %put &=rowcol;
 data _null_;
 length res $32756;
 infile clp;
 input;
 res=cats("[&rowcol] (",translate(_infile_,',',' '),')');
 call symputx('_array',res);
 run;quit;
 ))

 &_array

%mend utl_numary;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
