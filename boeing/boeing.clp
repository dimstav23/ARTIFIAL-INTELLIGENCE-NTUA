(deffacts startup (menu-op start))

(member-of possible-main-menu-selections 1 2 3 4 5 6 7 8)

(defrule main-menu		;;MENU TO CHOOSE WHICH TROUBLE YOU HAVE  
    (menu-op start)		;;POSSIBLE VALID CHOICES FOR OUR EXPERT SYSTEM ARE 1 AND 3
    ?fact <- (menu-op start)
=>
    (printout t t t t "*****BOEING 747 FAULT ISOLATION EXPERT SYSTEM*****" crlf)
    (printout t t "MAIN MENU" t crlf)
    (printout t "1 - Oil consumption is high" crlf)
    (printout t "2 - Oil quantity indicator is malfunctioning" crlf)
    (printout t "3 - Oil pressure is abnormal or indicator is malfunctioning" crlf)
    (printout t "4 - Oil filter bypass light is illuminated" crlf)
    (printout t "5 - Oil temperature is abnormal or indicator is malfunctioning" crlf)
    (printout t "6 - Breather temperature is high" crlf)
    (printout t "7 - Engine was shutdown in flight" crlf)
    (printout t "8 - Unlisted engine oil fault" crlf)
    (printout t "Which of the above were observed during the flight? >" crlf)
    (printout t "*****************************************************" crlf)
    (printout t "*****************************************************" crlf)
    (printout t "Note:Our current expert systems resolves only "crlf)
    (printout t "     Oil Consumption and Oil Pressure Issues "crlf)
    (assert (observed-problem-number (read)) )
    (printout t crlf)
    (retract ?fact)
)

;; CODE EXPLANATION:
;; First we check the oil consumption problem (BD/BE)
;; and we solve it step by step as shown in the manual
;; Then we check for oil pressure problem (CD/CE)
;; and we solve it step by step as shown in the manual
;; There are clarification marks at each point of our
;; source code so as to be easily understood by 
;; everyone, as any expert system should be.


(defrule engine-number		;;MENU TO INDICATE WHICH ENGINE HAS THE PROBLEM
    (menu-op engine-num)
    ?fact <- (menu-op engine-num)
=>
    (printout t "Which engine is malfuctioning? (1,2,3,4,0) >" crlf)
    (assert (engine-num (read)))
    (printout t crlf)
    (retract ?fact)
)

;;  SHORTCUT FOR QUESTIONS YES-NO

(defrule yes-no-question 
    (ask-question yesno) 
    ?fact <- (ask-question yesno)
=> 
    (printout t "[yes,no] > ")
    (assert (answer (read))) 
    (printout t crlf)
    (retract ?fact)
)

;;  CHOSEN PROBLEM 1: OIL CONSUMPTION

(defrule oil-consumption
    (observed-problem-number 1)
    ?fact <- (observed-problem-number 1)
=>
    (assert (error-code 79-01-BA-0)) 
    (assert (menu-op engine-num))
    (retract ?fact)
)


(defrule high-oil-consumption
    (error-code 79-01-BA-0)
=>
    (printout t "Are there any other abnormal oil systems?" crlf)
    (assert (ask-question yesno))
)

(defrule high-oil-consumption-with-abnormal-issues ;;WE COCNLUDE WE HAVE BD PROBLEM TYPE
    (error-code 79-01-BA-0)
    ?fact-1 <- (error-code 79-01-BA-0)
    (answer yes) 
    ?fact-2 <- (answer yes) 
=> 
    (assert (error-code 79-01-BD-0))
    (assert (high-oil-consumption-question start))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-without-abnormal-issues ;;WE CONCLUDE WE HAVE BE PROBLEM TYPE
    (error-code 79-01-BA-0)
    ?fact-1 <- (error-code 79-01-BA-0)
    (answer no) 
    ?fact-2 <- (answer no) 
=> 
    (assert (error-code 79-01-BE-0))  
    (assert (high-oil-consumption-question start))
    (retract ?fact-1)
    (retract ?fact-2)
)


;;;;;;;;;;;;;;;;;;;;;;;;;HIGH OIL CONSUMPTION PROBLEM TROUBLESHOOTING;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule high-oil-consumption-question-start
    (high-oil-consumption-question start)
    ?fact <- (high-oil-consumption-question start)
=> 
   (printout t "Examine turbine exhaust area for evidence of oil loss per Visual Check 1, 79-01-10. Is oil loss occuring?" crlf)
   (assert (high-oil-consumption-question step-0))
   (assert (ask-question yesno))
   (retract ?fact)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIRST FIM PAGE WITH BD/BE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule high-oil-consumption-question-at-step0-no
    (high-oil-consumption-question step-0)
    ?fact-1 <- (high-oil-consumption-question step-0)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Examine main gearbox drains (MM 71-71-00) for leakage.  Is excessive oil present?" crlf)
    (assert (high-oil-consumption-question step-1))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step0-yes
    (high-oil-consumption-question step-0)
    ?fact-1 <- (high-oil-consumption-question step-0)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Identify source of oil loss per Visual Check 1, 79-01-10.  Is oil loss due to leakage from rear cover of No. 4 bearing compartment?" crlf)
    (assert (high-oil-consumption-question step-2))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step1-yes
    (high-oil-consumption-question step-1)
    ?fact-1 <- (high-oil-consumption-question step-1)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Identify leaking drain line source (MM 71-71-00) Was source of leakage from the fuel/oil cooler?" crlf)
    (assert (high-oil-consumption-question step-14))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step1-no
    (high-oil-consumption-question step-1)
    ?fact-1 <- (high-oil-consumption-question step-1)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Check that PT3 water drain plug is installed per Visual Check 9, 71-01-10. Is plug missing?" crlf)
    (assert (high-oil-consumption-question step-15))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step2-no
    (high-oil-consumption-question step-2)
    ?fact-1 <- (high-oil-consumption-question step-2)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is oil loss due to leakage from oil pressure supply line or oil scavenge line of No. 4 bearing compartment?" crlf)
    (assert (high-oil-consumption-question step-3))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step2-yes
    (high-oil-consumption-question step-2)
    ?fact-1 <- (high-oil-consumption-question step-2)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace engine. MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step3-yes
    (high-oil-consumption-question step-3)
    ?fact-1 <- (high-oil-consumption-question step-3)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Remove and clean or replace oil pressure supply tube and/or oil scavenge tube as required.  MM 72-53-00" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step3-no
    (high-oil-consumption-question case-3)
    ?fact-1 <- (high-oil-consumption-question case-3)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is oil loss due to a clogged or loose oil scavenge line or a failed scavenge pump?" crlf)
    (assert (high-oil-consumption-question step-6))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step6-yes
    (high-oil-consumption-question step-6)
    ?fact-1 <- (high-oil-consumption-question step-6)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Remove and clean or replace oil scavenge tube as necessary.  MM 72-53-00.  Replace scavenge pump if required.  MM 72-61-21" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step6-no
    (high-oil-consumption-question step-6)
    ?fact-1 <- (high-oil-consumption-question step-6)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace engine. MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIRST FIM PAGE WITH BE/BD ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SECOND FIM PAGE WITH BD/BE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule high-oil-consumption-question-at-step14-yes
    (high-oil-consumption-question step-14)
    ?fact-1 <- (high-oil-consumption-question step-14)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace fuel/oil cooler (MM 79-21-01)" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step14-no
    (high-oil-consumption-question step-14)
    ?fact-1 <- (high-oil-consumption-question step-14)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Remove applicable component and check both component and drive pad seal." crlf)
    (printout t "Replace component and/or drive seal as follows:" crlf)
    (printout t "          Component           Seal Replacement Ref" crlf)
    (printout t "          ---------           --------------------" crlf)
    (printout t "   Generator (MM 24-21-01)         MM 72-61-08    " crlf)
    (printout t "   Fuel Pump (MM 73-11-01)         MM 72-61-11    " crlf)
    (printout t "Hydraulic Pump (MM 29-11-05)       MM 72-61-09    " crlf)
    (printout t "    Starter (MM 80-11-01)          MM 72-61-06    " crlf)
    (printout t "    Constant Speed Drive           MM 72-61-07    " crlf) 
    (printout t "(MM 24-11-01)" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SECOND FIM PAGE WITH BE/BD ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; THIRD FIM PAGE WITH BD/BE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule high-oil-consumption-question-at-step15-yes
    (high-oil-consumption-question step-15)
    ?fact-1 <- (high-oil-consumption-question step-15)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Install drain plug" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step15-no
    (high-oil-consumption-question step-15)
    ?fact-1 <- (high-oil-consumption-question step-15)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Examine external plumbing, main gearbox and angle gearbox for obvious leakage per Visual Check 2, 79-01-10.  Is obvious leakage present?" crlf)
    (assert (high-oil-consumption-question step-19))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step19-yes
    (high-oil-consumption-question step-19)
    ?fact-1 <- (high-oil-consumption-question step-19)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Is leakage from oil pressure and/or oil scavenge lines?" crlf)
    (assert (high-oil-consumption-question step-20))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step19-no
    (high-oil-consumption-question step-19)
    ?fact-1 <- (high-oil-consumption-question step-19)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Perform oil system static leak check per Engine Check 1, 79-01-20 and/or oil system monitoring leak check per Engine Check 2, 79-01-20.  Was source of leakage found?" crlf)
    (assert (high-oil-consumption-question step-21))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step20-yes
    (high-oil-consumption-question step-20)
    ?fact-1 <- (high-oil-consumption-question step-20)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Is leakage from No. 3 bearing oil scavenge tube connections?" crlf)
    (assert (high-oil-consumption-question step-22))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step20-no
    (high-oil-consumption-question step-20)
    ?fact-1 <- (high-oil-consumption-question step-20)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is leakage from breather lines?" crlf)
    (assert (high-oil-consumption-question step-23))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step21-yes
    (high-oil-consumption-question step-21)
    ?fact-1 <- (high-oil-consumption-question step-21)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Refer to Engine Check 1 and/or engine check 2 for corrective action." crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step21-no
    (high-oil-consumption-question step-21)
    ?fact-1 <- (high-oil-consumption-question step-21)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Check fuel pump hydraulic stage pressure per Engine Check 2, 71-01-20. Is pressure within limits?" crlf)
    (assert (high-oil-consumption-question step-46))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step22-yes
    (high-oil-consumption-question step-22)
    ?fact-1 <- (high-oil-consumption-question step-22)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Repair No. 3 bearing oil scavenge tube connections as required. MM 79-21-03 AR")
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step22-no
    (high-oil-consumption-question step-22)
    ?fact-1 <- (high-oil-consumption-question step-22)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace Engine.  MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step23-yes
    (high-oil-consumption-question step-23)
    ?fact-1 <- (high-oil-consumption-question step-23)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Is leakage from No. 1 and 2 bearing breather manifold and/or No. 3 bearing breather manifold?" crlf)
    (assert (high-oil-consumption-question step-28))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step23-no
    (high-oil-consumption-question step-23)
    ?fact-1 <- (high-oil-consumption-question step-23)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is leakage from oil instrumentation lines?" crlf)
    (assert (high-oil-consumption-question step-29))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step28-yes
    (high-oil-consumption-question step-28)
    ?fact-1 <- (high-oil-consumption-question step-28)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace No. 1 and 2 bearing breather manifold and/or No. 3 bearing breather manifold as required. MM 79-21-04 R/I" crlf) 
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step28-no
    (high-oil-consumption-question step-28)
    ?fact-1 <- (high-oil-consumption-question step-28)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace engine. MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; THIRD FIM PAGE WITH BE/BD ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FOURTH FIM PAGE WITH BD/BE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule high-oil-consumption-question-at-step29-yes
    (high-oil-consumption-question step-29)
    ?fact-1 <- (high-oil-consumption-question step-29)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace engine. MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step29-no
    (high-oil-consumption-question step-29)
    ?fact-1 <- (high-oil-consumption-question step-29)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is leakage from N2 manual crank pad on main gearbox?" crlf)
    (assert (high-oil-consumption-question step-34))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step34-yes
    (high-oil-consumption-question step-34)
    ?fact-1 <- (high-oil-consumption-question step-34)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Remove N2 manual crank pad and install new o-ring and gasket (if applicable). MM 72-00-00 MP" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step34-no
    (high-oil-consumption-question step-34)
    ?fact-1 <- (high-oil-consumption-question step-34)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is leakage from angle gearbox?" crlf)
    (assert (high-oil-consumption-question step-36))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step36-yes
    (high-oil-consumption-question step-36)
    ?fact-1 <- (high-oil-consumption-question step-36)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace angle gearbox.  MM 72-61-01 R/I.")
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step36-no
    (high-oil-consumption-question step-36)
    ?fact-1 <- (high-oil-consumption-question step-36)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Is leakage from main gearbox?" crlf)
    (assert (high-oil-consumption-question step-39))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step39-yes
    (high-oil-consumption-question step-39)
    ?fact-1 <- (high-oil-consumption-question step-39)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace main gearbox.  MM 72-61-02 R/I.")
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step39-no
    (high-oil-consumption-question step-39)
    ?fact-1 <- (high-oil-consumption-question step-39)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace engine. MM 71-00-02" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FOURTH FIM PAGE WITH BE/BD ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIFTH AND LAST FIM PAGE WITH BD/BE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule high-oil-consumption-question-at-step46-no
    (high-oil-consumption-question step-46)
    ?fact-1 <- (high-oil-consumption-question step-46)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace fuel pump. MM 73-11-01" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step46-yes
    (high-oil-consumption-question step-46)
    ?fact-1 <- (high-oil-consumption-question step-46)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Check ground idle speed. MM 71-00-00 A/T, Test No. 9. Is ground idle speed low?" crlf)
    (assert (high-oil-consumption-question step-49))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step49-yes
    (high-oil-consumption-question step-49)
    ?fact-1 <- (high-oil-consumption-question step-49)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Adjust ground idle speed. MM 71-00-00 A/T, Test No. 9." crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step49-no
    (high-oil-consumption-question step-49)
    ?fact-1 <- (high-oil-consumption-question step-49)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "From idle power, advance thrust level slowly to increase N2 RPM by 10%.  Did N1 increase at least 10% also?" crlf)
    (assert (high-oil-consumption-question step-52))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step52-no
    (high-oil-consumption-question step-52)
    ?fact-1 <- (high-oil-consumption-question step-52)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace Evc. MM 75-31-01" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-at-step52-yes
    (high-oil-consumption-question step-52)
    ?fact-1 <- (high-oil-consumption-question step-52)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "The following are infrequent causes of this fault:" crlf)
    (printout t " 1. Faulty main gearbox deaerator          Ref Engine Check 3, 79-01-20 for resolution" crlf)
    (printout t " 2. PT3 manifold leaks                     Ref Visual Check 8, 71-01-10 for resolution" crlf)
    (printout t " 3. No. 1 and 2 bearing compartment leaks  Replace Engine (MM 71-00-02)" crlf)
    (assert (high-oil-consumption-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule high-oil-consumption-question-diagnosis
    (high-oil-consumption-question diagnosis)
    ?fact-1 <- (high-oil-consumption-question diagnosis)
    (error-code ?inp1)
    ?fact-2 <- (error-code ?inp1)
    (engine-num ?inp2)
    ?fact-3 <- (engine-num ?inp2)
=> 
    (printout t crlf)
    (printout t "----THANKS TO US THE PROBLEM IS SOLVED----" crlf)
    (printout t "========END OF " ?inp1 ?inp2 " PROBLEMS=======" crlf)
    (printout t "----------THANK GOD WE ARE SAFE-----------" crlf)
    (retract ?fact-1)
    (retract ?fact-2)
    (retract ?fact-3)
)


;;;;;;;;;;;;;;;;;;;;;;;;;; END OF FIFTH AND LAST PAGE OF FIM FOR OIL CONSUMPTION... THANK GOD;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;OIL PRESSURE PROBLEM TROUBLESHOOTING;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  CHOSEN PROBLEM 3: OIL PRESSURE

(defrule oil-pressure
    (observed-problem-number 3)
    ?fact <- (observed-problem-number 3)
=>
    (assert (error-code 79-01-CA-0)) 
    (assert (menu-op engine-num))
    (retract ?fact)
)

(defrule abnormal-oil-pressure
    (error-code 79-01-CA-0)
=>
    (printout t "Change thrust setting & check oil press. Did oil press follow thrust change?" crlf)
    (assert (ask-question yesno))
)

(defrule abnormal-oil-pressure-CD ;;WE CONCLUDE THAT WE HAVE A CD OIL PRESSURE PROBLEM
    (error-code 79-01-CA-0)
    ?fact-1 <- (error-code 79-01-CA-0)
    (answer no) 
    ?fact-2 <- (answer no) 
=> 
    (assert (error-code 79-01-CD-0))
    (assert (abnormal-oil-pressure-CD-question start))
    (retract ?fact-1)
    (retract ?fact-2)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIM PAGE WITH CD STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule abnormal-oil-pressure-CD-question-start
    (abnormal-oil-pressure-CD-question start)
    ?fact <- (abnormal-oil-pressure-CD-question start)
=> 
    (printout t "Connect line for air pressure to elbow of oil pressure transmitter, T422. Apply 45 PSI.  Does indicator read 40 to 45 PSI?" crlf)
    (assert (abnormal-oil-pressure-CD-question step-0))
    (assert (ask-question yesno))
    (retract ?fact)
)

(defrule abnormal-oil-pressure-CD-question-at-step0-yes
    (abnormal-oil-pressure-CD-question step-0)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-0)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Adjust oil pressure.  MM 71-00-00 A/T, Test No. 7.  Observe oil pressure indicator. Is oil pressure within limits?" crlf)
    (assert (abnormal-oil-pressure-CD-question step-1))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-at-step0-no
    (abnormal-oil-pressure-CD-question step-0)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-0)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Exchange oil pressure indicators, N30, N31, N32, or N33.  MM 79-32-03." crlf)
    (printout t "Apply 40 to 45 PSI to transmitter. Does indicator read 40 to 45 PSI?" crlf)
    (assert (abnormal-oil-pressure-CD-question step-2))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-at-step1-no
    (abnormal-oil-pressure-CD-question step-1)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-1)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace oil pressure regulating valve. MM 72-61-03." crlf)
    (assert (abnormal-oil-pressure-CD-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-at-step1-yes
    (abnormal-oil-pressure-CD-question step-1)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-1)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "The following item may be an infrequent cause of abnormal oil pressure:" crlf)
    (printout t "     COMPONENT            CORRECTIVE ACTION" crlf)
    (printout t "     ---------            -----------------" crlf)
    (printout t "   Main Oil Pump   Replace main oil pump (MM 72-61-17)" crlf)
    (assert (abnormal-oil-pressure-CD-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-at-step2-yes
    (abnormal-oil-pressure-CD-question step-2)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-2)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace indicator. MM 79-32-03" crlf)
    (assert (abnormal-oil-pressure-CD-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-at-step2-no
    (abnormal-oil-pressure-CD-question step-2)
    ?fact-1 <- (abnormal-oil-pressure-CD-question step-2)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace engine oil pressure transmitter, T422. MM 79-32-01." crlf)
    (assert (abnormal-oil-pressure-CD-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CD-question-diagnosis
    (abnormal-oil-pressure-CD-question diagnosis)
    ?fact-1 <- (abnormal-oil-pressure-CD-question diagnosis)
    (error-code ?inp1)
    ?fact-2 <- (error-code ?inp1)
    (engine-num ?inp2)
    ?fact-3 <- (engine-num ?inp2)
=> 
    (printout t crlf)
    (printout t "----THANKS TO US THE PROBLEM IS SOLVED----" crlf)
    (printout t "========END OF " ?inp1 ?inp2 " PROBLEMS=======" crlf)
    (printout t "----------THANK GOD WE ARE SAFE-----------" crlf)
    (retract ?fact-1)
    (retract ?fact-2)
    (retract ?fact-3)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIM PAGE WITH CD ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIM PAGE WITH CE STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule abnormal-oil-pressure-CE  ;;WE COCNCLUDE THAT WE HAVE A CE OIL PRESSURE PROBLEM
    (error-code 79-01-CA-0)
    ?fact-1 <- (error-code 79-01-CA-0)
    (answer yes) 
    ?fact-2 <- (answer yes) 
=> 
    (assert (error-code 79-01-CE-0))
    (assert (abnormal-oil-pressure-CE-question start))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CE-question-start
    (abnormal-oil-pressure-CE-question start)
    ?fact <- (abnormal-oil-pressure-CE-question start)
=> 
    (printout t "Examine magnetic chip detectors and main oil strainer per Engine Check 18, 71-01-20. Was contamination abnormal?" crlf)
    (assert (abnormal-oil-pressure-CE-question step-0))
    (assert (ask-question yesno))
    (retract ?fact)
)

(defrule abnormal-oil-pressure-CE-question-at-step0-yes
    (abnormal-oil-pressure-CE-question step-0)
    ?fact-1 <- (abnormal-oil-pressure-CE-question step-0)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace main oil strainer.  MM 72-61-05. Replace main oil pressure regulating valve. MM 72-61-03.  Perform oil system contamination inspection.  MM 72-00-00 I/C." crlf)
    (assert (abnormal-oil-pressure-CE-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CE-question-at-step0-no
    (abnormal-oil-pressure-CE-question step-0)
    ?fact-1 <- (abnormal-oil-pressure-CE-question step-0)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Exchange oil pressure indicators, N30, N31, N32, or N33.  MM 79-32-03. Connect air pressure source to elbow on oil pressure transmitter, T422. Apply 45 PSI.  Observe oil pressure indication.  Does indicator read 40-45 PSI?" crlf)
    (assert (abnormal-oil-pressure-CE-question step-2))
    (assert (ask-question yesno))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CE-question-at-step2-yes
    (abnormal-oil-pressure-CE-question step-2)
    ?fact-1 <- (abnormal-oil-pressure-CE-question step-2)
    (answer yes)
    ?fact-2 <- (answer yes)
=>
    (printout t "Replace indicator. MM 79-32-03" crlf)
    (assert (abnormal-oil-pressure-CE-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CE-question-at-step2-no
    (abnormal-oil-pressure-CE-question step-2)
    ?fact-1 <- (abnormal-oil-pressure-CE-question step-2)
    (answer no)
    ?fact-2 <- (answer no)
=>
    (printout t "Replace engine oil pressure transmitter, T422. MM 79-32-01" crlf)
    (assert (abnormal-oil-pressure-CE-question diagnosis))
    (retract ?fact-1)
    (retract ?fact-2)
)

(defrule abnormal-oil-pressure-CE-question-end
    (abnormal-oil-pressure-CE-question diagnosis)
    ?fact-1 <- (abnormal-oil-pressure-CE-question diagnosis)
    (error-code ?inp1)
    ?fact-2 <- (error-code ?inp1)
    (engine-num ?inp2)
    ?fact-3 <- (engine-num ?inp2)
=> 
    (printout t crlf)
    (printout t "----THANKS TO US THE PROBLEM IS SOLVED----" crlf)
    (printout t "========END OF " ?inp1 ?inp2 " PROBLEMS=======" crlf)
    (printout t "----------THANK GOD WE ARE SAFE-----------" crlf)
    (retract ?fact-1)
    (retract ?fact-2)
    (retract ?fact-3)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIM PAGE WITH CE ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
