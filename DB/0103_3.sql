--�ݺ� ���ν���
CREATE OR REPLACE PROCEDURE EX_PROC
IS
    P_ENAME EMP.ENAME%TYPE := '�׽�Ʈ';
    P_JOB EMP.JOB%TYPE := '���';
    P_DEPTNO EMP.DEPTNO%TYPE := '20';
BEGIN
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('���� : ' || I);
        
        INSERT INTO EMP VALUES
        (EX_EMPNO_SEQ.NEXTVAL, P_ENAME || I, P_JOB, NULL, SYSDATE, P_DEPTNO);
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('���ν��� ��');
    
END EX_PROC;
/

EXEC EX_PROC;

SELECT * FROM EMP ORDER BY EMPNO DESC;

SELECT * FROM USER_PROCEDURES;
SELECT * FROM USER_SOURCE WHERE NAME LIKE '%EX_PROC%' ;


--Ŀ��
/*
��ȯ�Ǵ� �������� �������� ó���Ҷ� �����.
1.Ŀ�� ����(IS�� BEGIN ���� ���� ���� �κп� ��)
CURSOR Ŀ���̸� IS select ����;
2. Ŀ�� ����
OPEN Ŀ���̸�;
3.Ŀ���κ��� ������ �б�(LOOP END �ݺ��� ���)
FETCH Ŀ���̸� INTO ������ ���ú���
4. Ŀ���ݱ�
CLOSE Ŀ���̸�;

--Ŀ���Ӽ�
%FOUND : ���������� ���� Ŀ�� ��� SET�� ���ڵ尡 �ִٸ� ��
%NOTFOUND : ���������� ���� Ŀ�� ��� SET�� ���ڵ尡 ���� �� ��
%LOWCOUNT : Ŀ������ ���� ���ڵ�� ��ȯ
%ISOPEN : Ŀ���� ���Ȱ� ���� ������ ���� ���¸� ��
*/
CREATE OR REPLACE PROCEDURE EX_SAMPLE(E_JOB IN EMP.JOB%TYPE)
IS
    NAME EMP.ENAME%TYPE;
    CURSOR c_name IS SELECT ENAME FROM EMP WHERE JOB LIKE '%' || E_JOB || '%';      --Ŀ������
BEGIN
    OPEN c_name;        --Ŀ������
    DBMS_OUTPUT.PUT_LINE('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    LOOP
        FETCH c_name INTO NAME;          --Ŀ���κ��� ������ �б�
        EXIT WHEN c_name%NOTFOUND;        --Ŀ���� �����Ͱ� ������ �ݺ��� ����
        
        DBMS_OUTPUT.PUT_LINE(NAME || '���� ��������� ' || E_JOB || '�Դϴ�.');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Ŀ�� ó���Ǽ� : ' || c_name%ROWCOUNT);
    
    IF c_name%ISOPEN THEN
     DBMS_OUTPUT.PUT_LINE('Ŀ���� �����ֳ׿�');
        CLOSE c_name;                   --Ŀ���ݱ�
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ŀ���� �����ֳ׿�');
    END IF;
END;
/

EXEC EX_SAMPLE('�븮');