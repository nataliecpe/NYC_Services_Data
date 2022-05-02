
----- Data cleaning from NYCprograms table -----

-- Drop columns
Alter Table NYCprograms$
Drop Column [Population served];

Alter Table NYCprograms$
Drop Column [Age Group];

-- Fix strings
Select [Program category] From SocialServices..NYCprograms$
Update SocialServices..NYCprograms$
Set [Program category] = REPLACE([Program category], 'Cash &amp; expenses', 'Cash & expenses')
Select [Program category], COUNT(*) As Count From SocialServices..NYCprograms$ Group By [Program category]

-- Fix strings
Update SocialServices..NYCprograms$
  Set pop1=REPLACE(pop1,'Pregnant &amp; new parents', 'Pregnant & new parents'),
      pop2=REPLACE(pop2,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop3=REPLACE(pop3,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop4=REPLACE(pop4,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop5=REPLACE(pop5,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop6=REPLACE(pop6,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop7=REPLACE(pop7,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop8=REPLACE(pop8,'Pregnant &amp; new parents', 'Pregnant & new parents'),
	  pop9=REPLACE(pop9,'Pregnant &amp; new parents', 'Pregnant & new parents')

-- Change similar strings to be the exact same string
Update SocialServices..NYCprograms$
   Set [Government agency] = REPLACE([Government agency], 'NYC Human Resource Administration', 'NYC Human Resources Administration')
Update SocialServices..NYCprograms$
   Set [Government agency] = REPLACE([Government agency], 'The City University of New York (CUNY)', 'The City University of New York')
Update SocialServices..NYCprograms$   
   Set [Government agency] = REPLACE([Government agency], 'NYC Department of Consumer Affairs / Internal Revenue Service', 'NYC Department of Consumer Affairs / IRS')
Update SocialServices..NYCprograms$    
   Set [Government agency] = REPLACE([Government agency], 'NYC Department of Education/NYC Department of Health and Mental Hygiene', 'NYC Department of Education/NYC Department of Health & Mental Hygiene')
Update SocialServices..NYCprograms$	   
	Set [Government agency] = REPLACE([Government agency], 'NYC Administration for Children\u2019s Services', 'NYC Administration for Children''s Services')
Update SocialServices..NYCprograms$	   
	Set [Government agency] = REPLACE([Government agency], 'NYC Department of Education/District 79', 'NYC Department of Education')

-- All entries in pop columns have a space in front of them, except for pop1. Add space in front of all entries in pop1 column 
Update SocialServices..NYCprograms$
	Set pop1 = ' '+pop1 

-- Delete duplicate rows
With cte As(
	Select [Unique ID number], ROW_NUMBER() Over(Partition By [Unique ID number] Order By [Unique ID number]) row_num
	From SocialServices..NYCprograms$
)
Delete From cte
Where row_num > 1

-------------------------------------------------------------
----- Queries to use for later visualizations -----

-- Join service map table and demographics table on ZIP code
Select * From SocialServices..resource_map
Join SocialServices..demographics 
On resource_map.ZIP = demographics.[JURISDICTION NAME]

Select Service, Count(*) From SocialServices..resource_map Group By Service
Select [Program category], Count(*) From SocialServices..NYCPrograms$ Group By [Program category]

-- Count the occurances of each population group across all population columns
Select Populations, Count(*) As Count From (
Select pop1 As Populations From SocialServices..NYCprograms$
Union All
Select pop2 As Populations From SocialServices..NYCprograms$
Union All
Select pop3 As Populations From SocialServices..NYCprograms$
Union All
Select pop4 As Populations From SocialServices..NYCprograms$
Union All
Select pop5 As Populations From SocialServices..NYCprograms$
Union All
Select pop6 As Populations From SocialServices..NYCprograms$
Union All
Select pop7 As Populations From SocialServices..NYCprograms$
Union All
Select pop8 As Populations From SocialServices..NYCprograms$
Union All
Select pop9 As Populations From SocialServices..NYCprograms$) myTab
Group By Populations


