SHOW DATABASES;
USE WORLD;
SHOW TABLES;

USE WNTRADE;
SHOW TABLES;

describe 고객;
SHOW COLUMNS FROM 고객;

SELECT COUNT(*) FROM 고객;
SELECT COUNT(*) FROM 주문;


-- 셀렉션: 행단위 추출

SELECT *
FROM information_schema.tables
WHERE table_schema = 'wntrade'; 

-- 프로젝션 연산
SELECT 고객번호, 고객회사명, 담당자명
FROM 고객 
WHERE 담당자명= '이은광';

SELECT *
From 주문
WHERE 주문일 Between '2021-03-01' and '2021-05-25'; 

SELECT 고객회사명, 
담당자명 AS 이름, 
담당자직위 AS 직위,   -- AS 안써도 가능
마일리지, 
마일리지 *1.1 AS '인상된 마일리지'    
From 고객
where 마일리지 >100000;

SELECT 고객회사명, 
담당자명 AS 이름, 
담당자직위 AS 직위,   -- AS 안써도 가능
마일리지, 
마일리지 *1.1 AS '인상된 마일리지'    
From 고객
where 마일리지 >100000
ORDER BY 마일리지 DESC;     -- 마일리지 순으로 정렬, DESC는 내림차순


-- '서울특별시'에 사는 고객의 고객번호,담당자명, 도시, 마일리지 조회.단, 마일리지가 많은 고객부터 정렬
SELECT 고객번호,
담당자명,
도시,
마일리지 AS 포인트
FROM 고객
WHERE 도시='서울특별시'
ORDER BY 마일리지 DESC;


-- 고객 테이블에서 1행부터 3개의 고객 정보 조회
SELECT *
FROM 고객
LIMIT 3;

-- 마일리지가 많은 고객부터 상위 10명 고객의 모든 정보 조회
SELECT *
FROM 고객
ORDER BY 마일리지 DESC
LIMIT 10;

select distinct 도시
from 고객;

SELECT DISTINCT 지역
from 사원;

select distinct 제품번호
from 주문세부;

-- SQL에서는 대소문자 구분이 없다.
-- 키워드도 대소문자 구분 없다
-- 키워드는 대문자, 객체명은 소문자로 입력할 예정
-- 프로젝션에서 지정한 컬럼의 순서가 결과 출력의 순서이다

SELECT
23+5 AS 더하기,
23-5 AS 빼기,
23*5 AS 곱하기,
23 DIV 5 AS 정수나누기,
23/5 AS 나누기,
23%5 AS 나머지1,
23 MOD 5 AS 나머지2;

SELECT 23>=5,
23!=23,
23<>23;    -- <>: '같지 않다'

-- 담당자가 '대표이사'가 아닌 고객의 모든정보
SELECT *
FROM 고객
WHERE 담당자직위!='대표이사';

-- 주문일이 2020-03-16일 이전인 주문목록
SELECT *
FROM 주문
WHERE 주문일 <'2020-03-16';

-- 도시가 '부산광역시'이면서 마일리지가 1,000점보다 작은 고객의 모든 정보 조회
SELECT *
FROM 고객
WHERE 도시='부산광역시' AND 마일리지<1000;

-- 서울이거나 또는 마일리지가 5000이상

SELECT *
FROM 고객
WHERE 도시='서울특별시' OR 마일리지>=5000;


-- 서울이 아닌 고객
SELECT * 
FROM 고객
WHERE 도시!='서울특별시';

-- 서울이 아닌데, 마일리지가 5000이상
SELECT *
FROM 고객
WHERE 도시!='서울특별시' AND 마일리지>=5000;

-- 서울, 부산 중 마일리지가 많은 고객
SELECT *
FROM 고객
WHERE (도시='부산광역시' OR 도시= '서울특별시')
AND 마일리지>=5000;

-- 집합연산: 합집합 UNION, UNIONALL
SELECT 고객회사명, 주소, 도시
FROM 고객
WHERE 도시='부산광역시'
AND 마일리지>5000 
UNION
SELECT 고객회사명, 주소, 도시
FROM 고객
WHERE 도시= '서울특별시'
AND 마일리지> 5000
ORDER BY 1;

-- 합집합

SELECT 도시 FROM 고객
UNION         -- UNION ALL은 중복된 레코드까지 모두 다 나옴
SELECT 도시 FROM 사원;

-- 교집합 INTERSECTION
SELECT distinct 도시 FROM 고객
WHERE 도시 IN(
		SELECT distinct 도시 FROM 사원);
        
-- 차집합 EXCEPT
SELECT distinct 도시 FROM 고객
WHERE 도시 NOT IN(
		SELECT DISTINCT 도시 FROM 사원);


-- 합집합: 컬럼수와 컬럼의 데이터타입이 일치
-- 정렬: 전체쿼리 바깥에서 ORDER BY

-- IS NULL 연산자
SELECT *
FROM 고객
-- WHERE 지역= '';  --66row
WHERE 지역 IS NULL;   -- 0row

-- 상사가 없는 사원
SELECT *
FROM 고객
-- WHERE 지역= '';
WHERE 상사번호 IS NULL;



UPDATE 고객
SET 지역=NULL
WHERE 지역='';

SELECT *
FROM 고객 
WHERE 지역  IS NULL;

-- IN의 적용:여러개 중 1개만 만족해도 참

-- 담당자직위가 '영업 과장'이거나 '마케팅 과장'인 고객에 대해
-- 고객번호, 담당자명, 담당자직위를 보이시오.
SELECT 고객번호,
	   담당자명,
       담당자직위
FROM 고객
WHERE 담당자직위 IN ('영업 과장','마케팅 과장');

-- 서울, 부천, 부산에 사는 사원 조회
SELECT 이름,도시
FROM 사원
WHERE 도시 IN('서울특별시','부천시','부산광역시');

-- A1,A2부서의 사원 조회
SELECT 이름,도시,부서번호
FROM 사원
WHERE 부서번호 IN('A1','A2');

-- 마일리지가 100,000점 이상 200,000점 이하인 고객에 대해 
-- 담당자명, 마일리지를 보이시오.
SELECT 고객번호,담당자명, 마일리지
FROM 고객
WHERE 마일리지 BETWEEN 100000 AND 200000;

-- 주문이 특정 1달동안 발생한 목록
SELECT 주문번호, 고객번호, 주문일
FROM 주문
WHERE 주문일 between '2020-06-01' AND '2020-06-30';

-- 마일리지 7천대~9천대인 고객 추출
select 고객번호,담당자명,마일리지
FROM 고객
WHERE 마일리지 BETWEEN 7000 AND 9000;

-- LIKE 연산자 %_

-- 도시가 '광역시'이면서 고객번호 두번째 글자 또는 세번째 글자가
-- 'C'인 고객의 모든 정보를 보이시오.alter
SELECT *
FROM 고객
WHERE 도시 LIKE '%광역시'
AND (고객번호 LIKE '_C%' OR 고객번호 LIKE '__C%');

-- 전화번호가 45로 끝나는 고객
SELECT 고객번호, 전화번호
FROM 고객
WHERE 전화번호 LIKE '%45';

-- 전화번호 중에 45가 있는 고객
SELECT 고객번호,전화번호
FROM 고객
WHERE 전화번호 LIKE '%45%';
-- 서울에 사는 고객 중, 마일리지 15천점 이상 2만점 이하인 고객
SELECT 고객번호,도시,마일리지
FROM 고객
WHERE 도시='서울특별시' 
AND
마일리지 BETWEEN 1500 AND 20000;

-- 고객의 거주 지역, 도시를 1개씩 보이기 > 지역순, 동일지역은 도시순으로 출력
SELECT DISTINCT 지역,도시  -- DISTINCT는 무조건 셀렉이랑 붙여서
FROM 고객
ORDER BY 1,2;     

-- 춘천시, 과천시, 광명시 고객중 직위에 이사/사원이 있는 고객
SELECT 고객번호, 담당자직위,도시
FROM 고객
WHERE 도시 IN('춘천시','과천시','광명시')
AND
(담당자직위 LIKE '%이사%' OR 담당자직위 LIKE '%사원%');

-- 광역시, 특별시가 아닌 고객중 마일리지가 많은 상위 고객 3명 
SELECT *
FROM 고객
WHERE 도시 NOT LIKE '%광역시%'
AND 도시 NOT LIKE'%특별시%'
ORDER BY 마일리지 DESC
LIMIT 3;
-- 지역 값이 있는 고객, 담당자직위가 대표이사인 고객을 제외하고 출력
SELECT *
FROM 고객
WHERE 지역 IS NOT NULL
AND 지역 <> ''
AND 담당자직위 <> '%대표이사%'; 






