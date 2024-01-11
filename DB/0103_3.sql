--반복 프로시저
CREATE OR REPLACE PROCEDURE EX_PROC
IS
    P_ENAME EMP.ENAME%TYPE := '테스트';
    P_JOB EMP.JOB%TYPE := '사원';
    P_DEPTNO EMP.DEPTNO%TYPE := '20';
BEGIN
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('순서 : ' || I);
        
        INSERT INTO EMP VALUES
        (EX_EMPNO_SEQ.NEXTVAL, P_ENAME || I, P_JOB, NULL, SYSDATE, P_DEPTNO);
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('프로시저 끝');
    
END EX_PROC;
/

EXEC EX_PROC;

SELECT * FROM EMP ORDER BY EMPNO DESC;

SELECT * FROM USER_PROCEDURES;
SELECT * FROM USER_SOURCE WHERE NAME LIKE '%EX_PROC%' ;


--커서
/*
반환되는 수향결과가 여러행을 처리할때 사용함.
1.커서 선언(IS와 BEGIN 사이 변수 선언 부분에 함)
CURSOR 커서이름 IS select 문장;
2. 커서 오픈
OPEN 커서이름;
3.커서로부터 데이터 읽기(LOOP END 반복문 사용)
FETCH 커서이름 INTO 저장할 로컬변수
4. 커서닫기
CLOSE 커서이름;

--커서속성
%FOUND : 마지막으로 얻은 커서 결과 SET에 레코드가 있다면 참
%NOTFOUND : 마지막으로 얻은 커서 결과 SET에 레코드가 없을 때 참
%LOWCOUNT : 커서에서 얻은 레코드수 반환
%ISOPEN : 커서가 열렸고 아직 닫히지 않은 상태면 참
*/
CREATE OR REPLACE PROCEDURE EX_SAMPLE(E_JOB IN EMP.JOB%TYPE)
IS
    NAME EMP.ENAME%TYPE;
    CURSOR c_name IS SELECT ENAME FROM EMP WHERE JOB LIKE '%' || E_JOB || '%';      --커서선언
BEGIN
    OPEN c_name;        --커서오픈
    DBMS_OUTPUT.PUT_LINE('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    LOOP
        FETCH c_name INTO NAME;          --커서로부터 데이터 읽기
        EXIT WHEN c_name%NOTFOUND;        --커서에 데이터가 없을때 반복문 종료
        
        DBMS_OUTPUT.PUT_LINE(NAME || '님의 담당직급은 ' || E_JOB || '입니다.');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('커서 처리건수 : ' || c_name%ROWCOUNT);
    
    IF c_name%ISOPEN THEN
     DBMS_OUTPUT.PUT_LINE('커서가 열려있네요');
        CLOSE c_name;                   --커서닫기
    ELSE
        DBMS_OUTPUT.PUT_LINE('커서가 닫혀있네요');
    END IF;
END;
/

EXEC EX_SAMPLE('대리');