--급여테이블 데이터 생성용
SELECT DISTINCT SALMONTH FROM SALARY;

UPDATE SALARY
   SET SALMONTH = '202202'
 WHERE SALMONTH = '202312';
COMMIT;

--프로시저 커서 사용
CREATE OR REPLACE PROCEDURE PC_CURSOR
IS
BEGIN
    DECLARE
        CURSOR cursor_Salary
        IS SELECT SALMONTH, EMPNO, SAL, COMM 
             FROM SALARY
            WHERE SALMONTH = (SELECT MAX(SALMONTH)
                                FROM SALARY);
        --변수 정의
        V_PRODUCT SALARY%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('프로시저 커서 시작..');
        OPEN cursor_Salary;
        LOOP
            FETCH cursor_Salary INTO V_PRODUCT;
            EXIT WHEN cursor_Salary%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('SALMONTH : ' || V_PRODUCT.SALMONTH);
            INSERT INTO SALARY
            VALUES (TO_CHAR(ADD_MONTHS(TO_DATE(V_PRODUCT.SALMONTH, 'YYYYMM'), 1), 'YYYYMM'),
                    V_PRODUCT.EMPNO, V_PRODUCT.SAL + 10, V_PRODUCT.COMM + 5);
        END LOOP;
        
        COMMIT;
        
        IF cursor_Salary%ISOPEN THEN
            CLOSE cursor_Salary;
        END IF;
    END;
END;
/

SELECT SALMONTH, EMPNO, SAL, COMM 
  FROM SALARY
 WHERE SALMONTH = (SELECT MAX(SALMONTH)
                     FROM SALARY);
                     
SELECT TO_CHAR(ADD_MONTHS(TO_DATE('202202', 'YYYYMM'), 1), 'YYYYMM')
  FROM DUAL;
  
EXEC PC_CURSOR;

--스케쥴러 등록 : 잡명은 EX_SALARY, 1분에 한번씩 실행
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
        JOB_NAME => 'EX_SALARY',
        JOB_TYPE => 'STORED_PROCEDURE',
        JOB_ACTION => 'PC_CURSOR',
        REPEAT_INTERVAL => 'FREQ=MINUTELY;INTERVAL=1',
        COMMENTS => '급여추가 객체'
    );
END;
/
--잡 객체 실행 로그 확인
SELECT * FROM USER_SCHEDULER_JOBS WHERE JOB_NAME = 'EX_SALARY';
SELECT * FROM USER_SCHEDULER_JOB_LOG WHERE JOB_NAME = 'EX_SALARY' ORDER BY LOG_DATE DESC;
SELECT * FROM USER_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'EX_SALARY' ORDER BY LOG_DATE DESC;

SELECT * FROM USER_JOBS;

--잡 실행 중지
BEGIN
--     DBMS_SCHEDULER.ENABLE('EX_SALARY');        --잡 실행
--     DBMS_SCHEDULER.DISABLE('EX_SALARY');     --잡 중지
     
    --잡 삭제
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'EX_SALARY',
                            FORCE => FALSE);
END;
/

SELECT MIN(SALMONTH), MAX(SALMONTH)
  FROM SALARY;
  
SELECT COUNT(*)
  FROM SALARY
 WHERE SALMONTH >= '202201'
   AND SALMONTH <= '202712';
   
--페이징 처리 안 할 경우
SELECT SALMONTH, EMPNO, SAL, COMM
  FROM (SELECT ROWNUM NUM, A.SALMONTH, A.EMPNO, A.SAL, A.COMM
          FROM (SELECT SALMONTH, EMPNO, SAL, COMM
                  FROM SALARY
                 WHERE SALMONTH >= '202201'
                   AND SALMONTH <= '202712'
                 ORDER BY SAL ASC) A)
 WHERE NUM >= 1
   AND NUM <= 10;

--일반직원(상사 제외)들의 급여중 8000만원 미만인 급여 정보를 조회하는 쿼리 작성
--조회항목 : SALMONTH, EMPNO, SAL, COMM
--단, 최종조회시 정렬방법은 SALMONTH가 가장 최근이면서 급여가 높은 순으로
--정렬하여 조회.(페이징 처리를 통해 5번행부터 10번행 자료를 조회)
SELECT SALMONTH, EMPNO, SAL, COMM
FROM (SELECT ROWNUM NUM, R.SALMONTH, R.EMPNO, R.SAL, R.COMM
        FROM (SELECT SALMONTH, EMPNO, SAL, COMM
                FROM SALARY
               WHERE SAL <= 8000
                 AND SALMONTH <= '202712'
                 AND EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                                     FROM EMP A, EMP B
                                    WHERE A.EMPNO = B.MGR)
                                    ORDER BY SALMONTH DESC, SAL DESC) R)
 WHERE NUM >= 5
   AND NUM <= 10;

/*
문제)직원정보 중 2021년 3월 1일 ~ 2023년 1월 전에 입사한 직원중 2023년 12월 급여액이 평균보다 크거나 같고
    보너스는 평균보다 크거나 같은 직원에 대한 정보를 조회하는 쿼리작성.
    조회항목 : 직원번호, 직원명, 급여액, 보너스
    단, 급여액 평균과 보너스 평균에 대한 서브쿼리를 사용하고 소수점 이하는 반올림
       급여액과 보너스 평균금액 조회 쿼리에서 다중행 서브쿼리로 이용하여 조회함.
       직원의 급여가 높고 보너스가 낮은 순으로 조회하며, 상위 5명의 정보를 조회함.
*/
SELECT EMPNO, ENAME, SAL, COMM
  FROM (SELECT ROWNUM NUM, EMPNO, ENAME, SAL, COMM
          FROM (SELECT E.EMPNO, E.ENAME, S.SAL, S.COMM
                  FROM EMP E, SALARY S
                 WHERE E.EMPNO = S.EMPNO
                   AND E.HIREDATE >= TO_DATE('20210301', 'YYYYMMDD') 
                   AND HIREDATE < TO_DATE('20230101', 'YYYYMMDD')
                   AND S.SALMONTH = '202312'
                   AND SAL >= (SELECT ROUND(AVG(SAL), 0)
                                FROM SALARY
                               WHERE SALMONTH = '202312'
                                 AND EMPNO IN (SELECT EMPNO
                                                 FROM EMP
                                                WHERE HIREDATE >= TO_DATE('20210301', 'YYYYMMDD') 
                                                  AND HIREDATE < TO_DATE('20230101', 'YYYYMMDD')))
                   AND COMM >= (SELECT ROUND(AVG(COMM), 0)
                                FROM SALARY
                               WHERE SALMONTH = '202312'
                                 AND EMPNO IN (SELECT EMPNO
                                                 FROM EMP
                                                WHERE HIREDATE >= TO_DATE('20210301', 'YYYYMMDD') 
                                                  AND HIREDATE < TO_DATE('20230101', 'YYYYMMDD')))
                 ORDER BY SAL DESC, COMM ASC))
 WHERE NUM >= 1
   AND NUM <= 5;
   
   
   
   
SELECT COUNT(*) FROM SALARY WHERE SALMONTH <= '202712';

/*
문제)입사일이 2021년 1월 1일 이휴 입사자 중 팀장을 제외한 팀원들만 조회하는 쿼리
조회항목 : 직원번호, 직원명, 직급, 입사일(YYYY.MM.DD)
단, 가장 최근입사자를 기중으로 조회하며, 최근 3명만 조회되도록 작성
*/
SELECT EMPNO, ENAME, JOB, TO_CHAR(HIREDATE, 'YYYY.MM.DD')
  FROM (SELECT ROWNUM NUM, EMPNO, ENAME, JOB, HIREDATE
          FROM (SELECT EMPNO, ENAME, JOB, HIREDATE
                  FROM EMP
                 WHERE HIREDATE >= TO_DATE('20210101', 'YYYYMMDD')
                   AND EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                                       FROM EMP A, EMP B
                                    WHERE A.EMPNO = B.MGR)
                  ORDER BY HIREDATE DESC))
WHERE NUM BETWEEN 1 AND 3;

--SQL 튜닝(힌트)
SELECT *        --0.096초, 2346건
  FROM SALARY
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';
   
SELECT * FROM USER_INDEXES;
ALTER INDEX PK_SALARY REBUILD;
ALTER INDEX EX_EMPNO REBUILD;

--오라클 힌트 사용
SELECT /*+ INDEX(S PK_SALARY) */*       --0.106, 2346건
  FROM SALARY S
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.11, 2346건
  FROM SALARY S
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';

----------------------------------------------  
SELECT *        --0.075초, 2108건 COST : 3
  FROM SALARY
 WHERE SALMONTH >= '202312';
 
SELECT /*+ INDEX(S PK_SALARY) */*       --0.067, 2108건 COST : 6
  FROM SALARY S
 WHERE SALMONTH >= '202312';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.072, 2108건 COST : 10
  FROM SALARY S
 WHERE SALMONTH >= '202312';
 
-------------------------------------------------------
SELECT *        --0.042초, 34건 COST : 3
  FROM SALARY
 WHERE SALMONTH = '202312';
 
SELECT /*+ INDEX(S PK_SALARY) */*       --0.038, 34건 COST : 6
  FROM SALARY S
 WHERE SALMONTH = '202312';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.039, 34건 COST : 10
  FROM SALARY S
 WHERE SALMONTH = '202312';
/*팀별과제
1.의류 쇼핑몰에대한 테이블 설게.
회원과 비회원에 대한 구분 필요.(서비스 등)
의류는 계절별 티셔츠만 하며 기타 세부사항은 팀별 자유로 결정함.
결재는 모두 마일리지(현금)로만 처리하는것으로 함.(마일리지 부족시 카카오페이지로 충전하는것으로 처리함.)
발표시 : 테이블에 대한 전체 취지를 설명하고 각 테이블간 관계를 설명함.
*/
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 