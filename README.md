# ShoppingSQL
An instantiation of the shopping database used in the course Databases and Data Modelling.

1. Some queries from the execises can be run directly. For example, the execution of "List the customers (id and name) who never bought anything that was not on their shopping list for the same date" is:

> sqlite> SELECT cID, cName FROM customer WHERE cID NOT IN <br/>
   ...> ( SELECT cID FROM purchase AS P WHERE (cID, pID, date) NOT IN  <br/>
   ...> ( SELECT cID, pID, date FROM shoppinglist ) ); <br/>
   1|c1 <br/>

2. Some queries need slight modifications. For example, we should change the product name and date in "List the shop(s) (id and name) with the largest inventory of 'Kelloggs Rice Crispies' on December 10, 2016". An sample will be:

>sqlite> SELECT s.sID, s.sName FROM store AS s, inventory AS i, product AS p WHERE s.sID=i.sID AND i.pID=p.pID  <br/>
   ...> AND i.date='2017-01-01' AND p.pName='p1' AND i.quantity IN   <br/>
   ...> ( SELECT MAX(quantity) FROM inventory WHERE date='2017-01-01' and pID=i.pID );  <br/>
1|s1   <br/>
