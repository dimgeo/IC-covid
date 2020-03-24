NB. ========================================
NB. Covid19. Are there enough IC beds?
NB. Dimitri Georganas, Biodys BV
NB. ========================================

NB. libraries, utilities

load 'plot'
exp=: [: ^ [

NB. ===================================================================================
NB. Gompertz parameters calculated with non-linear square LM fitting of verified RIVM data
NB.
NB. Date 21 March 2020
NB. ===================================================================================

a=:   1117765.75993369 
b=:   11.7986960672319 
c=:  0.0299895008556075 

NB. ==========================================
NB. Gompertz curve
NB. ==========================================

gomp=: monad define  NB.  Gompertz, returns total cases using best fit parameters
  a * exp  - b *  exp -c * y
)

NB. ==========================================
NB. Derivative Gompertz curve , new cases per day
NB. ==========================================

dgomp =: monad define
        >.      a*b*c * exp((-b * exp -c * y)- (c*y))
)

NB. ==========================================
NB. Defaults
NB. ==========================================


NB. Assume 1% of cases are critical and need 14 days intensive case

n=:  i. 300   	     	   NB. Investigate 300 days from day one  
severe=: 0.05         	   NB. patients that need intensive care
days=: 14                  NB. number of days of intensive care
extend=: 300       	   NB. Extend days for enough 'space' in the matrix



NB. ==========================================
NB. Calculate
NB. ==========================================

NB. cases=: 1000 2000 3000 4000 5000 6000 7000 8000 7000 5000 4000  4000 3000 2000 1000  NB. testing
cases =: dgomp n	     	       	    	      	   	NB. Get predicted number of cases
critical=: <. severe * cases   					NB. Multiple by severity and round
matrix=: (critical * ((#cases),days) $ 1 ),"1 [ extend $0     	NB. Create matrix
beds=: +/ (-(i.&#) matrix) |."0 1 matrix      	    NB. Shift each matrix row by its rownumber to the right (ty M. Lochbaum)
showbeds=: (-(i.&#) matrix) |."0 1 matrix     			NB. Function to visualize th matrix

NB. ==========================================
NB. Plot
NB. ==========================================


xlbl=: 'Days'
ylbl=: 'Number/quantity'
title=: 'Number of critical infections per day vs required total of available IC beds'
keytxt=: 'Required_IC_beds,Rate_of_critical_infections'
options=: 'title ',title,';xcaption ',xlbl,';ycaption ',ylbl
options=: options,';key ',keytxt ,';keypos tri'
options plot beds,:(critical)



