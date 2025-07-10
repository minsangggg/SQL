USE WNTRADE;

-- 집계함수

SELECT COUNT(*)
		,COUNT(고객번호)
        ,COUNT(도시)
        ,COUNT(지역)
FROM 고객;

SELECT SUM(마일리지)
,AVG(마일리지)
,MIN(마일리지)
,MAX(마일리지)
FROM 고객;

-- 서울특별시 고객에 대한 마일리지(합계,평균,최소,최대)
SELECT SUM(마일리지)
,AVG(마일리지)
,MIN(마일리지)
,MAX(마일리지)
FROM 고객
WHERE 도시='서울특별시';

-- 그룹별 집계(Group by): 컬럼값>범주로 집계

-- 고객 테이블에서 도시별 고객의 수와 해당 도시 고객들의
-- 평균 마일리지 조회하기

select 도시
,count(*) as 고객수
,avg(마일리지) as 평균마일리지
from 고객
group by 도시;

-- 담당자직위별로 묶고,
-- 같은 담당자직위에 대해 도시별로 묶어서 
-- 집계한 결과(고객수와 평균마일리지)를 보이시오.
-- 이때 담당자직위순, 도시순으로 정렬하기

select 담당자직위, 도시
,COUNT(*) AS 고객수
,AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 담당자직위,도시
ORDER BY 1,2;

-- 집계 결과에 조건부 출력

-- 고객 테이블에서 도시별로 그룹을 묶어서 고객수와
-- 평균마일리지 구하고, 이중 고객수가 10명 이상인 레코드만 추출

SELECT 도시,
COUNT(*) AS 고객수,
AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING COUNT(*)>=10;

-- WHERE: 컬렉션의 조건, 그룹바이 이전에 실행
-- HAVING: GROUP BY한 집계에 조건, 기준 미달인거 제외

SELECT 도시,SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
group by 도시
HAVING SUM(마일리지)>1000;

SELECT 제품번호, AVG(주문수량)
FROM 주문세부
GROUP BY 제품번호;

SELECT 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량>=30
GROUP BY 제품번호;

SELECT 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량>=30
GROUP BY 제품번호
HAVING AVG(주문수량)>40;

-- SQL의 실행 순서 
/*SELECT -- 5번
FROM   -- 제일 먼저실행-> 1번
WHERE  -- 2번
GROUP BY -- 3번
HAVING -- 4번
ORDER BY -- 6번
*/
SELECT 도시,
COUNT(*) AS 고객수,
AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
with rollup;

-- 고객번호가 'T'로 시작하는 고객에 대해 도시별로 묶어서
-- 고객의 마일리지 합 구하기
-- 이때 마일리지 합이 1000점 이상인 레코드만
-- 총계를 출력

SELECT 도시,SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
group by 도시
with rollup
HAVING SUM(마일리지)>=1000;

select 담당자직위,도시
,count(*) as 고객수
from 고객
where 담당자직위 LIKE '%마케팅%'
GROUP BY 담당자직위,도시
WITH ROLLUP;

/*
내부쿼리먼저 그다음 외부쿼리
*/
SELECT 도시,합계
FROM (SELECT 도시, SUM(마일리지) AS 합계
      FROM 고객
      WHERE 고객번호 LIKE 'T%'
      GROUP BY 도시 WITH ROLLUP
	)AS 그룹
    WHERE (도시 IS NULL OR 합계>=1000);


SELECT 지역
, IF (GROUPING(지역) = 1, '합계행', 지역) AS 도시명
, COUNT(*) AS 고객수
, GROUPING(지역) AS 구분
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역 WITH ROLLUP;

select group_concat(고객회사명)
from 고객;

select group_concat(distinct 고객회사명)
from 고객;

-- 성별에 따른 사원수, NULL이면 총사원수를 출력
SELECT -- 성별, 
IFNULL(성별, '총사원수') AS 성별,
COUNT(*) AS 사원수  -- group by 기준 사원수 즉, 성별에 따른 사원수세기
FROM 사원
GROUP BY 성별 WITH ROLLUP;  


SELECT 
IF(GROUPING(성별)=1, '총사원수',성별) AS 성별,
COUNT(*) AS 사원수
FROM 사원
GROUP BY 성별 WITH ROLLUP;

-- 주문년도별 주문건수
-- 주문년도별, 분기별, 전체주문건수 추가
select YEAR(주문일) AS 주문년도
, QUARTER(주문일) AS 분기
, count(*) as 주문건수 
from 주문
group by 주문년도, 분기 with rollup;

-- 주문내역에서 월별 발송지연건 

SELECT MONTH(주문일) AS 주문월
, COUNT(*) AS 발송지연건수
FROM 주문
WHERE 요청일<발송일
GROUP BY 주문월 ORDER BY 1;

-- 아이스크림 제품별 재고합
select 제품명, SUM(재고) AS 재고
from 제품
where 제품명 like '%아이스크림%'
GROUP BY 제품명;


-- 고객구분(VIP,일반)에 따른 고객수, 평균 마일리지, 총합
SELECT
CASE
	WHEN 마일리지>10000 THEN 'VIP'
    ELSE '일반'
END AS 고객구분
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균
FROM 고객
GROUP BY 고객구분 WITH ROLLUP;

SELECT
IF( 마일리지>10000, 'VIP', '일반') AS 고객구분
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균
FROM 고객
GROUP BY 고객구분 WITH ROLLUP;
