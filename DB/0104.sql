--커서를 이용한 문제
/*
프로시저명을 EK_JOB_EMP로 하고 실행시 직급을 매개변수(E_JOB)로 받아 처리함.
매개변수로 받은 직급에 해당하는 직원(EMP)을 모두 조회한 후 커서를 이용하여 각 모든 컬럼을
EMP_TEMP테이블에 INSERT처리
출력은 홍길동님 부서코드는 10, 상사코드는 1001, 직급은 대리입니다. 형태로 모든 데이터 출럭
      모든 처리사 끝나고 나서 결과 레코드 수 =>10건 형태로 출력
맨 마지막 처리에서 커서가 열려있을 경우만 커서 닫게 처리함
*/
CREATE TABLE EMP_TEMP (
   ENAME VARCHAR2(20),    
   DEPTNO CHAR(2),  
   MGR CHAR(4),
   JOB VARCHAR2(10)
);

TRUNCATE TABLE EMP_TEMP_3;

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE EX_JOB_EMP(E_JOB IN EMP.JOB%TYPE)
IS
    P_ENAME EMP.ENAME%TYPE;
    P_DEPTNO EMP.DEPTNO%TYPE;
    P_MGR EMP.MGR%TYPE;
    CURSOR c_plo
    IS SELECT ENAME, DEPTNO, MGR
    FROM EMP
    WHERE JOB LIKE '%' || E_JOB || '%';
BEGIN
    OPEN c_plo;
    LOOP
        FETCH c_plo INTO P_ENAME, P_DEPTNO, P_MGR;
        EXIT WHEN c_plo%NOTFOUND;
        
        INSERT INTO EMP_TEMP VALUES (P_ENAME, P_DEPTNO, P_MGR, E_JOB);
        DBMS_OUTPUT.PUT_LINE(P_ENAME || '님 부서코드는 ' || P_DEPTNO || ', 상사코드는 ' || P_MGR || ', 직급은 '|| E_JOB || '입니다.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('결과 레코드 수 =>' || C_plo%ROWCOUNT || '건');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/


EXEC EX_JOB_EMP('사원');

SELECT * FROM EMP_TEMP;

EXEC EX_JOB_EMP('사장');

EXEC EX_JOB_EMP('팀장');

EXEC EX_JOB_EMP('대리');

ROLLBACK;

CREATE TABLE EMP_TEMP_2 AS
SELECT * FROM EMP WHERE EMPNO = '9000';


CREATE OR REPLACE PROCEDURE EX_JOB_EMP_2(E_JOB IN EMP.JOB%TYPE)
IS
    DATA EMP%ROWTYPE;
    CURSOR c_plo
    IS SELECT ENAME, DEPTNO, MGR
    FROM EMP
    WHERE JOB LIKE '%' || E_JOB || '%';
BEGIN
    OPEN c_plo;
    LOOP
        FETCH c_plo INTO DATA.ENAME, DATA.DEPTNO, DATA.MGR;
        EXIT WHEN c_plo%NOTFOUND;
        
        INSERT INTO EMP_TEMP_2(ENAME, DEPTNO, MGR, JOB) VALUES (DATA.ENAME, DATA.DEPTNO, DATA.MGR, E_JOB);
        DBMS_OUTPUT.PUT_LINE(DATA.ENAME || '님 부서코드는 ' || DATA.DEPTNO || ', 상사코드는 ' || DATA.MGR || ', 직급은 '|| E_JOB || '입니다.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('결과 레코드 수 =>' || C_plo%ROWCOUNT || '건');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/
EXEC EX_JOB_EMP_2('사원');

SELECT * FROM EMP_TEMP_2;

EXEC EX_JOB_EMP_2('사장');

EXEC EX_JOB_EMP_2('팀장');

EXEC EX_JOB_EMP_2('대리');

ROLLBACK;


--강사님 답
CREATE TABLE EMP_TEMP_3 AS
SELECT * FROM EMP WHERE EMPNO = '9000';

CREATE OR REPLACE PROCEDURE EX_JOB_EMP_3--(E_JOB IN EMP.JOB%TYPE)
IS
    E_JOB EMP.JOB%TYPE := '사원';
    DATA EMP%ROWTYPE;
    CURSOR c_plo
    IS SELECT *
    FROM EMP
    WHERE JOB LIKE '%' || E_JOB || '%';
BEGIN
    OPEN c_plo;
    LOOP
        FETCH c_plo INTO DATA;
        EXIT WHEN c_plo%NOTFOUND;

        INSERT INTO EMP_TEMP_3 VALUES (DATA.EMPNO, DATA.ENAME, DATA.JOB, DATA.MGR, DATA.HIREDATE, DATA.DEPTNO);
        DBMS_OUTPUT.PUT_LINE(DATA.ENAME || '님 부서코드는 ' || DATA.DEPTNO || ', 상사코드는 ' || DATA.MGR || ', 직급은 '|| E_JOB || '입니다.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('결과 레코드 수 =>' || C_plo%ROWCOUNT || '건');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/
EXEC EX_JOB_EMP_3('사원');

SELECT * FROM EMP_TEMP_3;

EXEC EX_JOB_EMP_3('사장');

EXEC EX_JOB_EMP_3('팀장');

EXEC EX_JOB_EMP_3('대리');

ROLLBACK;

SELECT * FROM EMP_TEMP_3; 


--EMP테이블에 EMPNO가 3000번 이상인 직원을 삭제하는 프로시저 작성
--프로시저명 : EX_EMP_DEL
CREATE OR REPLACE PROCEDURE EX_EMP_DEL
IS

BEGIN
    DELETE FROM EMP WHERE EMPNO > 3000;
    
    --SQL%ROWCOUNT      --처리건수
    DBMS_OUTPUT.PUT_LINE('삭제건수 : ' || SQL%ROWCOUNT || '건 입니다.');
    
    COMMIT;
END;
/

EXEC EX_EMP_DEL;

--오라클 잡 등록
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
        JOB_NAME => 'EX_JOB',
        JOB_TYPE => 'STORED_PROCEDURE',
        JOB_ACTION => 'EX_JOB_EMP_3',
        REPEAT_INTERVAL => 'FREQ=MINUTELY;INTERVAL=1',          --1분에 1번
        COMMENTS => 'EMP_TEMP_3추가 객체'
    );
END;
/

DELETE FROM EMP_TEMP_3;
COMMIT;
SELECT * FROM EMP_TEMP_3;

--잡 객체 실행 로그 확인
SELECT * FROM USER_SCHEDULER_JOBS;
SELECT * FROM USER_SCHEDULER_JOB_LOG ORDER BY LOG_DATE DESC;
SELECT * FROM USER_SCHEDULER_JOB_RUN_DETAILS ORDER BY LOG_DATE DESC;

SELECT * FROM USER_JOBS;

--잡 실행 중지
BEGIN
    --DBMS_SCHEDULER.ENABLE('EX_JOB');        --잡 실행
    --DBMS_SCHEDULER.DISABLE('EX_JOB');     --잡 중지
    
    --잡 삭제
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'EX_JOB',
                            FORCE => FALSE);
END;
/