/*
1. Write queries to return the following: 
a. Display a list of all property names and their property id’s for Owner Id: 1426. 

b. Display the current home value for each property in question a). 

c. For each property in question a), return the following:                                                                      
	i) Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 
   ii) Display the yield. 

 d. Display all the jobs available

e. Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a). 

*/

--Question a
SELECT Prop.Name 
  FROM [Keys].[dbo].[OwnerProperty] as OwnerProp inner join [Keys].[dbo].Property as Prop 
  On OwnerProp.OwnerId=1426 and OwnerProp.PropertyId=Prop.id;

--Question b  

  SELECT Prop.Name,homevalue.Value FROM [Keys].[dbo].[OwnerProperty] as OwnerProp 
  inner join [Keys].[dbo].Property as Prop
  On OwnerProp.OwnerId=1426 and OwnerProp.PropertyId=Prop.id 
  inner join keys.dbo.PropertyHomeValue as homevalue on OwnerProp.PropertyId=homevalue.PropertyId 
  and homevalue.IsActive=1 order by prop.Name;

 --Question c
  
SELECT P.Name as PropertyName, OP.PropertyId, PHV.Value, TP.PaymentAmount,TPF.Name as FrequencyType,TP.StartDate,TP.EndDate,
     CAST(
	 CASE 
       WHEN TPF.Name='Weekly' THEN DATEDIFF(week,TP.StartDate,TP.EndDate) * TP.PaymentAmount
       WHEN TPF.Name='Fortnightly' THEN DATEDIFF(week,TP.StartDate,TP.EndDate) * (TP.PaymentAmount/2)
	   WHEN TPF.Name='Monthly' THEN DATEDIFF(month,TP.StartDate,TP.EndDate) * TP.PaymentAmount
     ELSE 0
    END as decimal(15,2)) as TotalPayment,
	CASE 
       WHEN TPF.Name='Weekly' THEN DATEDIFF(week,TP.StartDate,TP.EndDate) * TP.PaymentAmount
       WHEN TPF.Name='Fortnightly' THEN DATEDIFF(week,TP.StartDate,TP.EndDate) * (TP.PaymentAmount/2)
	   WHEN TPF.Name='Monthly' THEN DATEDIFF(month,TP.StartDate,TP.EndDate) * TP.PaymentAmount
     ELSE 0
    END / PHV.Value as Yield
	FROM OwnerProperty OP
    JOIN Property P 
      ON OP.PropertyId=P.Id
    JOIN PropertyHomeValue PHV 
	  ON PHV.PropertyId=P.Id
	JOIN TenantProperty TP
	  ON TP.PropertyId=P.Id
	JOIN TenantPaymentFrequencies TPF
	  ON TPF.Id=TP.PaymentFrequencyId
	where OwnerId=1426  and PHV.IsActive=1 order by PropertyName
   
 --Question d
 --SELECT *  FROM [Keys].[dbo].[Job] where JobStatusId=1;
 SELECT * FROM Job where JobStatusId<>4 and JobStatusId<>5 and JobStatusId<>6 and propertyid in (5597,5637,5638);


  --Question e
SELECT Prop.Name as 'Property Name',personinfo.FirstName,personinfo.LastName,
 TenantProp.PaymentAmount,
 TPF.Name as 'Rental Payments' FROM [Keys].[dbo].[OwnerProperty] as OwnerProp 
  inner join [Keys].[dbo].Property as Prop
  On OwnerProp.OwnerId=1426 and OwnerProp.PropertyId=Prop.id 
  inner join keys.dbo.TenantProperty as TenantProp on OwnerProp.PropertyId=TenantProp.PropertyId 
  inner join Keys.dbo.Person as personinfo on TenantProp.TenantId=personinfo.Id
  inner join keys.dbo.TenantPaymentFrequencies as TPF on TenantProp.PaymentFrequencyId=TPF.Id;

