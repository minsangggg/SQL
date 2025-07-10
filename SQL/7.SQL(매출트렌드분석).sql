CREATE DATABASE 분석실습 DEFAULT CHARSET  utf8mb4 COLLATE  utf8mb4_general_ci;

USE 분석실습;

CREATE TABLE CUSTOMER (
    mem_no INT PRIMARY KEY,
    last_name VARCHAR(20),
    first_name VARCHAR(20),
    gd CHAR(1),
    birth_dt DATE,
    entr_dt DATE,
    grade VARCHAR(10),
    sign_up_ch CHAR(2)
);

CREATE TABLE SALES (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

SELECT * FROM customer;

SELECT * FROM sales;

-- data를 지우고 새로 넣기위해
-- 외래키 제약이 있을 수 있으므로 제약을 잠시 끔
SET FOREIGN_KEY_CHECKS = 0;

-- 순서 주의: 자식 → 부모 테이블 순서로 삭제
DELETE FROM SALES;
DELETE FROM CUSTOMER;

-- 다시 제약 복원
SET FOREIGN_KEY_CHECKS = 1;

-- 기간별 매출현황
SELECT
invoicedate
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY invoicedate
ORDER BY invoicedate;







-- 국가별 매출 현황
-- 국가별 X 제품별 매출 현황
-- 특정 제품별 매출 지표(매출액, 주문수량) 파악
-- 특정 제품의 기간별 매출 현황



