--�޿����̺� ������ ������
SELECT DISTINCT SALMONTH FROM SALARY;

UPDATE SALARY
   SET SALMONTH = '202202'
 WHERE SALMONTH = '202312';
COMMIT;

--���ν��� Ŀ�� ���
CREATE OR REPLACE PROCEDURE PC_CURSOR
IS
BEGIN
    DECLARE
        CURSOR cursor_Salary
        IS SELECT SALMONTH, EMPNO, SAL, COMM 
             FROM SALARY
            WHERE SALMONTH = (SELECT MAX(SALMONTH)
                                FROM SALARY);
        --���� ����
        V_PRODUCT SALARY%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('���ν��� Ŀ�� ����..');
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

--�����췯 ��� : ����� EX_SALARY, 1�п� �ѹ��� ����
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
        JOB_NAME => 'EX_SALARY',
        JOB_TYPE => 'STORED_PROCEDURE',
        JOB_ACTION => 'PC_CURSOR',
        REPEAT_INTERVAL => 'FREQ=MINUTELY;INTERVAL=1',
        COMMENTS => '�޿��߰� ��ü'
    );
END;
/
--�� ��ü ���� �α� Ȯ��
SELECT * FROM USER_SCHEDULER_JOBS WHERE JOB_NAME = 'EX_SALARY';
SELECT * FROM USER_SCHEDULER_JOB_LOG WHERE JOB_NAME = 'EX_SALARY' ORDER BY LOG_DATE DESC;
SELECT * FROM USER_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'EX_SALARY' ORDER BY LOG_DATE DESC;

SELECT * FROM USER_JOBS;

--�� ���� ����
BEGIN
--     DBMS_SCHEDULER.ENABLE('EX_SALARY');        --�� ����
--     DBMS_SCHEDULER.DISABLE('EX_SALARY');     --�� ����
     
    --�� ����
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
   
--����¡ ó�� �� �� ���
SELECT SALMONTH, EMPNO, SAL, COMM
  FROM (SELECT ROWNUM NUM, A.SALMONTH, A.EMPNO, A.SAL, A.COMM
          FROM (SELECT SALMONTH, EMPNO, SAL, COMM
                  FROM SALARY
                 WHERE SALMONTH >= '202201'
                   AND SALMONTH <= '202712'
                 ORDER BY SAL ASC) A)
 WHERE NUM >= 1
   AND NUM <= 10;

--�Ϲ�����(��� ����)���� �޿��� 8000���� �̸��� �޿� ������ ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : SALMONTH, EMPNO, SAL, COMM
--��, ������ȸ�� ���Ĺ���� SALMONTH�� ���� �ֱ��̸鼭 �޿��� ���� ������
--�����Ͽ� ��ȸ.(����¡ ó���� ���� 5������� 10���� �ڷḦ ��ȸ)
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
����)�������� �� 2021�� 3�� 1�� ~ 2023�� 1�� ���� �Ի��� ������ 2023�� 12�� �޿����� ��պ��� ũ�ų� ����
    ���ʽ��� ��պ��� ũ�ų� ���� ������ ���� ������ ��ȸ�ϴ� �����ۼ�.
    ��ȸ�׸� : ������ȣ, ������, �޿���, ���ʽ�
    ��, �޿��� ��հ� ���ʽ� ��տ� ���� ���������� ����ϰ� �Ҽ��� ���ϴ� �ݿø�
       �޿��װ� ���ʽ� ��ձݾ� ��ȸ �������� ������ ���������� �̿��Ͽ� ��ȸ��.
       ������ �޿��� ���� ���ʽ��� ���� ������ ��ȸ�ϸ�, ���� 5���� ������ ��ȸ��.
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
����)�Ի����� 2021�� 1�� 1�� ���� �Ի��� �� ������ ������ �����鸸 ��ȸ�ϴ� ����
��ȸ�׸� : ������ȣ, ������, ����, �Ի���(YYYY.MM.DD)
��, ���� �ֱ��Ի��ڸ� �������� ��ȸ�ϸ�, �ֱ� 3�� ��ȸ�ǵ��� �ۼ�
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

--SQL Ʃ��(��Ʈ)
SELECT *        --0.096��, 2346��
  FROM SALARY
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';
   
SELECT * FROM USER_INDEXES;
ALTER INDEX PK_SALARY REBUILD;
ALTER INDEX EX_EMPNO REBUILD;

--����Ŭ ��Ʈ ���
SELECT /*+ INDEX(S PK_SALARY) */*       --0.106, 2346��
  FROM SALARY S
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.11, 2346��
  FROM SALARY S
 WHERE SAL >= 5000
   AND SALMONTH <= '202712';

----------------------------------------------  
SELECT *        --0.075��, 2108�� COST : 3
  FROM SALARY
 WHERE SALMONTH >= '202312';
 
SELECT /*+ INDEX(S PK_SALARY) */*       --0.067, 2108�� COST : 6
  FROM SALARY S
 WHERE SALMONTH >= '202312';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.072, 2108�� COST : 10
  FROM SALARY S
 WHERE SALMONTH >= '202312';
 
-------------------------------------------------------
SELECT *        --0.042��, 34�� COST : 3
  FROM SALARY
 WHERE SALMONTH = '202312';
 
SELECT /*+ INDEX(S PK_SALARY) */*       --0.038, 34�� COST : 6
  FROM SALARY S
 WHERE SALMONTH = '202312';
   
SELECT /*+ INDEX(S EX_EMPNO) */*       --0.039, 34�� COST : 10
  FROM SALARY S
 WHERE SALMONTH = '202312';
/*��������
1.�Ƿ� ���θ������� ���̺� ����.
ȸ���� ��ȸ���� ���� ���� �ʿ�.(���� ��)
�Ƿ��� ������ Ƽ������ �ϸ� ��Ÿ ���λ����� ���� ������ ������.
����� ��� ���ϸ���(����)�θ� ó���ϴ°����� ��.(���ϸ��� ������ īī���������� �����ϴ°����� ó����.)
��ǥ�� : ���̺� ���� ��ü ������ �����ϰ� �� ���̺� ���踦 ������.
*/
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 