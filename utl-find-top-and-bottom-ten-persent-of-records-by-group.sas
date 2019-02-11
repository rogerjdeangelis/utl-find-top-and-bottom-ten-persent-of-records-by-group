Find top and bottom 10 persent of records by group

Not as obvious as you would think?

github
https://tinyurl.com/yyrxkwgy
https://github.com/rogerjdeangelis/utl-find-top-and-bottom-ten-persent-of-records-by-group

SAS Forum
https://tinyurl.com/yxz7ay4p
https://communities.sas.com/t5/SAS-Programming/Find-top-amp-bottom-10-of-records-by-group/m-p/534380

Chris Hemedinger (nice solution)
https://communities.sas.com/t5/user/viewprofilepage/user-id/4

INPUT
=====

data have;
  retain origin make msrp;
  set sashelp.cars (keep=origin msrp obs=50 where=(msrp<44000));
run;quit;

* dont need to do this - used for explanation;
proc sort data=have out=have;
by origin msrp ;
run;quit;

 WORK.HAVE total obs=50 ( data does not have to be sorted by MSRP within origin)

  ORIGIN     MSRP   RULES (sorted within Origin for explanation)

  Asia      23820   Since we only have 5 there
  Asia      26990   is no top and bottom 10% (just 20%)
  Asia      33195
  Asia      36945
  Asia      43755

  Europe    25940    1/26 =3.8%    3%   floor(rank/(n+1))
  Europe    28495    2/26 =7.7%    7%

  Europe    30245    3/26 =11.5%  11%   Not in Top 10%
  Europe    30795
  Europe    31840
  Europe    32845
  Europe    33430
  Europe    33895
  Europe    34480
  Europe    35495
  Europe    35940
  Europe    35940
  Europe    36640
  Europe    36995
  Europe    37000
  Europe    37245
  Europe    37390
  Europe    37995
  Europe    39640
  Europe    39995
  Europe    40590
  Europe    40840
  Europe    41045   23/26 88.5   88%  Not in Bot 10%

  Europe    42490   24/26 92.3   92%
  Europe    42840   25/26 96.1   96%

  USA       11690
  USA       12585

  USA       14610
  USA       14810
  USA       16385
  USA       20255
  USA       21900
  USA       22180
  USA       24895
  USA       26470
  USA       26545
  USA       28345
  USA       30295
  USA       30835
  USA       32245
  USA       35545
  USA       37895
  USA       40720

  USA       41465
  USA       42735



EXAMPLE OUTPUT
--------------

WORK.WANT total obs=8

                     RANKED_
  ORIGIN     MSRP      MSRP     TOPBOT

  Europe    25940       0       Top 10%
  Europe    28495       0       Top 10%

  Europe    42490       9       Bot 10%
  Europe    42840       9       Bot 10%

  USA       11690       0       Top 10%
  USA       12585       0       Top 10%

  USA       41465       9       Bot 10%
  USA       42735       9       Bot 10%


PROCESS
=======

proc rank data = work.have
      groups=10
      ties=mean
      out=wantpre (where=(ranked_msrp in (0,9)));
      by origin;
      var msrp;
ranks ranked_msrp ;
run;

proc report data=work.wantpre out=want  (drop=_:)  missing ;
column  origin msrp ranked_msrp topbot;

define  origin       / order ;
define  msrp         / order ;
define  ranked_msrp  / order ;
define  topbot / computed;

compute topbot / character ;
   if ranked_msrp=0 then topbot='Top 10%';
   else topbot='Bot 10%';
endcomp;
run;quit;


OUTPUT
======

WORK.WANT total obs=8

                          RANKED_
Obs    ORIGIN     MSRP      MSRP     TOPBOT

 1     Europe    25940       0       Top 10%
 2     Europe    28495       0       Top 10%
 3     Europe    42490       9       Bot 10%
 4     Europe    42840       9       Bot 10%
 5     USA       11690       0       Top 10%
 6     USA       12585       0       Top 10%
 7     USA       41465       9       Bot 10%
 8     USA       42735       9       Bot 10%



