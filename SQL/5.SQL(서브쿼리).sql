USE WNTRADE;
-- SELECT 1개 데이터
-- JOIN 2개 이상 테이블
-- 서브쿼리 (내부쿼리)
/*
SELECT *
FROM 고객
INNER JOIN 주문
ON 고객번호
WHERE*/ 

/*
SELECT *
FROM 테이블
WHERE 특정컬럼=(서브쿼리)*/

/*
1. 서브쿼리가 반환하는 행의 갯수:단일행, 복수행
2. 서브쿼리의 위치에 따라: 조건절(WHERE),FROM절,SELECT절
3. 상관서브쿼리:메인쿼리와 서브쿼리 상관(컬럼)
4.반환하는 컬럼수: 단일컬럼, 다중컬럼 서브쿼리 */

SELECT 고객회사명,담당자명,마일리지 
FROM 고객
WHERE 마일리지=(
SELECT MAX(마일리지)
FROM 고객
);

SELECT A.고객회사명,A.담당자명,A.마일리지
FROM 고객 A
INNER JOIN 고객 B
ON A.마일리지<B.마일리지
WHERE B.고객번호 IS NULL;

-- 주문번호 'H0250'을 주문한 고객에 대해 고객회사명,담당자명 출력
SELECT 고객회사명,담당자명
FROM 고객
WHERE 고객번호=(SELECT 고객번호
			  FROM 주문
			  WHERE 주문번호='H0250'
			  );
/* '부산광역시'고객의 최소 마일리지보다 
 더 큰 마일리지를 가진 고객 정보를 보이시오 */
 SELECT MIN(마일리지)
FROM 고객
WHERE 도시='부산광역시';
 
 SELECT 담당자명,고객회사명,마일리지
 FROM 고객
 WHERE 마일리지 > (SELECT MIN(마일리지)
				 FROM 고객
				 WHERE 도시='부산광역시'
                 );
                 
-- 복수행 서브쿼리 ANY(최소값비교),ALL(최대값비교)
SELECT 고객번호
FROM 고객
WHERE 도시='부산광역시';

SELECT COUNT(*) AS 주문건수
FROM 주문
WHERE 고객번호 IN (SELECT 고객번호
FROM 고객
WHERE 도시='부산광역시');
                 
-- '부산광역시' 전체 고객의 마일리지보다 마일리지가 큰(7796이상)
-- 고객의 정보를 보이시오.
SELECT 담당자명,도시,고객회사명,마일리지
 FROM 고객
 WHERE 마일리지 > ALL (SELECT 마일리지
				 FROM 고객
				 WHERE 도시='부산광역시'
                 );
                 
-- 각 지역의 어느 평균 마일리지보다도 마일리지가 큰 고객의 정보를 보이시오.           
SELECT 담당자명,도시,고객회사명,마일리지
 FROM 고객
 WHERE 마일리지 > ALL (SELECT AVG(마일리지)
				 FROM 고객
				 GROUP BY 지역
                 );
-- 한 번이라도 주문한 적이 있는 고객의 정보를 보이시오.
SELECT 고객번호,고객회사명
FROM 고객
WHERE EXISTS (SELECT *
			  FROM 주문
			  WHERE 고객번호=고객.고객번호);

SELECT 고객번호,고객회사명
FROM 고객
WHERE 고객번호 IN (SELECT DISTINCT 고객번호
			  FROM 주문
			    );
        
/*
고객 전체의 평균마일리지보다 평균마일리지가 큰 도시에 대해
도시명과 도시의 평균마일리지를 보이시오.
*/
SELECT 도시, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING 평균마일리지>(SELECT AVG(마일리지)
				FROM 고객
                );
           
-- FROM 절의 서브쿼리: 인라인뷰,별명 지정필수
/*
담당자명, 고객회사명,마일리지,도시,해당 도시의 평균마일리지 보이기
그리고 고객이 위치하는 도시의 평균마일리지와 
각 고객의 마일리지 간의 차이도 함께 보이시오.
*/
SELECT 담당자명, 고객회사명,마일리지,고객.도시
,도시_평균마일리지,도시_평균마일리지-마일리지 AS차이
FROM 고객
,(SELECT 도시, AVG(마일리지) AS 도시_평균마일리지
FROM 고객
GROUP BY 도시
) AS 도시별요약
WHERE 고객.도시=도시별요약.도시;

# 사원별 상사의 이름 출력을 인라인뷰로 구성
SELECT A.이름 AS 사원명, B.이름 AS 상사명
FROM 사원 A
JOIN (SELECT 사원번호, 이름 FROM 사원) B
ON A.상사번호=B.사원번호;

# 제품별 총 주문 수량과 제고 비교를 인라인뷰로 구성
SELECT 제품명,재고,주문요약.총주문수량
  ,(제품.재고-주문요약.총주문수량) AS 잔여가능수당
FROM 제품 
JOIN (SELECT 제품번호,
	SUM(주문수량) AS 총주문수량
    FROM 주문세부
    GROUP BY 제품번호
) AS 주문요약 
ON 제품.제품번호 = 주문요약.제품번호;

#고객별 가장 최근 주문일 출력
SELECT 고객.고객번호,
MAX(주문.주문일) AS 최근주문일
FROM 고객
JOIN 주문 ON 고객.고객번호=주문.고객번호
GROUP BY 고객.고객번호
ORDER BY 최근주문일 DESC;

#고객별 가장 최근 주문일 출력 인라인뷰로
SELECT
  고객.고객번호,
  고객.고객회사명,
  최근주문.최근주문일
FROM 고객
JOIN (
    SELECT 고객번호, MAX(주문일) AS 최근주문일
    FROM 주문
    GROUP BY 고객번호
) 최근주문
  ON 고객.고객번호 = 최근주문.고객번호;
  
 -- 인라인뷰,조인: 유지보수 관점에서 조인 추천
 
 -- 스칼라 서브쿼리
 Select 고객번호,(
 select max(주문일)
 from 주문
 where 주문.고객번호=고객.고객번호
 )as 최근주문일
 from 고객;
 
 # 고객별 총 주문건수
 EXPLAIN ANALYZE
 select 고객번호,(
 select count(*)
 from 주문
 where 주문.고객번호=고객.고객번호
 )as 총주문건수
 from 고객;
 
EXPLAIN ANALYZE
SELECT 
  고객.고객번호,
  COUNT(주문.주문번호) AS 총주문건수
FROM 고객
LEFT JOIN 주문
  ON 고객.고객번호 = 주문.고객번호
GROUP BY 고객.고객번호;

# 각 제품의 마지막 주문단가
SELECT 
  제품번호,
  제품명,
  (
    SELECT 단가
    FROM 주문세부
    WHERE 주문세부.제품번호 = 제품.제품번호
    ORDER BY 주문번호 DESC
    LIMIT 1
  ) AS 마지막주문단가
FROM 제품;

# 각 사원별 최대 주문수량  
 select 사원.사원번호,사원.이름,
 (
 select MAX(주문세부.주문수량)
 from 주문
 JOIN 주문세부 ON 주문.주문번호=주문세부.주문번호
 where 주문.사원번호=사원.사원번호
 )as 최대주문수량
 from 사원;

# CTE
WITH 도시요약 AS (
SELECT 도시, AVG(마일리지) AS 도시평균마일리지,
FROM 고객
GROUP BY 도시
)
SELECT 담당자명,고객회사명,마일리지,고객.도시,
도시평균마일리지
FROM 고객
JOIN 도시요약
ON 고객.도시=도시요약.도시;

# 다중 컬럼 서브쿼리
SELECT 고객회사명, 도시, 담당자명, 마일리지
FROM 고객
WHERE (도시,마일리지) IN (
SELECT 도시, MAX(마일리지)
FROM 고객
GROUP BY 도시
);

SELECT 사원번호,이름,상사번호,
(SELECT 이름
FROM 사원 AS 상사
WHERE 상사.사원번호=사원.상사번호) AS 상사이름
FROM 사원;

# 각 도시마다 최고 마일리지를 보유한 고객 정보 추출
SELECT 도시,고객회사명,마일리지
FROM 고객
WHERE(도시,마일리지) IN (SELECT 도시,MAX(마일리지)
FROM 고객
GROUP BY 도시);
