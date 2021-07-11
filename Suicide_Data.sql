CREATE DATABASE Suicide_Rate

USE Suicide_Rate

/* Creating a Procedure to select all records*/

/* To drop a procedure
 DROP Procedure if exists Procedure_Name*/

CREATE Procedure SelectAllRecords
As
Select * From Sucide_Data
GO

/* Country Wise Suicides*/
Select 
country As Country,
SUM(suicides_no) As Total_Suicides
FROM
Sucide_data
Group By country
Order By Total_Suicides Desc

/* Year-On-Year Basis Increase in Deaths Across the countries*/
/* Creating Temp Table
Select Col1,Col2
INTO ##Table_Name
FROM TABLE
*/

CREATE TABLE YOY_DATA(
Country VARCHAR(50),
Year Integer,
suicides_no Integer
);

Insert Into YOY_DATA
Select
country, year, SUM(suicides_no)
FROM Sucide_data
Group By country,year
Order By country ASC

Select 
Country,
Year,
SUM(suicides_no) Over (Partition By Country Order By Year) As Suicides_Increments
FROM YOY_DATA
ORDER BY Country,Year

/* Finding Top nth Country*/
/*Select Top 1 *
FROM
(Select DISTINCT TOP(n)
Country,
SUM(suicides_no) As Total_Suicides
FROM YOY_DATA
GROUP BY Country
Order By Total_Suicides DESC) TOP2Suicides
Order By TOP2Suicides.Total_Suicides*/

/* Top 5 Countries*/
Select Top 5 Country, SUM(suicides_no) As Total
FROM YOY_DATA
Group By Country
Order By Total Desc

/*Age group that is committing most suicide*/
Select 
age As Age,
SUM(suicides_no) As Total
FROM
Sucide_data
Group By age
Order by Total Desc

/*Gender that is committing most suicide*/
Select
Case
When sex='male' Then 'Male'
When sex='female' Then 'Female'
End As Gender,
CONCAT(str(SUM(suicides_no)/(Select SUM(suicides_no) FROM Sucide_data)*100),'%') As Gender_Percent
FROM
Sucide_data
Group By sex
Order by Gender_Percent Desc

/* Males and Females suicides across countries*/
select 
Males.country,
Males.year,
Males.Total_Sum_Males,
Females.Total_Sum_Females
FROM
(Select
country,
year,
SUM(suicides_no) As Total_Sum_Males
FROM Sucide_data
Where sex = 'male'
Group By country,year) As Males
FULL JOIN
(Select
country,
year,
SUM(suicides_no) As Total_Sum_Females
FROM Sucide_data 
Where sex = 'female'
Group By country,year) As Females On Males.country=Females.country and Males.year = Females.year
