-- examples for SQLite 
-- example interaction, after starting sqlite3 from command line:
-- sqlite> .read shopping.sql 
-- example: HW4, Q4: Give all (cID, pID, cnt) triples, where cnt is the total number of times customer cID placed product pID on their shopping list and cID is a customer living in city1
-- sqlite> with eindhovenaren (cID) as ( select cID from customer where city = "city1" ), productCounts (cID, pID, cnt) as ( select cID, pID, count(*) from shoppinglist group by cID, pID ) select * from productCounts where cID in eindhovenaren;
-- 1|1|2
-- 1|2|1
-- 1|3|1
-- 2|1|1
-- 2|2|1
-- 2|3|1
-- 3|2|1
-- sqlite> .exit
-- 

create table customer ( 
    cID Integer,
    cName Text,
    Street Text,
    City Text,
    primary key (cID));

create table store ( 
    sID Integer,
    sName Text,
    Street Text,
    City Text,
    primary key (sID));
    
create table product ( 
    pID Integer,
    pName Text,
    suffix Text,
    primary key (pID));
    
create table shoppinglist ( 
    cID Integer,
    pID Integer,
    quantity Integer,
    date Date,
    primary key (cID, pID, date),
    foreign key (cID) references customer(cID),
    foreign key (pID) references product(pID));
    
create table purchase (
    tID Integer,
    cID Integer,
    sID Integer,
    pID Integer,
    date Date,
    quantity Integer,
    price Decimal(10, 2),
    primary key (tID, pID),
    foreign key (cID) references customer(cID),
    foreign key (sID) references store(sID),
    foreign key (pID) references product(pID));
    
create table inventory ( 
    sID Integer,
    pID Integer,
    date Date,
    quantity Integer,
    unit_price Decimal(10, 2),
    primary key (sID, pID, date),
    foreign key (sID) references store(sID),
    foreign key (pID) references product(pID));    
    
    
-- example of customer(cID, cName, street, city)
insert into customer values (1, 'c1', 'str1', 'city1');
insert into customer values (2, 'c1', 'str2', 'city1');
insert into customer values (3, 'c3', 'str1', 'city1');
insert into customer values (4, 'c4', 'str2', 'city2');

-- example of store(sID, sName, street, city)

-- s1, s2, s3 are store chains, s1 does not has a store in city4 , s3 is only in city4 
insert into store values (1, 's1', 'str1', 'city1');
insert into store values (2, 's1', 'str2', 'city1');
insert into store values (3, 's1', 'str1', 'city2');
insert into store values (4, 's1', 'str1', 'city3');
insert into store values (5, 's2', 'str4', 'city3');
insert into store values (6, 's2', 'str2', 'city4');
insert into store values (7, 's3', 'str1', 'city4');
insert into store values (8, 's3', 'str5', 'city4');
insert into store values (9, 's4', 'str1', 'city4');


-- example of product(pID, pName, suffix)
insert into product values (1, 'p1', '_1');
insert into product values (2, 'p1', '_2');
insert into product values (3, 'p3', '_1');
insert into product values (4, 'p4', '_1');
insert into product values (5, 'p5', '_1');



-- example of shoppinglist(cID, pID, quantity, date)

-- cid=1
insert into shoppinglist values (1, 1, 2, '2017-01-01');
insert into shoppinglist values (1, 1, 10, '2017-01-02');
insert into shoppinglist values (1, 2, 3, '2017-01-02');
insert into shoppinglist values (1, 3, 1, '2017-01-02');
-- cid=2
insert into shoppinglist values (2, 1, 3, '2017-01-01');
insert into shoppinglist values (2, 2, 5, '2017-01-01');
insert into shoppinglist values (2, 3, 4, '2017-01-02');
-- cid=3
insert into shoppinglist values (3, 2, 10, '2017-01-02');
-- cid=4
insert into shoppinglist values (4, 3, 10, '2017-01-02');


-- example of purchase(tID, cID, sID, pID, date, quantity, price)

-- cid=1 only bought something on the SL, could happen in different stores.
insert into purchase values (1, 1, 1, 1, '2017-01-01', 4, 4.00);
insert into purchase values (2, 1, 1, 1, '2017-01-02', 5, 5.00);
insert into purchase values (2, 1, 2, 2, '2017-01-02', 3, 6.00);
-- cid=2 never bought something on the SL
insert into purchase values (3, 2, 1, 3, '2017-01-01', 1, 3.00);
insert into purchase values (3, 2, 1, 4, '2017-01-01', 2, 8.00);
insert into purchase values (4, 2, 2, 4, '2017-01-02', 2, 8.00);
-- cid=3 bought something on the SL, and something not on the SL in a same store
insert into purchase values (5, 3, 3, 2, '2017-01-02', 2, 2.00);
insert into purchase values (5, 3, 3, 3, '2017-01-02', 2, 4.00);
-- cid=4 bought some on the SL in a store, bought something not on the SL in another store
insert into purchase values (6, 4, 4, 3, '2017-01-02', 2, 6.00);
insert into purchase values (7, 4, 5, 4, '2017-01-02', 2, 8.00);


-- example of inventory(sID, pID, date, quantity, unit-price)

-- store had enough inventory, compare to SL
insert into inventory values (1, 1, '2017-01-01', 5, 1.00);
insert into inventory values (1, 3, '2017-01-01', 6, 3.00);
insert into inventory values (1, 4, '2017-01-01', 7, 4.00);
insert into inventory values (2, 2, '2017-01-02', 8, 2.00);
insert into inventory values (2, 4, '2017-01-02', 9, 4.00);
insert into inventory values (3, 3, '2017-01-02', 10, 3.00);
-- store did not have enough inventory, compare to SL
insert into inventory values (1, 1, '2017-01-02', 5, 1.00);
insert into inventory values (3, 2, '2017-01-02', 6, 2.00);
insert into inventory values (4, 3, '2017-01-02', 7, 3.00);
insert into inventory values (5, 4, '2017-01-02', 8, 4.00);