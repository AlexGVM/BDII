insert tmp_clase1
select P.FirstName, P.LastName, bea.AddressID, bea.AddressTypeID,
 a.AddressLine1, a.City
from person.Person P
INNER JOIN person.BusinessEntity BE on (P.BusinessEntityID = BE.BusinessEntityID)
INNER JOIN person.BusinessEntityAddress BEA ON (BE.BusinessEntityID = BEA.BusinessEntityID and BEA.AddressTypeID =2) --cuantos con direccion
INNER JOIN person.Address A on (BEA.AddressID = a.AddressID and a.city = 'Redmond')
order by p.BusinessEntityID

truncate table tmp_clase1;

declare @cantidad integer;
insert tmp_clase1;

--delete sin from es un truncate

select @cantidad = count(1)
from tmp_clase1;

if ( @cantidad>500) begin 
print 'Mayor' 
end else
begin
print 'menor'
end;
select *
from tmp_clase1;

insert tmp_clase1
select p.businessEntityID, P.FirstName, P.LastName, bea.AddressID, bea.AddressTypeID,
 a.AddressLine1, a.City
from person.Person P
INNER JOIN person.BusinessEntity BE on (P.BusinessEntityID = BE.BusinessEntityID)
INNER JOIN person.BusinessEntityAddress BEA ON (BE.BusinessEntityID = BEA.BusinessEntityID and BEA.AddressTypeID =2) --cuantos con direccion
INNER JOIN person.Address A on (BEA.AddressID = a.AddressID and a.city = 'Redmond')
order by p.BusinessEntityID