USE WNTRADE;
# DML
# SELECT INSERT UPDATE DELETE 

#부서 테이블에 부서번호 'A5'부서명 '마케팅부'
# 레코드를 삽입
SELECT * FROM 부서;

INSERT INTO 부서
VALUES('A5','마케팅부');

SELECT * FROM 부서;


#제품번호:91, 제품명,연어피클소스, 단가:5000,재고:40
SELECT * FROM 제품;

INSERT INTO 제품
VALUES(91,'연어피클소스',NULL,5000,40);

SELECT * FROM 제품;

INSERT INTO 제품(제품번호,제품명,단가,재고)
VALUES(90, '연어핫소스',4000,50);

SELECT * FROM 제품;

#사원 테이블에 한 문장으로 세 명의 레코드를 추가하시오.
# 사원번호: E20, 이름: 김사과, 직위: 수습사원, 성별: 남, 입사일: 현재 날짜
# 사원번호: E21, 이름: 박바나나, 직위: 수습사원, 성별: 여, 입사일: 현재 날짜
# 사원번호: E22, 이름: 정오렌지, 직위: 수습사원, 성별: 여, 입사일: 현재 날짜

INSERT INTO 사원(사원번호,이름,직위,성별,입사일)
VALUES ('E20','김사과','수습사원','남',CURDATE())
 ,('E21','빅바나나','수습사원','여',CURDATE())
 ,('E22','정오렌지','수습사원','여',CURDATE());
 SELECT * FROM 사원;
 
DESCRIBE 사원;

SELECT * FROM 사원;
UPDATE 사원
SET 이름='김레몬'
WHERE 사원번호='E20';
SELECT * FROM 사원;

SELECT * FROM 제품 WHERE 제품번호=91;
UPDATE 제품
SET 포장단위='200ml bottles'
where 제품번호=91;
SELECT * FROM 제품 WHERE 제품번호=91;

update 제품
set 단가=단가*1.1
,재고=재고-10
where 제품번호=91;
select *from 제품 where 제품번호=91;

# DELETE

DELETE FROM 제품
WHERE 제품번호=91;

SELECT * 
FROM 사원
ORDER BY 입사일 DESC
LIMIT 3;

DELETE FROM 사원
ORDER BY 입사일 DESC
LIMIT 3;

SELECT * 
FROM 사원
WHERE 이름 IN('김레몬','박바나나','정오렌지');

#INSERT ON DUPLICATE KEY UPDATE
#레코드가 없다면 추가, 있다면 데이터를 변경

INSERT INTO 제품(제품번호,제품명,단가,재고)
VALUES(90, '연어피클핫소스',6000,50)
ON DUPLICATE KEY UPDATE
제품명='연어피클핫소스',단가=6000,재고=50;

SELECT * FROM 제품 WHERE 제품번호=91;

CREATE TABLE 고객주문요약
(
 고객번호 CHAR(5) primary KEY
 ,고객회사명 VARCHAR(50)
 ,주문건수 int
 ,최종주문일 date
 );
 
INSERT INTO 고객주문요약
SELECT 고객.고객번호,
	   고객회사명,
       COUNT(*),
       MAX(주문일)
FROM 고객, 주문
WHERE 고객.고객번호=주문.고객번호
GROUP BY 고객.고객번호,고객회사명;

SELECT * FROM 고객주문요약;

INSERT INTO 제품(제품번호,제품명,단가,재고)
VALUES(91, '연어피클핫소스',6000,50);

UPDATE 제품
SET 단가=(SELECT *
FROM (
	SELECT AVG(단가)
	FROM 제품
	WHERE 제품명 LIKE '%소스%'
	) AS t
)
WHERE 제품번호=91;

select * from 제품 where 제품명='연어피클핫소스';

# 한 번이라도 주문한 적이 있는 고객의 마일리지를
#10% 인상하시오

UPDATE 고객,
		(
        SELECT DISTINCT 고객번호
        FROM 주문
        ) AS 주문고객
SET 마일리지=마일리지*1.1
WHERE 고객.고객번호 IN(주문고객.고객번호);

SELECT *
FROM 고객
WHERE 고객번호 IN (SELECT DISTINCT 고객번호
				FROM 주문
				);
                
#마일리지등급이 'S'인 고객의 마일리지에 1000점씩 추가하기
UPDATE 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
SET 마일리지=마일리지+1000
WHERE 등급명='S';

#주문 테이블에는 존재하나 
#주문세부 테이블에는 존재하지 않는
#주문번호를 주문 테이블에서 삭제하시오.
DELETE FROM 주문
WHERE 주문번호 NOT IN(
			SELECT DISTINCT 주문번호
            FROM 주문세부
            );
            
# 주문번호 ‘H0248’에 대한 내역을 주문 테이블과 
#주문세부 테이블에서 모두 삭제하시오. 
SELECT *
FROM 주문
WHERE 주문번호='H0248';

select *
from 주문세부
where 주문번호='H0248';

#주문번호 ‘H0248’에 대한 내역을 주문 테이블과 
#주문세부 테이블에서 모두 삭제하시오.
DELETE 주문,주문세부
FROM 주문
INNER JOIN 주문세부
ON 주문.주문번호=주문세부.주문번호
WHERE 주문.주문번호='H0248';

#한 번도 주문한 적이 없는 고객의 정보를 삭제하시오
SELECT 고객.*
FROM 고객
LEFT OUTER JOIN 주문
ON 고객.고객번호=주문.고객번호
WHERE 주문.고객번호 IS NULL;

DELETE 고객
FROM 고객
LEFT JOIN 주문
ON 고객.고객번호=주문.고객번호
WHERE 주문.고객번호 IS NULL;

