USE WNTRADE;

CREATE OR REPLACE VIEW view_사원_여
as
SELECT 사원번호
	   ,이름
	   ,집전화 AS 전화번호
	   ,입사일
       ,주소
       ,성별
FROM 사원
WHERE 성별='여'
with check option;

SELECT * FROM VIEW_사원_여;

CREATE OR REPLACE VIEW view_제품별주문수량합
AS
SELECT 제품명
		,SUM(주문수량) AS 주문수량합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호=주문세부.제품번호
GROUP BY 제품명;

describe view_제품별주문수량합;

show create view view_제품별주문수량합;

INSERT INTO view_제품별주문수량합
VALUES('단짠 새우깡', 250);

describe view_제품별수문수량합;

INSERT INTO view_사원_여(사원번호,이름,전화번호,입사일,주소,성별)
Values('E12','황여름','(02)587-4989','2023-02-10',
'서울시 강남구 청담동 23-5','여');

INSERT INTO view_사원_여(사원번호,이름,전화번호,입사일,주소,성별)
Values('E14','박수박','(02)587-4989','2023-02-10',
'서울시 강남구 청담동 23-5','남');

SELECT *
FROM VIEW_사원_여
WHERE 사원번호='E12';

#인덱스
-- 기본인덱스(1 PK)+보조인덱스(0..N)
-- 복합인덱스: 2개 이상의 컬럼으로 구성, AND, %로 시작하면X

USE 분석실습;

SELECT * FROM 분석실습.SALES;


CREATE OR REPLACE VIEW view_sales_summary as
SELECT 
	Country,
    StockCode,
    SUM(Quantity) as total_quantity,
    sum(Quantity *unitprice) as total_sales
from sales
group by Country,StockCode;

select * from view_sales_summary 
WHERE Country='United Kingdom';

show index from sales;

CREATE INDEX  idx_customer_date
on sales (CustomerID,InvoiceDate);

explain analyze
select * from sales
where customerID=17850 
and InvoiceDate>='2010-12-01';

alter table sales drop index idx_customer_Date;

show index from sales;

explain analyze
select * from sales
where customerID LIKE '%17850' 
and InvoiceDate>='2010-12-01';

explain analyze
select * from sales
where customerID



