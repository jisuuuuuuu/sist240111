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

--DDL�� Ȱ���� ���̺� ����
CREATE TABLE EMP_20240102 AS
SELECT * FROM EMP;

DROP TABLE EMP_20240102;

CREATE TABLE EMP_20210102 AS
SELECT * FROM EMP WHERE EMPNO = '2004';

DROP TABLE EMP_20210102;

--���̺��� ���� ��¥�� �����ϰ�
--�����ʹ� ������������ ��������� ��ȸ�Ͽ� �����ϴ� DDL���� �ۼ�
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

--���̺��� EMP_�����̴ϼȷ� �����ϰ�
--�����ʹ� �����������̺��� ��������� ��ȸ�Ͽ� �����ϴ� DDL�����ۼ�
--�÷��� EMP��������� �μ����� �����Ͽ� ������
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

--EMP���̺� ��������� ������ ���������� EMP_KJS���̺� INSERT �ϴ� ���� �ۼ�
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

--�μ��ڵ尡 50���� �����鿡 ���ؼ� ���� ���ʽ��� 50�� �߰��Ͽ� ����
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

SELECT S1.EMPNO ������ȣ, S1.COMM �������ʽ�, S2.COMM ���溸�ʽ�
  FROM SALARY S1, SALARY_SIST S2
 WHERE S1.SALMONTH = '202311'
   AND S2.SALMONTH = '202401'
   AND S1.EMPNO = S2.EMPNO
   AND S1.EMPNO IN (SELECT EMPNO
                      FROM EMP
                     WHERE DEPTNO = 50);
                     
--��縦 ������ �Ϲݻ������ ���ʽ��� �������ʽ�+150���� �Ͽ� UPDATE�����ۼ�.
--NULL�� ��쵵 ������. ù��° WHERE �������� IN���� ó���Ͽ� �����ۼ���.
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

--DELETE ���������� �̿��� DML
--������ "�ι���"�� �μ��� ���ϴ� ���� ����
SELECT EMPNO
  FROM EMP_KJS
 WHERE DEPTNO IN (SELECT DEPTNO
                    FROM DEPT
                   WHERE DNAME = '�ѹ���');
                   
DELETE FROM EMP_KJS
 WHERE DEPTNO IN (SELECT DEPTNO
                    FROM DEPT
                   WHERE DNAME = '�ѹ���');

COMMIT;   
SELECT * FROM EMP_KJS WHERE DEPTNO = 10;

--�μ����� �������� �ʴ� ������ ���� ���ڵ� ����
--EMP_KJS���̺� ����(���������� �̿��Ͽ� ����)
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

--�Ϲ������߿� �޿���(SAL)�� 5000�̸��� ������ �����ϴ� ����
--������ EMP_KJS���̺���ϰ� �޿������� SALARY���̺� 2023�� 11��
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
--�Ϲ�����(�������) �� �μ��ڵ尡 20���� ������ ��ȸ�ϴ� VEIW �ۼ�
--��ȸ�׸� : ������ȣ, ������, ����, �޿�, ���ʽ�
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

--VIEW ������ȸ
SELECT * FROM USER_VIEWS;

SELECT *
  FROM V_EMP_DEPT20;
  
--VIEW�� �̿��Ͽ� �ش� ���� �������� �μ����� ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, �μ��ڵ�, �μ���, ������
--��, �μ����� ������ ������ ��ȸ�׸��� VIEW�� ���ؼ� ��ȸ��
SELECT V1.EMPNO ������ȣ, V1.DEPTNO �μ��ڵ�, D.DNAME �μ���, V1.ENAME ������
  FROM V_EMP_DEPT20 V1, DEPT D
 WHERE V1.DEPTNO = D.DEPTNO;
 
--�޿��� 6500�̻��̸鼭 20230101 ���� �Ի��� �� ��縦 ������ �����鸸 ��ȸ�ϴ� �����ۼ�
--��ȸ�׸� : ������ȣ, ������, ����, �޿���, �Ի���(YYYY-MM-DD)
--��, ���������� ���õȰ� VIEW�� �ۼ��Ͽ� �����ۼ� (VIEW���� V_EMP_V2)
CREATE OR REPLACE VIEW V_EMP_V2
AS (
    SELECT *
      FROM EMP
     WHERE HIREDATE < TO_DATE('20230101', 'YYYYMMDD')
       AND EMPNO NOT IN (SELECT DISTINCT A.EMPNO
                           FROM EMP A, EMP B
                          WHERE A.EMPNO = B.MGR)
);

SELECT V2.EMPNO ������ȣ, V2.ENAME ������, V2.JOB ����, S.SAL �޿���, TO_CHAR(V2.HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM V_EMP_V2 V2, SALARY S
 WHERE V2.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND SAL >= 6500;
   
SELECT ROWID, A.*
  FROM EMP A
 WHERE EMPNO = '1001';      --AAAStBAAHAAAAFvAAA
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 