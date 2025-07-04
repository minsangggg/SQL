USE WNTRADE;
use my_db;
-- 관계형 데이터베이스: 관계연산-프로젝션,셀렉션,조인

-- 크로스조인(카티션프로덕트) N X M
-- 이너조인(내부조인, 이퀴조인, 동등조인)<=
-- 외부조인(LEFT,RIGHT,FULL OUTER) N
-- 셀프조인(1개의 테이블*2번 조인)

-- ansi
SELECT *
FROM A
JOIN B;

-- NON-ANSI
SELECT *
FROM A,B;

-- 크로스조인
SELECT *
FROM 부서
CROSS JOIN 사원
WHERE 이름='이소미';

SELECT *
FROM 부서,사원
WHERE 이름='이소미';

-- 고객,제품 크로스조인
SELECT *
FROM 고객,제품;

/* 내부조인
 가장 일반적인 조인방식
 두 테이블에서 조건에 만족하는 행만 연결하여 추출
 연결컬럼을 찾아서 매핑*/
 
/* SELECT *
 FROM A
 INNER JOIN B
 ON 조건 (*) */

SELECT 사원번호,직위,사원.부서번호,부서명
FROM 사원
INNER JOIN 부서
ON 사원.부서번호=부서.부서번호
WHERE 이름='이소미';

-- 주문,제품 제품명을 연결
SELECT 주문번호,주문세부.제품번호,제품명
FROM  주문세부
INNER JOIN 제품
ON 주문세부.제품번호=제품.제품번호;

/*고객 회사들이 주문한 주문건수를 주문건수가 많은 순서대로 
보이시오. 
이때 고객 회사의 정보로는 고객번호, 담당자명, 고객회사명을 
보이시오. */

SELECT 고객.고객번호,담당자명,고객회사명,
COUNT(*) AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호=주문.고객번호
GROUP BY 고객.고객번호
		 ,담당자명
		 ,고객회사명
ORDER BY COUNT(*) DESC;

SELECT 고객.고객번호, 담당자명, 고객회사명
,SUM(주문수량*단가) AS 주문금액
FROM 고객
INNER JOIN 주문
ON 고객.고객번호=주문.고객번호
INNER JOIN 주문세부
ON 주문.주문번호=주문세부.주문번호
GROUP BY 고객.고객번호,담당자명,고객회사명
ORDER BY 주문금액 DESC;

SELECT 고객번호,담당자명,마일리지,등급.*
FROM 고객
CROSS JOIN 마일리지등급 AS 등급
WHERE 담당자명='이은광';

SELECT 고객번호,고객회사명,담당자명,마일리지,마일리지등급.*
FROM 고객
INNER JOIN 마일리지등급 
ON 마일리지>=하한마일리지 AND 마일리지<=상한마일리지
WHERE 담당자명='이은광';

SELECT 고객번호,고객회사명,담당자명,마일리지,마일리지등급.*
FROM 고객
INNER JOIN 마일리지등급 
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
WHERE 담당자명='이은광';

/*외부조인: 기준테이블의 결과를 유지하면서 매핑된 컬럼을
가져오려 할때 사용 */
 
-- 부서,사원 
select 사원번호,이름,부서명
from 사원
inner join 부서
on 사원.부서번호=부서.부서번호; -- 이건 이너조인

select 사원번호,이름,부서명
from 사원
left join 부서
on 사원.부서번호=부서.부서번호;

-- 고객명, 주문번호,주문금액
SELECT
  고객.고객번호 AS 고객명,
  주문.주문번호,
  SUM(주문세부.주문수량 * 주문세부.단가) AS 주문금액
FROM 고객
JOIN 주문 ON 고객.고객번호 = 주문.고객번호
JOIN 주문세부 ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 고객.고객번호, 주문.주문번호;

-- 사원이 없는 부서
SELECT 부서.부서번호, 부서.부서명
FROM 부서
LEFT JOIN 사원
ON 부서.부서번호=사원.부서번호
WHERE 사원.사원번호 IS NULL;

-- 등급이 할당되지 않는 고객
SELECT 고객.고객번호,마일리지등급.등급명
FROM 고객
LEFT JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지   -- 등급 컬럼명/키에 맞게 수정
WHERE 등급명 IS NULL;

-- 부서가 없는 직원과, 직원이 없는 부서 모두 출력

SELECT 사원번호, 사원.부서번호, 부서.부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호 = 부서.부서번호
UNION
SELECT 사원번호, 사원.부서번호, 부서명
FROM 사원
RIGHT JOIN 부서
ON 사원.부서번호 = 부서.부서번호;

-- 셀프조인
SELECT 사원.이름,사원.직위,상사.이름
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호=상사.사원번호;

-- 외부조인+셀프조인
SELECT 사원.이름,사원.직위,상사.이름 AS 상사이름
FROM 사원 AS 상사
RIGHT OUTER JOIN 사원 
ON 사원.상사번호=상사.사원번호
ORDER BY 상사.이름;

-- 주문, 고객 FULL OUTER JOIN하기
SELECT 고객.*,주문.*
FROM 고객
LEFT JOIN 주문 ON 고객.고객번호=주문.고객번호
UNION
SELECT 고객.*,주문.*
FROM 주문
LEFT JOIN 고객 ON 주문.고객번호=고객.고객번호
WHERE 고객.고객번호 IS NULL;

-- 입사일이 빠른 선배,후배 관계 찾기
SELECT 선배.사원번호 AS 선배사번,
선배.이름 AS 선배이름,
후배.사원번호 AS 후배사번,
후배.이름 AS 후배이름
FROM 사원 AS 선배
JOIN 사원 AS 후배
ON 선배.입사일<후배.입사일
ORDER BY 선배.입사일, 후배.입사일;

-- 제품별로 주문수량합, 주문금액 합
SELECT
  주문세부.제품번호,
  제품명,
  SUM(주문수량) AS 주문수량합,
  SUM(주문수량 * 주문세부.단가) AS 주문금액합
FROM 주문세부
JOIN 제품 ON 주문세부.제품번호 = 제품.제품번호
GROUP BY 주문세부.제품번호,제품명;

-- 아이스크림 제품의 주문년도, 제품명 별 주문수량 합
select 
	year(주문.주문일) as 주문년도, 제품.제품명,
	sum(주문세부.주문수량) as 주문수량합
from 주문세부
join 제품 on 주문세부.제품번호=제품.제품번호
join 주문 on 주문세부.주문번호=주문.주문번호
where 제품.제품명 like '%아이스크림%'
group by 주문년도, 제품.제품명
order by 주문년도, 제품.제품명;

-- 주문이 한번도 안된 제품도 포함한 제품별로 주문수량합, 주문금액 합
SELECT
  제품.제품번호,
  제품.제품명,
  IFNULL(SUM(주문세부.주문수량), 0) AS 주문수량합,
  IFNULL(SUM(주문세부.주문수량 * 주문세부.단가), 0) AS 주문금액합
FROM 제품
LEFT JOIN 주문세부 ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품.제품번호, 제품.제품명
ORDER BY 제품.제품번호;

-- 고객 회사 중 마일리지 등급이 'A'인 고객의 정보  (고객번호, 담당자명, 고객회사명, 등급명, 마일리지)
SELECT
  고객.고객번호,
  고객.담당자명,
  고객.고객회사명,
  마일리지등급.등급명,
  고객.마일리지
FROM 고객
JOIN 마일리지등급
  ON 고객.마일리지 BETWEEN 마일리지등급.최소마일리지 AND 마일리지등급.최대마일리지
WHERE 마일리지등급.등급명 = 'A';

-- MY_DB 조인 연습
use my_db;
-- emp테이블에서 사원들의 이름, 급여와 급여 등급을 출력하는 SQL문 작성
SELECT 
  ENAME AS 사원이름,
  SAL AS 급여,
  CASE 
    WHEN SAL >= 3000 THEN 'A'
    WHEN SAL >= 2000 THEN 'B'
    WHEN SAL >= 1000 THEN 'C'
    ELSE 'D'
  END AS 급여등급
FROM EMP;

select * from emp;  -- 조회

-- 사원번호, 사원이름, 관리자번호, 관리자이름을 조회
SELECT 
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름,
  E.MGR AS 관리자번호,
  M.ENAME AS 관리자이름
FROM EMP E
LEFT JOIN EMP M
  ON E.MGR = M.EMPNO;

-- 모든 사원에 대해서 사원번호와 이름, 부서번호, 부서이름을 조회
SELECT 
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름,
  E.DEPTNO AS 부서번호,
  D.DNAME AS 부서이름
FROM EMP E
LEFT JOIN DEPT D
  ON E.DEPTNO = D.DEPTNO;

-- 모든 부서에 대해서 부서별로 소속 사원들의 정보를 출력
-- select * from dept;

/* FROM 테이블:

→ 결과에 반드시 포함시킬 “기준 데이터 집합”
LEFT JOIN 뒤 테이블:
→ 기준 데이터에 필요한 정보를 추가(붙임)

*/
SELECT 
  D.DEPTNO AS 부서번호,
  D.DNAME AS 부서이름,
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름,
  E.JOB AS 직무
FROM DEPT D          -- from 테이블과 A
LEFT JOIN EMP E      -- LEFT JOIN 테이블 A'는 다르게
  ON D.DEPTNO = E.DEPTNO
ORDER BY D.DEPTNO, E.EMPNO;
/* 
사례 예시
예를 들어,부서 10에 CLARK, KING, MILLER가 있을때
ORDER BY D.DEPTNO로만 정렬하면
셋 중 누가 먼저 나올지 보장되지 않는다
*/

-- 모든 사원과 모든 부서 정보를 조인 결과로 생성
SELECT 
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름,
  D.DEPTNO AS 부서번호,
  D.DNAME AS 부서이름
FROM EMP E
CROSS JOIN DEPT D;

-- 부서에 소속된 사원이 없어도 부서와 소속되지 않은 사원 출력
SELECT 
  D.DEPTNO AS 부서번호,
  D.DNAME AS 부서이름,
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름
FROM DEPT D
LEFT JOIN EMP E
  ON D.DEPTNO = E.DEPTNO

UNION

-- 사원+부서 (사원 중심, 부서 없는 사원)
SELECT 
  D.DEPTNO AS 부서번호,
  D.DNAME AS 부서이름,
  E.EMPNO AS 사원번호,
  E.ENAME AS 사원이름
FROM EMP E
LEFT JOIN DEPT D
  ON E.DEPTNO = D.DEPTNO
WHERE D.DEPTNO IS NULL;