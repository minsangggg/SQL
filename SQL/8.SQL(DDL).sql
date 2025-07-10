CREATE DATABASE WNCAMP_CLASS;
USE WNCAMP_CLASS;
CREATE TABLE 학과
(
학과번호 CHAR(2),
학과명 VARCHAR(20),
학과장명 VARCHAR(20)
);

INSERT INTO 학과
VALUES('AA','컴퓨터공학과','배경민'),
	  ('BB','소프트웨어학과','김남준'),
      ('CC','디자인융합학과','박선영');
      
SELECT * FROM 학과;

CREATE TABLE 학생
(
학번 CHAR(5),
이름 VARCHAR(20),
생일 DATE,
연락처 VARCHAR(20),
학과번호 CHAR(2)
);

INSERT INTO 학생
VALUES('S0001','이윤주','2020-01-30','01033334444','AA')
    ,('S0001','이승은','2021-02-23',NULL,'AA')
    ,('S0003','백재용','2018-03-31','01077778888','DD');
    
SELECT * FROM 학생;
   
CREATE TABLE 회원
(
 아이디 VARCHAR(20) PRIMARY KEY
,회원명 VARCHAR(20)
,키 INT
,몸무게 INT
,체질량지수 DECIMAL(4,1) AS (몸무게/POWER(키/100,2)) STORED
);

INSERT INTO 회원(아이디,회원명,키,몸무게)
VALUES('APPLE','김사과',178,70);

SELECT * FROM 회원;
   
# 수정(ALTER), 삭제
# 테이블 컬럼 추가(ADD),삭제(DROP),
# 변경(MODIFY/CHANGE),테이블이름(RENAME)

ALTER TABLE 학생 ADD 성별 CHAR(1);
DESCRIBE 학생; #성별 컬럼확인

ALTER TABLE 학생 MODIFY COLUMN 성별 VARCHAR(2);
DESCRIBE 학생;

ALTER TABLE 학생 CHANGE COLUMN 연락처 휴대폰번호 varchar(20);
DESCRIBE 학생;

ALTER TABLE 학생 DROP COLUMN 성별;
DESCRIBE 학생;

ALTER TABLE 휴학생 RENAME 졸업생;

DROP TABLE 학과;
DROP TABLE 학생;
 
#제약조건: 무결성
#primary key = not null+unique
#check,default,foreign key
    
CREATE TABLE 학과1
(
학과번호 CHAR(2) PRIMARY KEY
,학과명 VARCHAR(20) NOT NULL
,학과장명 VARCHAR(20)
);
    
CREATE TABLE 학생1
(
 학번 CHAR(5) PRIMARY KEY
,이름 VARCHAR(20) NOT NULL
,생일 DATE NOT NULL
,연락처 VARCHAR(20) UNIQUE
,학과번호 CHAR(2) REFERENCES 학과1(학과번호)
,성별 CHAR(1) CHECK(성별 IN ('남','여'))
,등록일 DATE DEFAULT(CURDATE())
,FOREIGN KEY(학과번호) REFERENCES 학과(학과번호)
);
DESCRIBE 학생1;


INSERT INTO 학과1
VALUES('AA','컴퓨터공학과','배경민');
INSERT INTO 학과1
VALUES('BB','소프트웨어학과','김남준'); 
INSERT INTO 학과1
VALUES('CC','디자인융합학과','박선영');
    
DESCRIBE 학과1;
    
INSERT INTO 학생1(학번,이름,생일,학과번호)
VALUES('S0001','이윤주','2020-01-30','AA');

INSERT INTO 학생1(학번,이름,생일,학과번호)
VALUES('S0002','이승은','2020-01-30','AA');

INSERT INTO 학생1(학번,이름,생일,학과번호)
VALUES('S0003','배재용','2018-03-31','CC');
DESCRIBE 학생1;

CREATE TABLE 과목
    (
       과목번호 CHAR(5) PRIMARY KEY
      ,과목명 VARCHAR(20) NOT NULL
      ,학점 INT NOT NULL CHECK(학점 BETWEEN 2 AND 4)
      ,구분 VARCHAR(20) CHECK(구분 IN ('전공','교양','일반'))
    );

INSERT INTO 과목(과목번호,과목명,구분,학점)
VALUES('C0001','데이터베이스실습', '전공',3);

INSERT INTO 과목(과목번호,과목명,구분,학점)
VALUES('C0002','데이터베이스 설계와 구축', '전공', 3);

INSERT INTO 과목(과목번호,과목명,구분,학점)
VALUES('C0003','데이터 분석', '전공', 3);


CREATE TABLE 수강_1
    (
       수강년도 CHAR(4) NOT NULL
      ,수강학기 VARCHAR(20) NOT NULL
                  CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
      ,학번 CHAR(5) NOT NULL
      ,과목번호 CHAR(5) NOT NULL
      ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
      ,PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)
      ,FOREIGN KEY (학번) REFERENCES 학생1(학번)
      ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
    );
    
INSERT INTO 학생(학번, 이름, 생일, 학과번호) 
VALUES ('S0001','이윤주','2020-01-30','AA');
    
    
    
INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.3);

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0002',4.4);

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0002',4.4);

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0002','C0002',4.3);


CREATE TABLE 수강_2
(
  수강번호 INT PRIMARY KEY AUTO_INCREMENT
  ,수강년도 CHAR(4) NOT NULL
  ,수강학기 VARCHAR(20) NOT NULL CHECK(수강학기 IN ('1학기', '2학기', '여름학기', '겨울학기'))
  ,학번 CHAR(5) NOT NULL
  ,과목번호 CHAR(5) NOT NULL
  ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
  ,FOREIGN KEY (학번) REFERENCES 학생1(학번)
  ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
);

INSERT INTO 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.3);

INSERT INTO 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.5);

SELECT * FROM 수강_1;
SELECT * FROM 수강_2;

DESCRIBE 학생1;

#학생 테이블의 학번 컬럼에 check 제약조건을 추가
ALTER TABLE 학생1 ADD CONSTRAINT CHECK(학번 LIKE 'S%');

#학생 테이블에 설정되어 있는 제약조건 명세 확인
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA='wncamp_class'
AND TABLE_NAME='학생1';

/*학생 테이블에 설정되어 있는 제약조건 중 연락처에 설정되어 있
는 제약조건을 삭제하시오.*/

ALTER TABLE 학생1 DROP CONSTRAINT 연락처;

alter table 학생1 drop constraint 학생1_chk_1;

alter table 학생1 drop constraint 학생1_chk_2;

alter table 학생1 ADD CHECK (학번 LIKE 'S%');

USE WNTRADE;
-- 제품 테이블의 재고 컬럼 '0보다 크거나 같아야 한다'
ALTER TABLE 제품
ADD CONSTRAINT 재고
CHECK (재고>=0);

-- 제품테이블 재고금액 컬럼 추가 '단가*재고' 자동 계산, 저장
ALTER TABLE 제품
ADD COLUMN 재고금액 INT GENERATED ALWAYS  AS (단가*재고) STORED;

-- 제품 레코드 삭제시 주문 세부 테이블의 관련 레코드도 함께 삭제되도록 주문 세부 테이블에 설정
ALTER TABLE 주문세부
ADD CONSTRAINT fk_제품번호
foreign key (제품번호)
references 제품(제품번호)
on delete cascade;

