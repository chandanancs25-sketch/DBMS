create database bank;
use bank;
-- Week 3 create Table and insert values
create table branch(branchname varchar(50),
branchcity varchar(50),assets int,primary key(branchname)); 
desc branch;
insert into branch values("SBI_chamrajpet","bengaluru",50000);
insert into branch values("SBI_residencyroad","bengaluru",10000);
insert into branch values("SBI_shivajiroad","bombay",20000);
insert into branch values("SBI_parlimentroad","delhi",10000);
insert into branch values("SBI_jantarmantar","delhi",20000);
select*from branch;


create table bankaccount(accno int,
branchname varchar(50),balance int,primary key(accno),
foreign key(branchname) references branch (branchname));
desc bankaccount;
insert into bankaccount values(1,"SBI_chamrajpet",2000);
insert into bankaccount values(2,"SBI_residencyroad",5000);
insert into bankaccount values(3,"SBI_shivajiroad",6000);
insert into bankaccount values(4,"SBI_parlimentroad",9000);
insert into bankaccount values(5,"SBI_jantarmantar",8000);
insert into bankaccount values(6,"SBI_shivajiroad",4000);
insert into bankaccount values(8,"SBI_residencyroad",4000);
insert into bankaccount values(9,"SBI_parlimentroad",3000);
insert into bankaccount values(10,"SBI_residencyroad",5000);
insert into bankaccount values(11,"SBI_jantarmantar",2000);
select*from bankaccount;


create table bankcustomer (customername varchar(20) primary key,
customerstreet varchar(50),city varchar(50));
desc bankcustomer;
insert into bankcustomer values("avinash","bull_temple_road","bengaluru");
insert into bankcustomer values("dinesh","bannergatt_road","bengaluru");
insert into bankcustomer values("mohan","nationalcollege_road","bengaluru");
insert into bankcustomer values("nikil","akbar_road","delhi");
insert into bankcustomer values("ravi","prithviraj_road","delhi");
select*from bankcustomer;


create table depositer(customername varchar(20),
accno int,foreign key(customername)references bankcustomer(customername),
foreign key(accno)references bankaccount(accno));
desc depositer;      
insert into depositer values("avinash",1);                                                                 
insert into depositer values("dinesh",2);                                                                 
insert into depositer values("nikil",4);                                                                 
insert into depositer values("ravi",5);                                                                 
insert into depositer values("avinash",8);                                                                 
insert into depositer values("nikil",9);                                                                 
insert into depositer values("dinesh",10);                                                                 
insert into depositer values("nikil",11);   
select*from depositer;      


create table loan (loannumber int,branchname varchar(50),
amount int,foreign key(branchname) references branch(branchname));                                                       
desc loan;
insert into loan values(1,"SBI_chamrajpet",1000);
insert into loan values(2,"SBI_residencyroad",2000);
insert into loan values(3,"SBI_shivajiroad",3000);
insert into loan values(4,"SBI_parlimentroad",4000);
insert into loan values(5,"SBI_jantarmantar",5000);
select*from loan;

-- Week 4 Extra Queries
-- Q1
create view v1 as select customername from depositer
 natural join bankcustomer group by customername having count(*)>=2;
select*from v1; 

-- Q2
select customername from depositer d,
bankaccount a where d.accno=a.accno and a.branchname="SBI_residencyroad" 
group by d.customername having count(d.customername)>=2;

-- Q3
select customername,accno from depositer
 where accno in (select accno from bankaccount a,branch b 
 where a.branchname=b.branchname and b.branchcity="delhi");

-- Q4
delete from bankaccount where branchname in(select branchname from branch where branchcity="bombay");
select*from bankaccount;

-- Q5
select *from loan order by amount desc;

-- Q6
select distinct customername from depositer union(select customername from bankcustomer); 

-- Q7
create view v2 as
select branchname,sum(balance) from bankaccount group by branchname;
select *from v2;

-- Q8
update bankaccount set balance=balance*1.05;
set sql_safe_updates=0;
select *from bankaccount;