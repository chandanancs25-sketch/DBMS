create database Supplier;
use Supplier;
-- Week 07
/*1. Using Scheme diagram, Create tables by properly specifying the primary
keys and the foreign keys.*/
CREATE TABLE SUPPLIERS (
  sid INTEGER(5) PRIMARY KEY,
  sname VARCHAR(20),
  city VARCHAR(20)
);

CREATE TABLE PARTS (
  pid INTEGER(5) PRIMARY KEY,
  pname VARCHAR(20),
  color VARCHAR(10)
);
                                 
CREATE TABLE CATALOG (
  sid int(5),
  pid int(5),
  cost FLOAT(6),
  PRIMARY KEY (sid, pid),
  FOREIGN KEY (sid) REFERENCES SUPPLIERS(sid),
  FOREIGN KEY (pid) REFERENCES PARTS(pid)
);

-- SUPPLIERS
INSERT INTO SUPPLIERS VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO SUPPLIERS VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO SUPPLIERS VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO SUPPLIERS VALUES (10004, 'Reliance', 'Delhi');
INSERT INTO SUPPLIERS VALUES (10005, 'Mahindra', 'Mumbai');

-- PARTS
INSERT INTO PARTS VALUES (20001, 'Book', 'Red');
INSERT INTO PARTS VALUES (20002, 'Pen', 'Red');
INSERT INTO PARTS VALUES (20003, 'Pencil', 'Green');
INSERT INTO PARTS VALUES (20004, 'Mobile', 'Green');
INSERT INTO PARTS VALUES (20005, 'Charger', 'Black');

-- CATALOG
INSERT INTO CATALOG VALUES (10001, 20001, 10);
INSERT INTO CATALOG VALUES (10001, 20002, 10);
INSERT INTO CATALOG VALUES (10001, 20003, 30);
INSERT INTO CATALOG VALUES (10001, 20004, 10);
INSERT INTO CATALOG VALUES (10001, 20005, 10);
INSERT INTO CATALOG VALUES (10002, 20001, 10);
INSERT INTO CATALOG VALUES (10002, 20002, 20);
INSERT INTO CATALOG VALUES (10003, 20003, 30);
INSERT INTO CATALOG VALUES (10004, 20003, 40);

COMMIT;

select*from SUPPLIERS;

select*from PARTS;

select*from CATALOG;


-- 1. Find the pnames of parts for which there is some supplier.
SELECT DISTINCT P.pname
FROM Parts P, Catalog C
WHERE P.pid = C.pid;

-- 2.Find the snames of suppliers who supply every part.
SELECT S.sname
FROM Suppliers S
WHERE (
  SELECT COUNT(P.pid)
  FROM Parts P
) = (
  SELECT COUNT(C.pid)
  FROM Catalog C
  WHERE C.sid = S.sid
);

-- 3.Find the snames of suppliers who supply every red part.
SELECT S.sname
FROM Suppliers S
WHERE (
  SELECT COUNT(P.pid)
  FROM Parts P
  WHERE color = 'Red'
) = (
  SELECT COUNT(C.pid)
  FROM Catalog C, Parts P
  WHERE C.sid = S.sid
    AND C.pid = P.pid
    AND P.color = 'Red'
);

-- 4.Find the pnames of parts supplied by “Acme Widget” and by no one else.
SELECT P.pname
FROM Parts P, Catalog C, Suppliers S
WHERE P.pid = C.pid
  AND C.sid = S.sid
  AND S.sname = 'Acme Widget'
  AND NOT EXISTS (
    SELECT *
    FROM Catalog C1, Suppliers S1
    WHERE P.pid = C1.pid
      AND C1.sid = S1.sid
      AND S1.sname <> 'Acme Widget'
);

-- 5.Find the sids of suppliers who charge more for some part than the average cost of that part.
SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost > (
  SELECT AVG(C1.cost)
  FROM Catalog C1
  WHERE C1.pid = C.pid
);

-- 6.For each part, find the sname of the supplier who charges the most for that part.
SELECT P.pid, S.sname
FROM Parts P, Suppliers S, Catalog C
WHERE C.pid = P.pid
  AND C.sid = S.sid
  AND C.cost = (
    SELECT MAX(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid
);

-- More Queries of the Supplier Database
-- 1. Find the most expensive part overall and the supplier who supplies it.
SELECT p.pname, s.sname, c.cost
FROM CATALOG c
JOIN PARTS p ON c.pid = p.pid
JOIN SUPPLIERS s ON c.sid = s.sid
WHERE c.cost = (SELECT MAX(cost) FROM CATALOG);

-- 2. Find suppliers who do NOT supply any red parts.
SELECT s.sname
FROM SUPPLIERS s
WHERE s.sid NOT IN (
    SELECT c.sid
    FROM CATALOG c
    JOIN PARTS p ON c.pid = p.pid
    WHERE p.color = 'Red'
);

-- 3. Show each supplier and total value of all parts they supply.
SELECT s.sname, SUM(c.cost) AS total_value
FROM SUPPLIERS s
JOIN CATALOG c ON s.sid = c.sid
GROUP BY s.sname;

-- 4. Find suppliers who supply at least 2 parts cheaper than ₹20.
SELECT s.sname
FROM SUPPLIERS s
JOIN CATALOG c ON s.sid = c.sid
WHERE c.cost < 20
GROUP BY s.sname
HAVING COUNT(c.pid) >= 2;

-- 5. List suppliers who offer the cheapest cost for each part.
SELECT p.pname, s.sname, c.cost
FROM CATALOG c
JOIN SUPPLIERS s ON c.sid = s.sid
JOIN PARTS p ON c.pid = p.pid
WHERE c.cost = (
    SELECT MIN(c2.cost)
    FROM CATALOG c2
    WHERE c2.pid = c.pid
);

-- 6. Create a view showing suppliers and the total number of parts they supply.
CREATE VIEW Supplier_Part_Count AS
SELECT s.sname, COUNT(c.pid) AS total_parts
FROM SUPPLIERS s
LEFT JOIN CATALOG c ON s.sid = c.sid
GROUP BY s.sname;
SELECT * FROM Supplier_Part_Count;






