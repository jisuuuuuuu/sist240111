--Ŀ���� �̿��� ����
/*
���ν������� EK_JOB_EMP�� �ϰ� ����� ������ �Ű�����(E_JOB)�� �޾� ó����.
�Ű������� ���� ���޿� �ش��ϴ� ����(EMP)�� ��� ��ȸ�� �� Ŀ���� �̿��Ͽ� �� ��� �÷���
EMP_TEMP���̺� INSERTó��
����� ȫ�浿�� �μ��ڵ�� 10, ����ڵ�� 1001, ������ �븮�Դϴ�. ���·� ��� ������ �ⷰ
      ��� ó���� ������ ���� ��� ���ڵ� �� =>10�� ���·� ���
�� ������ ó������ Ŀ���� �������� ��츸 Ŀ�� �ݰ� ó����
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
        DBMS_OUTPUT.PUT_LINE(P_ENAME || '�� �μ��ڵ�� ' || P_DEPTNO || ', ����ڵ�� ' || P_MGR || ', ������ '|| E_JOB || '�Դϴ�.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� ���ڵ� �� =>' || C_plo%ROWCOUNT || '��');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/


EXEC EX_JOB_EMP('���');

SELECT * FROM EMP_TEMP;

EXEC EX_JOB_EMP('����');

EXEC EX_JOB_EMP('����');

EXEC EX_JOB_EMP('�븮');

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
        DBMS_OUTPUT.PUT_LINE(DATA.ENAME || '�� �μ��ڵ�� ' || DATA.DEPTNO || ', ����ڵ�� ' || DATA.MGR || ', ������ '|| E_JOB || '�Դϴ�.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� ���ڵ� �� =>' || C_plo%ROWCOUNT || '��');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/
EXEC EX_JOB_EMP_2('���');

SELECT * FROM EMP_TEMP_2;

EXEC EX_JOB_EMP_2('����');

EXEC EX_JOB_EMP_2('����');

EXEC EX_JOB_EMP_2('�븮');

ROLLBACK;


--����� ��
CREATE TABLE EMP_TEMP_3 AS
SELECT * FROM EMP WHERE EMPNO = '9000';

CREATE OR REPLACE PROCEDURE EX_JOB_EMP_3--(E_JOB IN EMP.JOB%TYPE)
IS
    E_JOB EMP.JOB%TYPE := '���';
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
        DBMS_OUTPUT.PUT_LINE(DATA.ENAME || '�� �μ��ڵ�� ' || DATA.DEPTNO || ', ����ڵ�� ' || DATA.MGR || ', ������ '|| E_JOB || '�Դϴ�.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� ���ڵ� �� =>' || C_plo%ROWCOUNT || '��');
    
    IF c_plo%ISOPEN THEN
    CLOSE c_plo;
    END IF;
END;
/
EXEC EX_JOB_EMP_3('���');

SELECT * FROM EMP_TEMP_3;

EXEC EX_JOB_EMP_3('����');

EXEC EX_JOB_EMP_3('����');

EXEC EX_JOB_EMP_3('�븮');

ROLLBACK;

SELECT * FROM EMP_TEMP_3; 


--EMP���̺� EMPNO�� 3000�� �̻��� ������ �����ϴ� ���ν��� �ۼ�
--���ν����� : EX_EMP_DEL
CREATE OR REPLACE PROCEDURE EX_EMP_DEL
IS

BEGIN
    DELETE FROM EMP WHERE EMPNO > 3000;
    
    --SQL%ROWCOUNT      --ó���Ǽ�
    DBMS_OUTPUT.PUT_LINE('�����Ǽ� : ' || SQL%ROWCOUNT || '�� �Դϴ�.');
    
    COMMIT;
END;
/

EXEC EX_EMP_DEL;

--����Ŭ �� ���
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
        JOB_NAME => 'EX_JOB',
        JOB_TYPE => 'STORED_PROCEDURE',
        JOB_ACTION => 'EX_JOB_EMP_3',
        REPEAT_INTERVAL => 'FREQ=MINUTELY;INTERVAL=1',          --1�п� 1��
        COMMENTS => 'EMP_TEMP_3�߰� ��ü'
    );
END;
/

DELETE FROM EMP_TEMP_3;
COMMIT;
SELECT * FROM EMP_TEMP_3;

--�� ��ü ���� �α� Ȯ��
SELECT * FROM USER_SCHEDULER_JOBS;
SELECT * FROM USER_SCHEDULER_JOB_LOG ORDER BY LOG_DATE DESC;
SELECT * FROM USER_SCHEDULER_JOB_RUN_DETAILS ORDER BY LOG_DATE DESC;

SELECT * FROM USER_JOBS;

--�� ���� ����
BEGIN
    --DBMS_SCHEDULER.ENABLE('EX_JOB');        --�� ����
    --DBMS_SCHEDULER.DISABLE('EX_JOB');     --�� ����
    
    --�� ����
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'EX_JOB',
                            FORCE => FALSE);
END;
/