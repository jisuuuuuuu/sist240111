SELECT E.ENPNO, E.DEPTNO, SAL, COMM -- SUM(SAL+COMM)
  FROM SALARY S, EMP E
 WHERE S.SALMONTH = '202312'
   AND E.EMPNO = S.EMPNO
   AND E.DEPTNO = 20;
-- GROUP BY E.DEPTNO;
-- HAVING (SUM(SAL+COMM)) >= 55000

UPDATE SALARY
   SET SAL = 8800
 WHERE SALMONTH = '202312'
   AND EMPNO = '1003';
   
UPDATE SALARY
   SET SAL = 6500
 WHERE SALMONTH = '202312'
   AND EMPNO = '1011';
   
UPDATE SALARY
   SET COMM = 200
 WHERE SALMONTH = '202312'
   AND EMPNO = '1025';
   
UPDATE SALARY
   SET COMM = 750
 WHERE SALMONTH = '202312'
   AND EMPNO = '1027';
   
COMMIT;

--DDL을 활용한 테이블 복사
CREATE TABLE EMP_20240102 AS
SELECT * FROM EMP;

DROP TABLE EMP_20240102;

CREATE TABLE EMP_20210102 AS
SELECT * FROM EMP WHERE EMPNO = '2004';

DROP TABLE EMP_20210102;

--테이블은 오늘 날짜로 생성하고
--데이터는 직원정보에서 상사정보만 조회하여 생성하는 DDL쿼리 작성
SELECT DISTINCT A.*
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
CREATE TABLE EMP_20240102 AS
SELECT DISTINCT A.*
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
DESC EMP_20240102;
 
SELECT * FROM EMP_20240102;
 
DROP TABLE EMP_20240102;

--테이블을 EMP_각자이니셜로 생성하고
--데이터는 직원정보테이블에서 상사정보만 조회하여 생성하는 DDL쿼리작성
--컬럼은 EMP상사정보와 부서명을 적용하여 생성함
CREATE TABLE EMP_KJS AS
SELECT DISTINCT A.*, D.DNAME
  FROM EMP A, EMP B, DEPT D
 WHERE A.EMPNO = B.MGR
   AND A.DEPTNO = D.DEPTNO;
   
DESC EMP_KJS;
 
SELECT * FROM EMP_KJS;

DROP TABLE EMP_KJS;

CREATE TABLE EMP_KJS AS
SELECT DISTINCT A.*
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;

CREATE TABLE EMP_KJS AS
SELECT DISTINCT A.*, D.DNAME
  FROM EMP A, EMP B, DEPT D
 WHERE A.EMPNO = B.MGR
   AND A.DEPTNO = D.DEPTNO(+);

TRUNCATE TABLE EMP_KJS;
DELETE FROM EMP_KJS;
COMMIT;

DESC EMP_KJS;

SELECT * FROM EMP_KJS;

INSERT INTO EMP_KJS
SELECT * FROM EMP;

SELECT * FROM EMP_KJS;
COMMIT;

--EMP테이블에 상사정보를 제외한 직원정보를 EMP_KJS테이블에 INSERT 하는 쿼리 작성
INSERT INTO EMP_KJS
SELECT *
  FROM EMP
 WHERE EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                       FROM EMP A, EMP B
                      WHERE A.EMPNO = B.MGR);
                      
COMMIT;
TRUNCATE TABLE EMP_KJS;

INSERT INTO EMP_KJS
SELECT *
  FROM EMP
MINUS
SELECT A.*
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
CREATE TABLE SALARY_SIST AS
SELECT * FROM SALARY WHERE EMPNO = '30000';

SELECT * FROM SALARY_SIST;
DESC SALARY_SIST;

INSERT INTO SALARY_SIST
SELECT '202401', EMPNO, SAL, COMM
  FROM SALARY
 WHERE SALMONTH = '202311';
 
SELECT * FROM SALARY_SIST;

UPDATE SALARY_SIST 
   SET COMM = 50;
   
ROLLBACK;
COMMIT;

--부서코드가 50번인 직원들에 대해서 기존 보너스에 50을 추가하여 적용
UPDATE SALARY_SIST
   SET COMM = COMM + 50
 WHERE EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE DEPTNO = 50);
COMMIT;

SELECT EMPNO, COMM
  FROM SALARY
 WHERE SALMONTH = '202311'
   AND EMPNO IN ('1006', '1017', '1018', '1035', '1036', '1037');
   
--1006	700
--1017	500
--1018	550
--1035	750
--1036	650
--1037	530

SELECT S1.EMPNO 직원번호, S1.COMM 원본보너스, S2.COMM 변경보너스
  FROM SALARY S1, SALARY_SIST S2
 WHERE S1.SALMONTH = '202311'
   AND S2.SALMONTH = '202401'
   AND S1.EMPNO = S2.EMPNO
   AND S1.EMPNO IN (SELECT EMPNO
                      FROM EMP
                     WHERE DEPTNO = 50);
                     
--상사를 제외한 일반사원들의 보너스를 기존보너스+150으로 하여 UPDATE쿼리작성.
--NULL인 경우도 적용함. 첫번째 WHERE 절에서는 IN으로 처리하여 쿼리작성함.
SELECT *
  FROM SALARY_SIST
 WHERE COMM IN (0, 50);
 
UPDATE SALARY_SIST
   SET COMM = NULL
 WHERE COMM  IN (0, 50);
 
COMMIT;

SELECT *
  FROM SALARY_SIST
 WHERE COMM IS NULL;

UPDATE SALARY_SIST
   SET COMM = NVL(COMM, 0) + 150
 WHERE EMPNO IN(SELECT EMPNO
                  FROM SALARY_SIST
                 WHERE SALMONTH = '202401'
                   AND EMPNO IN (SELECT EMPNO
                                   FROM EMP
                                  WHERE EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                                                        FROM EMP A, EMP B
                                                       WHERE A.EMPNO = B.MGR)));
SELECT EMPNO, NVL(COMM, 0)
  FROM SALARY_SIST
 WHERE SALMONTH = '202401'
   AND EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                                        FROM EMP A, EMP B
                                       WHERE A.EMPNO = B.MGR));
                                       
SELECT * FROM SALARY_SIST;

COMMIT;

--DELETE 서브쿼리를 이용한 DML
--팀명이 "촘무팀"인 부서에 속하는 직원 삭제
SELECT EMPNO
  FROM EMP_KJS
 WHERE DEPTNO IN (SELECT DEPTNO
                    FROM DEPT
                   WHERE DNAME = '총무팀');
                   
DELETE FROM EMP_KJS
 WHERE DEPTNO IN (SELECT DEPTNO
                    FROM DEPT
                   WHERE DNAME = '총무팀');

COMMIT;   
SELECT * FROM EMP_KJS WHERE DEPTNO = 10;

--부서명이 존재하지 않는 직원에 대한 레코드 삭제
--EMP_KJS테이블 기준(서브쿼리를 이용하여 삭제)
UPDATE EMP_KJS
   SET DEPTNO = NULL
 WHERE DEPTNO = '20';
 
COMMIT;

SELECT * FROM EMP_KJS;
                   
DELETE FROM EMP_KJS
 WHERE EMPNO IN (SELECT EMPNO
                   FROM EMP_KJS
                   WHERE DEPTNO IS NULL);
                   
DELETE FROM EMP_KJS
 WHERE EMPNO IN (SELECT EMPNO
                   FROM EMP_KJS
                  MINUS
                 SELECT EMPNO
                   FROM EMP_KJS A, DEPT B
                  WHERE A.DEPTNO = B.DEPTNO);
 
 
ROLLBACK;

DELETE FROM EMP_KJS
 WHERE EMPNO IN (SELECT EMPNO
                   FROM EMP_KJS
                  WHERE EMPNO NOT IN (SELECT EMPNO
                                        FROM EMP_KJS E, DEPT D
                                       WHERE E.DEPTNO = D.DEPTNO));
                                       
                                       
DELETE FROM EMP_KJS
 WHERE NOT EMPNO = ANY (SELECT EMPNO
                          FROM EMP_KJS E, DEPT D
                         WHERE E.DEPTNO = D.DEPTNO);

SELECT *
  FROM EMP_KJS
 WHERE DEPTNO IS NULL;
 
SELECT * FROM EMP_KJS;

--일반직원중에 급여액(SAL)이 5000미만인 직원을 삭제하는 쿼리
--삭제는 EMP_KJS테이블로하고 급여참조는 SALARY테이블 2023년 11월
TRUNCATE TABLE EMP_KJS;
SELECT * FROM EMP_KJS;

INSERT INTO EMP_KJS
SELECT * FROM EMP_KJS;
COMMIT;

DELETE FROM EMP_KJS
WHERE EMPNO IN (SELECT E.EMPNO
                  FROM EMP_KJS E, SALARY S
                 WHERE S.SALMONTH = '202311'
                   AND E.EMPNO = S.EMPNO
                   AND SAL < 5000
                   AND E.EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                                         FROM EMP A, EMP B
                                        WHERE A.EMPNO = B.MGR));
                                        
ROLLBACK;

DELETE FROM EMP_KJS
WHERE EMPNO IN (SELECT E.EMPNO
                  FROM EMP_KJS E, SALARY S
                 WHERE S.SALMONTH = '202311'
                   AND E.EMPNO = S.EMPNO
                   AND SAL < 5000
                   AND E.MGR != S.EMPNO);
                   
SELECT *
  FROM SALARY
 WHERE SALMONTH = '202311'
   AND SAL < 5000;
   
--VEIW
--일반직원(상사제외) 중 부서코드가 20번인 직원을 조회하는 VEIW 작성
--조회항목 : 직원번호, 직원명, 직급, 급여, 보너스
CREATE OR REPLACE VIEW V_EMP_DEPT20
AS (
    SELECT E.EMPNO, E.DEPTNO, E.ENAME, E.JOB, S.SAL, S.COMM
      FROM EMP E, SALARY S
     WHERE S.SALMONTH = '202312'
       AND E.DEPTNO = '20'
       AND S.EMPNO = E.EMPNO
       AND E.EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                             FROM EMP A, EMP B
                            WHERE A.EMPNO = B.MGR)
);

--VIEW 정보조회
SELECT * FROM USER_VIEWS;

SELECT *
  FROM V_EMP_DEPT20;
  
--VIEW를 이용하여 해당 팀의 팀원들의 부서명을 조회하는 쿼리 작성
--조회항목 : 직원번호, 부서코드, 부서명, 직원명
--단, 부서명을 제외한 나머지 조회항목은 VIEW를 통해서 조회함
SELECT V1.EMPNO 직원번호, V1.DEPTNO 부서코드, D.DNAME 부서명, V1.ENAME 직원명
  FROM V_EMP_DEPT20 V1, DEPT D
 WHERE V1.DEPTNO = D.DEPTNO;
 
--급여가 6500이상이면서 20230101 이전 입사자 중 상사를 제외한 팀원들만 조회하는 쿼리작성
--조회항목 : 직원번호, 직원명, 직급, 급여액, 입사일(YYYY-MM-DD)
--단, 직원정보에 관련된건 VIEW로 작성하여 쿼리작성 (VIEW명은 V_EMP_V2)
CREATE OR REPLACE VIEW V_EMP_V2
AS (
    SELECT *
      FROM EMP
     WHERE HIREDATE < TO_DATE('20230101', 'YYYYMMDD')
       AND EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                           FROM EMP A, EMP B
                          WHERE A.EMPNO = B.MGR)
);

SELECT V2.EMPNO 직원번호, V2.ENAME 직원명, V2.JOB 직급, S.SAL 급여액, TO_CHAR(V2.HIREDATE, 'YYYY-MM-DD') 입사일
  FROM V_EMP_V2 V2, SALARY S
 WHERE V2.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND SAL >= 6500;
   
SELECT ROWID, A.*
  FROM EMP A
 WHERE EMPNO = '1001';      --AAAStBAAHAAAAFvAAA
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 