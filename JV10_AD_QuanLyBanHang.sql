create database QUANLYBANHANG1;
use QUANLYBANHANG1;

create table CUSTOMERS(
	customer_ID varchar(4) primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(25) not null,
    address varchar(255) not null
);

insert into CUSTOMERS value
('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','0984756322','Cầu Giấy, Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com','0984875926','Ba Vì, Hà Nội'),
('C003','Tô Ngọc Vũ','vutn@gmail.com','0904725784','Mộc Châu , Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com','0984635365','Vinh, Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com','0989735624','Hai Bà Trưng, Hà Nội');

create table ORDERS(
	order_ID varchar(4) primary key,
    customer_ID varchar(4) not null,
    order_date date not null,
    total_amount double not null,
    foreign key (customer_ID) references CUSTOMERS(customer_ID)
);

insert into ORDERS(order_ID,customer_ID,total_amount,order_date) values
('H001','C001',52999997,'2023-2-22'),
('H002','C001',80999997,'2023-3-11'),
('H003','C002',54359998,'2023-1-22'),
('H004','C003',102999995,'2023-3-14'),
('H005','C003',80999997,'2022-3-12'),
('H006','C004',110449994,'2023-2-1'),
('H007','C004',79999996,'2023-3-29'),
('H008','C005',29999998,'2023-2-14'),
('H009','C005',28999999,'2023-1-10'),
('H010','C005',149999994,'2023-4-1');

create table PRODUCTS(
	product_ID varchar(4) primary key,
    name varchar(255) not null,
    decription text ,
    price double not null,
    status bit(1) default 1
);

insert into PRODUCTS(product_ID,name,decription,price) values
('P001','Iphone 13 Promax','Bản 512 GB , xanh lá',22999999),
('P002','Dell Vostro V3510','Core I5 Ram 8GB',    14999999),
('P003','Macbook Pro M2' , '8CPU 10GPU 8GB 256GB',28999999),
('P004','Apple Watch Ultra','Titanium Alpine Lôp Small',18999999),
('P005','Airpods 2 2022','Spatial Audio',4090000);

create table ORDERS_DETAILS(
	order_ID varchar(4) not null,
	product_ID varchar(4)not null,
    price double not null,
    quantity int(11),
    foreign key (order_ID) references ORDERS(order_ID),
    foreign key (product_ID) references PRODUCTS(product_ID),
    primary key(order_ID,product_ID)
);
insert into orders_details values
("H001","P002","14999999",1),
("H001","P004","18999999",2),
("H002","P001","22999999",1),
("H002","P003","28999999",2),
("H003","P004","18999999",2),
("H003","P005","4090000",14),
("H004","P002","14999999",3),
("H004","P003","28999999",2),
("H005","P001","22999999",1),
("H005","P003","28999999",2),
("H006","P005","4090000",15),
("H006","P002","14999999",6),
("H007","P004","18999999",3),
("H007","P001","22999999",1),
("H008","P002","14999999",2),
("H009","P003","28999999",1),
("H010","P003","28999999",2),
("H010","P001","22999999",4);

-- Bài 3: Truy vấn dữ liệu :
-- 1.	Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name ,email ,phone ,address from CUSTOMERS;

-- 2.	Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). 
select name,phone,address from CUSTOMERS c
join ORDERS o on c.customer_ID = o.customer_ID
where o.order_date >= '2023-3-1' and o.order_date <'2023-4-1';

-- 3.	Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). 
select month(order_date) as 'Tháng(2023)',sum(total_amount) as 'Tổng doanh Thu' from ORDERS
where year(order_date) = '2023'
group by month(order_date)
order by month(order_date);

-- 4.	Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại). 
select name as 'Tên', email, phone as 'Điện thoại', address as 'Địa chỉ' from CUSTOMERS c
where c.customer_id not in (select ORDERS.customer_id from orders where month(order_date)=2)
group by name;

-- 5.	Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra). 
select p.product_id as 'Mã SP' , p.name as 'Tên SP', sum(quantity) as 'Tổng SP bán' from products p 
join orders_details od on p.product_id = od.product_id
join orders o on o.order_id = od.order_id
where o.order_date >= '2023-3-1' and o.order_date <'2023-4-1'
group by od.product_id;

-- 6.	Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). 
select c.customer_id as  'Mã KH', c.name as 'Tên KH', sum(total_amount) as 'Chi Tiêu'
from customers c
join orders o on c.customer_id = o.customer_id
where c.customer_id  in (select orders.customer_id from orders where year(order_date)=2023)
group by c.customer_id 
order by sum(total_amount) desc;

-- 7.	Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . 
select c.name as 'Tên KH', o.total_amount as 'Tổng Tiền', o.order_date as 'Ngày tạo HĐ', sum(od.quantity) as 'Tổng SLSP'
from orders o
join orders_details od on od.order_id = o.order_id
join customers c on c.customer_id = o.customer_id
group by o.order_id
having sum(od.quantity) >= 5
order by sum(od.quantity) desc;


-- Bài 4: Tạo View, Procedure :
-- 1.	Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn . 
create view THONG_TIN_HOA_DON as
select c.name as 'Tên KH', c.phone as 'Số ĐT', c.address as 'Địa Chỉ', o.total_amount as 'Tổng Tiền' ,o.order_date as 'Ngày tạo HD'
from CUSTOMERS c 
join ORDERS o on c.customer_id = o.customer_id;
select * from THONG_TIN_HOA_DON;

-- 2.	Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. 
create view THONG_TIN_KHACH_HANG as
select c.name as 'TÊN KH', c.address as 'ĐỊA CHỈ', c.phone as 'SỐ ĐT', count(o.order_id) as 'TỔNG ĐƠN'
from orders o
join customers c on c.customer_id = o.customer_id
group by c.customer_id;
select * from THONG_TIN_KHACH_HANG;

-- 3.	Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
create view THONG_TIN_SP AS
select p.name as 'TÊN SP', p.decription as 'MÔ TẢ', p.price as 'GIÁ BÁN', sum(od.quantity) as 'TỔNG SỐ LƯỢNG BÁN'
from products p
join orders_details od on p.product_id = od.product_id
group by p.product_id;
select * from THONG_TIN_SP;

-- 4.	Đánh Index cho trường `phone` và `email` của bảng Customer. 
create index CUS_INDEX on CUSTOMERS(phone,email);

-- 5.	Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
create procedure TT_KHACHHANG(in cID varchar(4))
begin
	select * from CUSTOMERS where customer_id = cID;
end //

-- 6.	Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. 
DELIMITER //
CREATE PROCEDURE TT_SAN_PHAM()
BEGIN
	select * from products;
END //
call TT_SAN_PHAM();

-- 7.	Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE DANHSACH_MANGUOIDUNG
(IN CustomerNum varchar(4))
BEGIN
  SELECT o.order_id ,c.customer_id, o.order_date, c.name, c.email, c.phone, c.address FROM orders o 
  join customers c on c.customer_id = o.customer_id
  WHERE c.customer_id = CustomerNum;
END //

call DANHSACH_MANGUOIDUNG('C003');

-- 8.	Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. 
DELIMITER //
CREATE PROCEDURE DON_HANG_MOI
(IN orderdID varchar(4), customerID varchar(4), order_date date, total double)
BEGIN
  insert into orders values (orderdID,customerID,order_date,total);
  select * from orders o where o.order_id = orderID;
END //

-- 9.	Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. 



