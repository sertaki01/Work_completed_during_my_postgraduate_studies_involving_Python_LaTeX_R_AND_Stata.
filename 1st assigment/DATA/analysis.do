cd"C:\Users\admin\OneDrive\Υπολογιστής\DATA"

clear all

import excel "Data.xls", sheet(analysis) firstrow

tsset T

ssc install corrtex

corrtex Annualisedhistoricalvolatility C Gold_ETF_Volatility_Index CBOE_Silver_ETF_Volatility_Index, file(correlation)

graph box C

graph box Annualisedhistoricalvolatility

graph box  Gold_ETF_Volatility_Index

graph box CBOE_Silver_ETF_Volatility_Index

gen SP500_ln=log(C)

gen WTI_ln=log(Annualisedhistoricalvolatility)

gen Gold_ln=log(Gold_ETF_Volatility_Index)

gen Silver_ln=log(CBOE_Silver_ETF_Volatility_Index)

graph box SP500_ln, ytitle("SP 500") name(sp_500)

graph box WTI_ln, ytitle("WTI") name(wti)

graph box Gold_ln, ytitle("Gold") name(gold)  

graph box Silver_ln, ytitle("Silver") name(silver) 

graph combine sp_500 wti gold silver

replace WTI_ln= 4.226216 if WTI_ln>6.24 

summarize T SP500_ln WTI_ln Gold_ln Silver_ln

outreg2 using summarize.tex, sum(detail) replace eqkeep(N mean sd min max) see  addnote(write something) keep(T SP500_ln WTI_ln Gold_ln Silver_ln) 
 
dfuller SP500_ln 

dfuller  WTI_ln

dfuller   Gold_ln

dfuller  Silver_ln

line SP500_ln T, ytitle("SP 500") name("P")

line WTI_ln T, ytitle("WTI") name("W")

line Gold_ln T, ytitle("Gold")  name("G")

line Silver_ln T, ytitle("Silver")  name("S") 

graph combine P W G S 

gen Gold= d.Gold_ln

gen Silver= d.Silver_ln 

line Gold T, name(Gold)

line Silver T, name(Silver) 

dfuller Gold

dfuller Silver

ardl WTI_ln SP500_ln Gold_ln Silver_ln 

ardl WTI_ln SP500_ln Gold_ln Silver_ln , lags(1 0 2 0) ec1 btest 

outreg2 using reg1.tex, replace dec(3) seeout title("ARIMA Regression")


