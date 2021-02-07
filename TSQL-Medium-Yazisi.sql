Create Database FirstDatabase
go
go
use FirstDatabase
go

create table Employees(
EmployeeId tinyint identity primary key,
EmployeeName varchar(30) not null,
EmployeeSurname varchar(30) not null,
EmployeeType tinyint,
EmployeeSalary money,
EmployeeIsActive bit not null default(1)
)

go

create table EmployeeTypes(
TypeId tinyint identity primary key,
TypeName varchar(30),
)

go

create table ProductCategories(
CategoryId tinyint identity primary key,
CategoryName varchar(50)
)

go

Create Table Products(
ProductId int identity primary key,
ProductName varchar (50),
ProductCategory tinyint,
ProductQuantity int,
ProductPrice decimal,
ProductIsActive bit not null default(1)
)

go

cReatE tAble Orders(
OrderId int identity primary key,
OrderDate datetime,
OrderTotal money,
OrderProducts int,
OrderCashier tinyint,
OrderSaleAssistant tinyint,
OrderIsActive bit not null default(1),
OrderProductQuantity int
)
go

go
go 
go

alter table Products
add foreign key(ProductCategory) references ProductCategories(CategoryId)
go
alter  table Employees
add foreign key (EmployeeType) references EmployeeTypes(TypeId)
go
alter table  Orders 
add foreign key (OrderProducts) references Products(ProductId)
go
alter table Orders
add foreign key (OrderCashier) references Employees(EmployeeId)
go
alter table Orders 
add foreign key (OrderSaleAssistant) references Employees(EmployeeId)
go

alter table Orders add constraint CK_OrderDate default GetDate() for OrderDate
go

create trigger TRG_StockReduction
On Orders
after insert 
as
Declare @ProductId int
declare @SoldQuantity int
select @ProductId = OrderProducts , @SoldQuantity =@SoldQuantity-OrderProductQuantity from inserted

Update Products set ProductQuantity = ProductQuantity-@SoldQuantity
where ProductId=@ProductId
GO


INSERT INTO EmployeeTypes( TypeName)VALUES ( 'Cashier');
Go
INSERT INTO EmployeeTypes(TypeName)VALUES ( 'SaleAssistant');
go
INSERT INTO EmployeeTypes(TypeName)VALUES ( 'Store Manager');
go


INSERT INTO Employees(EmployeeName,EmployeeSurname,EmployeeSalary,EmployeeType)VALUES ( 'Mustafa Can', 'Kýrma',3000,1);
go
INSERT INTO Employees(EmployeeName,EmployeeSurname,EmployeeSalary,EmployeeType)VALUES ( 'Freddie', 'Mercury',3000,2);
go
INSERT INTO Employees(EmployeeName,EmployeeSurname,EmployeeSalary,EmployeeType)VALUES ( 'Jimmy', 'Page',3000,3);
go


INSERT INTO ProductCategories(CategoryName)VALUES ('Buzdolabý');
go
INSERT INTO ProductCategories(CategoryName)VALUES ('Çamaþýr Makinesi');
go
INSERT INTO ProductCategories(CategoryName)VALUES ('Televizyon');
go

INSERT INTO Products(ProductName,ProductQuantity,ProductPrice,ProductCategory)VALUES ( 'Arçelik Gri Buzdolabý', 50,4000,1)
go
INSERT INTO Products(ProductName,ProductQuantity,ProductPrice,ProductCategory)VALUES ( 'Vestel 4K Tv', 10,4000,3);
go
INSERT INTO Products(ProductName,ProductQuantity,ProductPrice)VALUES ( 'apple iphone', 3,2500);
go
INSERT INTO Products(ProductName,ProductQuantity,ProductPrice, ProductCategory)VALUES ( 'LG FHD TV', 1,2500, 3);
go
create Procedure SP_SellProduct
(
@OrderProducts int,
@OrderCashier tinyint,
@OrderSaleAssistant tinyint,
@OrderProductQuantity int,
@OrderTotalCost money
)
as 
begin 
     insert into Orders (OrderProducts,OrderCashier,OrderSaleAssistant,OrderProductQuantity,OrderTotal)
values                  (@OrderProducts, @OrderCashier ,@OrderSaleAssistant, @OrderProductQuantity, @OrderTotalCost)
end
go

alter Procedure SP_SellProduct
(
@OrderProducts int,
@OrderCashier tinyint,
@OrderSaleAssistant tinyint,
@OrderProductQuantity int,
@OrderTotalCost money,
@MSG varchar(500) ='Order Added Successfully'
)
as 
begin try
     insert into Orders (OrderProducts,OrderCashier,OrderSaleAssistant,OrderProductQuantity,OrderTotal)
values                  (@OrderProducts, @OrderCashier ,@OrderSaleAssistant, @OrderProductQuantity, @OrderTotalCost)
Print @MSG 

end try
begin catch
set @MSG=ERROR_MESSAGE()
print @MSG
end catch
go


exec SP_SellProduct 1,1,2,10,40000

use FirstDatabase



go
use FirstDatabase
create  view LowStockProducts
as
select ProductName, ProductQuantity from Products where ProductQuantity<5
go
create view OrdersList 
as
select OrderProducts, OrderProductQuantity,OrderTotal from Orders
go

select * from LowStockProducts
select * from OrdersList