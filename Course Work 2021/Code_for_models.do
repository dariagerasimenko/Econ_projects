
// Set directory
//cd "C:\Users\Даша\Desktop"
use "C:\Users\Даша\Desktop\труд\USER_RLMS-HSE_IND_2010_2019_v2_rus.dta", clear

// Create new variable "work"
//codebook J1
gen WORK =.
replace WORK = 1 if J1 == 1
replace WORK = 0 if J1 == 2 | J1 == 3 | J1 == 4 | J1 == 5
drop if WORK ==.
//codebook WORK

//gen wave 
gen WAVE = .
replace WAVE = ID_W

//codebook J10
replace J10=. if J10==99999997 | J10==99999998 | J10==99999999
drop if J10 >= 150000 & J10<=600000

gen W_HOURS =.
replace W_HOURS = J8
replace W_HOURS = . if W_HOURS >99999996
//codebook W_HOURS

//зп в месяц
generate WAGES=.
replace WAGES=J10 if J10!=. & WORK==1
drop if J10==. & J10==1

drop if W_HOURS==. & WAGES!=.
drop if W_HOURS!=. & WAGES==.

//зп в час
gen HOURWAGE = WAGES/W_HOURS


//переменная FEMALE
//codebook H5
gen FEMALE=.
replace FEMALE=1 if H5==2
replace FEMALE=0 if H5==1

// 1 если женат и 2 если не женат
//codebook marst
gen MARRIED=.
replace MARRIED=1 if marst==2 | marst==3 | marst==6
replace MARRIED=0 if marst==1 | marst==4 | marst==5 

//количество детей
//codebook J72_172
gen NKIDS=.
replace NKIDS=J72_172 if J72_172<99999997
replace NKIDS=0 if NKIDS==. 
drop if NKIDS >=6
// Generate variable AGE
gen AGE = year - H6
gen AGE2 = AGE*AGE
//codebook AGE


// обрезаем выборку возраста
drop if AGE>65

//Логарифм зарплаты (почасовой)
generate LNHOURWAGE=.
replace LNHOURWAGE=ln(HOURWAGE) if HOURWAGE!=.
 
//переменная = 1 если с огр. возможностями и 0 иначе
//codebook M20_7
generate DISABL=.
replace DISABL=1 if M20_7==1 | M20_7==5 
replace DISABL=0 if M20_7==2 

//1 если замужняя женщина 0 иначе
generate FEMARRIED=.
replace FEMARRIED=FEMALE*MARRIED

//drop if ixhiedul==97
//drop if ixhiedul==98

//без средней школы
//codebook educ, tab(100)
codebook J72_18A, tab(100)
gen EDUC0=0
replace EDUC0=1 if J72_18A==1
//replace EDUC0=0 if J72_18A>1

// только средняя школа
gen EDUC1=0
replace EDUC1=1 if J72_18A ==2
//replace EDUC1=0 if J72_18A >2

gen EDUC2 = 0 //пту + начальное профессиональное 
replace EDUC2=1 if J72_18A >=3 & J72_18A<=5

gen EDUC3 = 0 //среднее профессиональное
replace EDUC3 = 1 if J72_18A == 6 | J72_18A == 15

//бакалавриат + специалитет + магистратура
gen EDUC4=0
replace EDUC4=1 if J72_18A==11 | J72_18A==10 | J72_18A == 7 | J72_18A == 12

//все что выше магистратуры
//gen EDUC5=0
replace EDUC4=1 if J72_18A==8 | J72_18A==9 
replace EDUC4=1 if J72_18A >=13 & J72_18A<=16
replace EDUC4 =0 if J72_18A ==15

gen SKILLS=J69_1
replace SKILLS =. if SKILLS >10

//codebook status
// city status variable 
gen CITY =0
replace CITY = 1 if status == 2
gen OBL_CENTRE =0
replace OBL_CENTRE = 1 if status == 1
gen PGT_SELO = 0
replace PGT_SELO = 1 if status==3 | status ==4

// occupancture variable (квалификация)
codebook OCCUP08, tab(100)
gen OCCUP0 = 0 // специалисты и управленцы 
replace OCCUP0 = 1 if OCCUP08 >=1 & OCCUP08 <=3 
gen OCCUP1 = 0
replace OCCUP1 = 1 if OCCUP08 >=4 & OCCUP08 <=8 // квалифицированные рабочие 
gen OCCUP2 = 0
replace OCCUP2 = 1 if OCCUP08 == 0 | OCCUP08 == 9 // неквалифицированные рабочие


//codebook J4_1, tab(100)
gen IND0 = 0 //PROM
replace IND0 = 1 if J4_1 >=1 & J4_1 <=5 
replace IND0 = 1 if J4_1 >=23 & J4_1 <=24 
replace IND0 = 1 if J4_1 == 8 | J4_1 == 16

gen IND1 = 0 // торговля и бизнес
replace IND1 = 1 if J4_1 == 14 | J4_1 == 15 | J4_1 == 21 | J4_1 == 27 | J4_1 == 29 | J4_1 == 30 | J4_1 == 31 

gen IND2 = 0 // образование, культура, спорт
replace IND2 = 1 if J4_1 == 10 | J4_1 == 11 | J4_1 == 25

gen IND3 = 0 // здравоохранение 
replace IND3 = 1 if J4_1 == 12

gen EDUC = .
replace EDUC = 0 if EDUC0 ==1
replace EDUC = 1 if EDUC1 ==1
replace EDUC = 2 if EDUC2 ==1
replace EDUC = 3 if EDUC3 ==1
replace EDUC = 4 if EDUC4 ==1
//replace EDUC = 5 if EDUC5 ==1

gen OCCUP = .
replace OCCUP = 0 if OCCUP0 ==1
replace OCCUP = 1 if OCCUP1 ==1
replace OCCUP = 2 if OCCUP2 ==1

gen IND = .
replace IND = 0 if IND0 ==1
replace IND = 1 if IND1 ==1
replace IND = 2 if IND2 ==1
replace IND = 3 if IND3 ==1


summarize FEMALE WAGES AGE MARRIED EDUC0 EDUC1 EDUC2 EDUC3 EDUC4 WORK SKILLS W_HOURS OCCUP0 OCCUP1 OCCUP2 IND0 IND1 IND2 IND3 WAVE

regress LNHOURWAGE AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 SKILLS NKIDS CITY PGT_SELO OCCUP0 OCCUP1 IND0 IND1 IND3 WAVE
ovtest //оценка спецификации модели
vif //оценка мультиколлинеарности
estat imtest, white //тест вайта, оценка гетероскедастичности


heckman LNHOURWAGE AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 FEMALE SKILLS NKIDS CITY PGT_SELO OCCUP0 OCCUP1 IND0 IND1 IND3 WAVE, twostep select(WORK = AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 FEMALE DISABL NKIDS IND0 IND1 IND3 WAVE)rhosigma

regress WORK AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 FEMALE NKIDS DISABL CITY PGT_SELO IND0 IND1 IND3 WAVE
ovtest //оценка спецификации модели
vif //оценка мультиколлинеарности
estat imtest, white //тест вайта, оценка гетероскедастичности

logit WORK AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 FEMALE NKIDS DISABL CITY PGT_SELO IND0 IND1 IND3 WAVE
mfx
probit WORK AGE AGE2 EDUC1 EDUC2 EDUC3 EDUC4 FEMALE NKIDS DISABL CITY PGT_SELO IND0 IND1 IND3 WAVE
mfx
