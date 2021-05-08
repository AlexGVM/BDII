BEGIN TRANSACTION

update person.CountryRegion
set name= 'otro'
where CountryRegionCode= 'AD';

IF ((1+3) = 2) --CONDICIÓN
	begin
	rollback transaction;
	print 'rollback'
	end
	else 
	begin 
		commit transaction;
		print 'commit'
	end