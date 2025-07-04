USE WNTRADE; 

-- 문자개수를 카운트
SELECT char_length('HELLO'),
		length('HELLO'),
        char_length('안녕'),
        length('안녕');
        
-- CONCAT() 함수와 CONCAT_WS()함수를 사용하여
-- 문자열을 연결했을 때의 결과값 비교

select CONCAT('DREAMS','COME','TRUE')
		,CONCAT_WS('-','2023','01','29');
        
-- 문자열에서 지정한 길이만큼 문자열 반환 
SELECT left('SQL 완전정복',3),
		RIGHT('SQL 완전정복',4),
        SUBSTR('SQL 완전정복',2,5),
        substr('SQL 완전정복',2);
        
-- '서울시 동작구 흑석로'에서 앞/뒤 2번째 위치에 있는 공백('')을
-- 기준으로 문자열을 분리한 결과를 확인하기.

select SUBSTRING_INDEX('서울시 동작구 흑석로',' ',2)
-- 왼쪽부터 두번째 공백 이후제거	   
       ,SUBSTRING_INDEX('서울시 동작구 흑석로',' ',2);
-- 오른쪽부터 두번쨰 공백 이전 제거


-- 날짜/시간형 함수 
-- 날짜+시간 가져오기:
-- 쿼리 시작시점 NOW()
-- 함수 시작시점 SYSDATE()

SELECT NOW(),
	   SYSDATE(),
       CURDATE(),
       CURTIME();


SELECT NOW() AS NOW_1
		,SLEEP(5)
	    ,NOW() AS NOW_2
        ,SYSDATE() AS SYS_1
        ,SLEEP(5)
        ,SYSDATE() AS SYS_2;
        
        
-- 값을 구분해서 반환하는 함수

-- 기간 반환 함수        
SELECT NOW()
, DATEDIFF(NOW(), '2025-12-20') -- END,START
,TIMESTAMPDIFF(YEAR,NOW(),'2023-12-20') AS YEAR
,TIMESTAMPDIFF(MONTH,NOW(),'2025-02-02') AS MONTH
,TIMESTAMPDIFF(DAY,'2023-12-20',NOW()) AS DAY
,TIMESTAMPDIFF(WEEK,NOW(),'2025-06-20') AS WEEK;

SELECT NOW()
, LAST_DAY(NOW()) -- 이번달의 마지막 일자
, DAYOFYEAR(NOW()) -- 오늘이 올해의 몇번째 날인지
, MONTHNAME(NOW()) -- 이번 달 이름을 영문으로
, WEEKDAY(NOW()); -- 월요일이 0부터 시작

-- 태어난지 몇일 되었나?
SELECT DATEDIFF(CURDATE(),'1998-04-19') AS '태어난일수';
-- 천일 기념일
SELECT DATE_ADD('1998-04-19', interval 1000 DAY);
-- 나는 무슨요일의 아이일까?
SELECT DAYNAME('1998-04-19') AS '요일';
        
-- 형변환
SELECT CAST('1' AS unsigned)
		,CAST(2 AS CHAR(1))
        ,CONVERT('1',unsigned)
        ,CONVERT(2,CHAR(1));
        
-- 제어 함수 IF
SELECT IF(12500*450 >5000000, '초과달성','미달성');

-- IFNULL(속성,2): 널처리 >속성, 널일때 2
SELECT 이름, IFNULL(상사번호,'없음')
FROM 사원;

-- 고객테이블의 지역부분 처리
SELECT 지역
FROM 고객
WHERE 지역 IS NULL;

SELECT 고객번호, IFNULL(지역,'없음')
FROM 고객;

-- NULLIF(): 조건을 만족하면 NULL, 아니면 지정한
SELECT nullif(12*10, 120)
,nullif(12*10, 1200);

SELECT 고객번호, NULLIF(마일리지,0) AS '유효마일리지'
FROM 고객;

-- CASE
-- 주문금액이 5백만원 이상이면 '초과달성'
-- 4백만원 이상이면 '달성', 나머지는 '미달성'
-- 12500원 제품을 450개 주문했을 때 어디에 해당하는지

SELECT CASE 
WHEN 12500*450>5000000 THEN '초과달성' 
WHEN 2500*450>4000000 THEN '달성'
ELSE '미달성'
END;

-- 고객, 마일리지 1만점>VIP, 5천점>GOLD, 
-- 1천점>SILVER ,나머지 Bronze 

SELECT 
  고객번호,
  고객회사명,
  마일리지,
  CASE
    WHEN 마일리지 > 10000 THEN 'VIP'
    WHEN 마일리지 > 5000 THEN 'GOLD'
    WHEN 마일리지 > 1000 THEN 'SILVER'
    ELSE 'BRONZE'
  END AS 등급
FROM 고객;

-- 주문금액=수량*단가
-- 할인금액= 주문금액*할인율
-- 실주문금액= 주문금액-할인금액

-- 주문세부

-- 사원테이블에서 이름, 생일, 만나이, 입사일, 입사일수, 500일기념일 계산

-- 주문테이블에서 주문번호, 고객번호, 주문일, 년도, 분기, 월, 일, 요일(한글로)


