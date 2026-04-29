create table manger(
m_id int primary key identity(1,1),
mang_id as ('mang-'+right('000'+cast(m_id as varchar(3)),3)),
ssn nvarchar (20),
name varchar (50),
address nvarchar (100),
phone nvarchar (20));

create table department(
id int primary key identity(1,1),
dept_id as ('dept-'+right('000'+cast(id as varchar(3)),3)),
dept_name varchar(50),
m_id int,
foreign key (m_id) references manger(m_id))

insert into manger(ssn,name,phone,address)
values('1245','ali','01245284','cairo-egypt'),
('1485','mohamed','01244284','alex-egypt'),
('3333', 'khaled', '01000000', 'giza-egypt'),
('4444', 'ahmed', '01111111', 'tanta-egypt');

insert into department(dept_name,m_id)
values('ss',1),('tt',2),('it',3),('ai',4)

create table pilot(
pilot_id int primary key identity(1,1),
ssn int not null unique,
license_num int,
name char(50),
phone int,
address char(50),
dept_id int,
foreign key(dept_id) references department(id))

insert into pilot(ssn,license_num,name,phone,address,dept_id)
values(1,345,'ali',01289896,'portsaid',2),
(3,453,'ahmed',01289896,'alex',4),
(5,323,'maged',01289896,'cairo',3)

insert into pilot(ssn,license_num,name,phone,address,dept_id)
values(9,456,'ramy',01253556,'luxor',3),
(8,586,'megahed',01253556,'luxor',4),
(6,344,'mena',01253556,'luxor',1)
DELETE FROM pilot
WHERE ssn IN (9, 8, 6);


create table plane(
regestiration_num int primary key,
model_num int not null,
capacity int,
weight int,
dept_id int,
foreign key (dept_id) references department(id))

insert into plane(regestiration_num,model_num,capacity,weight,dept_id)
values(1,455,25,15000,4),
(3,577,35,10000,1),
(5,376,20,25000,3)


create table flight(
flight_num int primary key,
destination char(50) not null,
date_of_flying date,
departure_time time,
arrival_time time,
houres_flying int,
pilot_id int,
dept_id int,
regestiration_num int,
foreign key(pilot_id)references pilot(pilot_id),
foreign key(dept_id)references department(id),
foreign key(regestiration_num) references plane (regestiration_num))

insert into flight(flight_num,destination,date_of_flying,departure_time,arrival_time,houres_flying,pilot_id,dept_id,regestiration_num)
values(50,'aswan','2025-10-05','15:00:00','17:00:00',2,1,3,5),
(60,'hardga','2025-12-10','20:00:00','23:59:59',4,2,4,1),
(65,'sewa','2025-11-15','15:00:00','20:00:00',5,3,1,3)
update flight
set date_of_flying='2025-10-01'
where flight_num=60


create table passangers(
passanger_id int primary key identity(1,1),
name char(50) not null,
phone int,
address char(70))

insert into passangers(name,phone,address)
values('kaream',0021515616,'alex'),
('maged',002515616,'mansoura'),
('kaream',0022145616,'damnhore')

create table reservation(
reservation_id int primary key identity(1,1),
seats_reserve int,
passanger_id int,
flight_num int)
alter table reservation
add constraint fk_flight_num foreign key (flight_num) references flight(flight_num)

insert into reservation(seats_reserve,passanger_id,flight_num)
values(20,1,50),
(35,2,50),
(15,3,65)

--display the name of each pilot and the name of his manager
select p.name as pilot_name , m.name as manager_name
from pilot as p
join department as d on p.dept_id=d.id
left join manger as m on d.m_id=m.m_id
--display the model number of each plane that will be used in a flight to hardga last week
select distinct model_num
from plane as p
join flight as f on f.regestiration_num=p.regestiration_num
where f.destination='hardga' and f.date_of_flying between DATEADD(DAY,-7,GETDATE()) and GETDATE()
--display the maximum capacity of the flight number 65
select p.capacity
from plane as p
join flight as f on f.regestiration_num=p.regestiration_num
where flight_num=65
--perform a report that display the flight number of first flight to aswan
select f.flight_num
from flight as f
where destination='aswan'
order by date_of_flying asc
--perform a report that display a details of pilot information and flight information who will responsible for
select p.*,f.*
from pilot as p
join flight as f on f.pilot_id=p.pilot_id
--display the flights information that will arrived after 1 hour
select f.*
from flight as f
where houres_flying>1
--display the number of pilots in each department
select d.dept_name,COUNT(pilot_id) as number_of_pilot
from department as d
join pilot as p on d.id =p.dept_id
group by dept_name
--display the number of the planes in each department that arrived in last 3days
select d.dept_name,COUNT(p.regestiration_num) as total_planes
from plane as p
join department as d on p.dept_id=d.id
join flight as f on p.regestiration_num=f.regestiration_num
where date_of_flying between DATEADD(day,-3,GETDATE()) and GETDATE()
group by dept_name
--display the number of passangers in each flight and information about their pilot
select f.flight_num, p.name,p.address,p.pilot_id,p.phone,p.license_num,p.dept_id,p.ssn,COUNT(r.passanger_id) as number_of_passangers
from flight as f
join reservation as r on r.reservation_id =f.regestiration_num
join pilot as p on p.pilot_id=f.pilot_id
group by f.flight_num,p.name,p.address,p.pilot_id,p.phone,p.license_num,p.dept_id,p.ssn
--display the manager`s name of the department that contains max planes of number
select m.name,d.dept_name
from department as d
left join manger as m on m.m_id=d.m_id
where d.id=(
select top 1 d.id
from plane
group by dept_id
order by COUNT(regestiration_num) Desc)