alter user c##sisttest identified by 1111;      --test���� ��й�ȣ ����
revoke connect, dba from c##sisttest;           --test���� ���� ����
drop user c##sisttest cascade;                  --test���� ����

--���̺� ����
CREATE TABLE EMP(
   EMPNO CHAR(4) CONSTRAINT PK_EMP PRIMARY KEY,   --������ȣ
   ENAME VARCHAR2(20),      --������
   JOB VARCHAR2(10),        --����
   MGR CHAR(4),              --����ڵ�
   HIREDATE DATE,           --�Ի���
   SAL NUMBER(7, 2),        --�޿�
   COMM NUMBER(7, 2),       --���ʽ�
   DEPTNO CHAR(2)           --�μ��ڵ�
);

COMMENT ON TABLE EMP IS '����';
COMMENT ON COLUMN EMP.EMPNO IS '������ȣ';
COMMENT ON COLUMN EMP.ENAME IS '������';
COMMENT ON COLUMN EMP.JOB IS '����';
COMMENT ON COLUMN EMP.MGR IS '����ڵ�(���������ȣ)';
COMMENT ON COLUMN EMP.HIREDATE IS '�Ի���';
COMMENT ON COLUMN EMP.SAL IS '�޿�';
COMMENT ON COLUMN EMP.COMM IS '���ʽ�';
COMMENT ON COLUMN EMP.DEPTNO IS '�μ��ڵ�';

DESC EMP;           --EMP ���̺��� ��Ű�� ���� ��ȸ
SELECT * FROM DBA_TAB_COLUMNS WHERE TABLE_NAME = 'EMP';

SELECT * FROM DBA_TAB_COMMENTS WHERE TABLE_NAME = 'EMP';

CREATE TABLE DEPT(
    DEPTNO CHAR(2) CONSTRAINT PK_DEPT PRIMARY KEY,
    DNAME VARCHAR2(20),
    LOC VARCHAR2(20)
);

COMMENT ON TABLE DEPT IS '�μ�';
COMMENT ON COLUMN DEPT.DEPTNO IS '�μ��ڵ�';
COMMENT ON COLUMN DEPT.DNAME IS '�μ���';
COMMENT ON COLUMN DEPT.LOC IS '�μ���ġ';

ALTER TABLE EMP
ADD CONSTRAINTS FK_DEPTNO FOREIGN KEY(DEPTNO)
REFERENCES DEPT(DEPTNO);                --EMP���̺� FK ����

--EMP���̺� MGR(����ڵ�)�� ���� FK ����
ALTER TABLE EMP
ADD CONSTRAINTS FK_MGR FOREIGN KEY(MGR)
REFERENCES EMP(EMPNO);

--���̺� �÷� �߰�
ALTER TABLE EMP ADD(USER_NAME VARCHAR2(10));

--���̺� Ÿ�� ����
ALTER TABLE EMP MODIFY(USER_NAME VARCHAR2(20));

--���̺� �÷��� ����
ALTER TABLE EMP RENAME COLUMN USER_NAME TO USER_F_NAME;

--�÷� ����
ALTER TABLE EMP DROP COLUMN USER_F_NAME;

--���̺� ���� DROP TABLE EMP;

--������ ���� : ALL_, DBA_, USER_ (ALL_CONSTRAINTS, ALL_CONS_COLUMNS)
SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'EMP';
SELECT * FROM ALL_CONS_COLUMNS WHERE TABLE_NAME = 'EMP';

--�μ����̺� deft ���̺� INSERT��
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES ('20', '�λ���', '���� ������');

INSERT INTO DEPT VALUES ('30', '������', '���� ������');

INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES ('40', '������', '���� ���α�');
INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES ('50', '�渮��', '���� ���Ǳ�');
COMMIT;

--EMP���̺� INSERT
INSERT INTO EMP(EMPNO, ENAME, JOB, HIREDATE, SAL, COMM, DEPTNO) VALUES 
('1001', '����ȣ', '����', TO_DATE('2020-04-29', 'YYYY-MM-DD'), 9900, 1000, NULL);

INSERT INTO EMP VALUES('1002', '�ӽ���', '����', '1001', TO_DATE('2020-06-14', 'YYYY-MM-DD'), 8500, 900, '10');

INSERT INTO EMP VALUES('1010', '�̼���', '�븮', '1002', TO_DATE('2021-05-14', 'YYYY-MM-DD'), 6800, 50, '10');

INSERT INTO EMP VALUES('1003', '������', '����', '1001', TO_DATE('2021-03-07', 'YYYY-MM-DD'), 8500, 800, '20');

INSERT INTO EMP VALUES('1011', '������', '�븮', '1003', TO_DATE('2022-07-02', 'YYYY-MM-DD'), 6000, 100, '20');

INSERT INTO EMP VALUES('1012', '������', '���', '1003', TO_DATE('2022-12-22', 'YYYY-MM-DD'), 5800, 100, '20');

INSERT INTO EMP VALUES('1004', '������', '����', '1001', TO_DATE('2021-12-10', 'YYYY-MM-DD'), 8300, 850, '30');

INSERT INTO EMP VALUES('1013', 'Ȳ����', '�븮', '1004', TO_DATE('2022-01-23', 'YYYY-MM-DD'), 7500, 700, '30');

INSERT INTO EMP VALUES('1014', '���ر�', '���', '1004', TO_DATE('2022-01-30', 'YYYY-MM-DD'), 7400, 750, '30');

INSERT INTO EMP VALUES('1005', '������', '����', '1001', TO_DATE('2020-02-10', 'YYYY-MM-DD'), 8500, 900, '40');

INSERT INTO EMP VALUES('1015', '����ȭ', '�븮', '1005', TO_DATE('2021-11-05', 'YYYY-MM-DD'), 7300, 650, '40');

INSERT INTO EMP VALUES('1016', '�忬��', '���', '1005', TO_DATE('2022-06-20', 'YYYY-MM-DD'), 6800, 550, '40');

INSERT INTO EMP VALUES('1006', '������', '����', '1001', TO_DATE('2020-01-22', 'YYYY-MM-DD'), 8800, 750, '50');

INSERT INTO EMP VALUES('1017', '�弼��', '�븮', '1006', TO_DATE('2020-03-22', 'YYYY-MM-DD'), 6700, 550, '50');

INSERT INTO EMP VALUES('1018', '�迵��', '���', '1006', TO_DATE('2021-08-20', 'YYYY-MM-DD'), 6000, 600, '50');
COMMIT;
ROLLBACK;

--UPDATE
--1. ��� ������ ���ʽ��� 10�� �߰���.
UPDATE EMP
    SET COMM = COMM + 10;
    
UPDATE EMP
    SET COMM = COMM + 10
WHERE 1 = 1;

--2. ������ȣ�� 1001�� ������ ���ʽ��� 500�� �߰��Ͽ� ������.

UPDATE EMP
    SET COMM = COMM + 500
WHERE EMPNO = '1001';

--DELETE
--TABLE ���� (PK, FK�� ������� ����)
CREATE TABLE EMP_20231220 AS 
SELECT * FROM EMP;

--1.��ü ���ڵ� ����
DELETE FROM EMP_20231220;
TRUNCATE TABLE EMP_20231220;

--2. ����ڵ尡 1001�� ������ ����(�������)
DELETE FROM EMP_20231220 WHERE MGR = 1001;

COMMIT;
ROLLBACK;
DROP TABLE EMP_20231220;

--SELECT ��ȸ
--EMP ���̺� ��ü ���ڵ��� ��ü �÷����� ��ȸ
SELECT * FROM EMP;

--EMP���̺��� ���� ��ȣ�� 1001�� ������ ���� ������ȣ, ������, ������ ��ȸ��.
SELECT EMPNO, ENAME, JOB
    FROM EMP
WHERE EMPNO = '1001';

--���� ��ȣ�� 1010�� �̻��� ���� ��ȸ
SELECT * 
  FROM EMP
 WHERE EMPNO >= '1010';
 
--���� ��ȣ�� 1010�� �̻��̸鼭 ���ʽ��� 700�̻��� ���� ��ȸ
SELECT *
  FROM EMP
 WHERE EMPNO >= '1010'
   AND COMM >= 700;
   
--���� ��ȣ�� 1010�� �̻��̰ų� ���ʽ��� 700�̻��� ���� ��ȸ
SELECT *
  FROM EMP
 WHERE EMPNO >= '1010'
    OR COMM >= 700;
    
--���� ��ȣ�� 1010�� �̻��̸鼭 ���ʽ��� 500���� �̻��� ���������� ������ȣ, ������, ������ ��ȸ��
SELECT EMPNO, ENAME, JOB
  FROM EMP
 WHERE EMPNO >= '1010'
   AND COMM >= 500;
   
--��ȸ�׸��� ������ȣ, ������, ����, �޿� + ���ʽ�, �μ��ڵ�
--����ڵ尡 '1001'�� ���� �������� ��ȸ
SELECT EMPNO, ENAME, JOB, SAL + COMM, DEPTNO
  FROM EMP
 WHERE MGR = '1001';
 
 --��ȸ�׸��� ������ȣ, ������, ����, �ѱ޿�, �μ��ڵ�
 --���� ��ȣ�� 1010�̻��� �����̸鼭 �ѱ޿��� 8000 �̻��� �������� ��ȸ
SELECT EMPNO AS ������ȣ, ENAME AS ������, JOB ����, SAL + COMM AS �ѱ޿�, DEPTNO �μ��ڵ�
  FROM EMP
 WHERE EMPNO >= '1010'
   AND (SAL + COMM) >= 8000;
   
SELECT NVL(DEPTNO, '00') AS �μ��ڵ�
  FROM EMP
 WHERE EMPNO = '1001';