begin tran


insert sales.Currency
(CurrencyCode, name)
values
('BZB', 'BBZZ')

commit;