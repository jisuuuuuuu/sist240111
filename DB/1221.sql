INSERT INTO EMP VALUES
('1019', '������', '���', '1002', TO_DATE('2020-04-29', 'YYYY-MM-DD'),
 6900, 500, '10');

INSERT INTO EMP VALUES
('1020', '�۹α�', '���', '1002', TO_DATE('2020-06-14', 'YYYY-MM-DD'),
 8500, 900, '10');
 
INSERT INTO EMP VALUES
('1021','���ϳ�','���','1002',TO_DATE('2021-05-14', 'YYYY-MM-DD'),
 6800, 50, '10');

INSERT INTO EMP VALUES
('1022','������','���','1002',TO_DATE('2022-12-22', 'YYYY-MM-DD'),
 4500, 100, '10');

INSERT INTO EMP VALUES
('1023','������','���','1002', SYSDATE, 4500, 50, '10');

--------------------------------------------------------

INSERT INTO EMP VALUES
('1024','�����','���','1003',TO_DATE('2021-03-07', 'YYYY-MM-DD'),
 8500, 800, '20');
 
INSERT INTO EMP VALUES
('1025','������','���','1003',TO_DATE('2022-07-02', 'YYYY-MM-DD'),
 6000, 100, '20');
 
INSERT INTO EMP VALUES
('1026','�����','���','1003',TO_DATE('2021-12-10', 'YYYY-MM-DD'),
 8300, 850, '20');
 
INSERT INTO EMP VALUES
('1027','����ȣ','���','1003',TO_DATE('2022-01-23', 'YYYY-MM-DD'),
 7500, 700, '20'); 
 
 --------------------------------------------------------
 
 
INSERT INTO EMP VALUES
('1028','���Ѽ�','���','1004',TO_DATE('2022-01-30', 'YYYY-MM-DD'),
 7800, 650, '30'); 
 
INSERT INTO EMP VALUES
('1029','������','���','1004',TO_DATE('2020-02-10', 'YYYY-MM-DD'),
 8500, 900, '30');

INSERT INTO EMP VALUES
('1030','�ڿ���','���','1004',TO_DATE('2021-11-05', 'YYYY-MM-DD'),
 7000, 550, '30');

INSERT INTO EMP VALUES
('1031','����ȣ','���','1004',TO_DATE('2022-06-20', 'YYYY-MM-DD'),
 6800, 550, '30');
 
 
 --------------------------------------------------------
 
 
 
INSERT INTO EMP VALUES
('1032','������','���','1005',TO_DATE('2020-01-22', 'YYYY-MM-DD'),
 8800, 750, '40');
 
INSERT INTO EMP VALUES
('1033','������','���','1005',TO_DATE('2020-03-22', 'YYYY-MM-DD'),
 6700, 550, '40');
 
INSERT INTO EMP VALUES
('1034','�ڼ���','���','1005',TO_DATE('2021-08-20', 'YYYY-MM-DD'),
 6000, 600, '40');
 
  --------------------------------------------------------
 
 
INSERT INTO EMP VALUES
('1035','�̿�ȿ','���','1006',TO_DATE('2020-03-22', 'YYYY-MM-DD'),
 8900, 800, '50'); 
 
 
INSERT INTO EMP VALUES
('1036','�ӷ���','���','1006',TO_DATE('2020-06-21', 'YYYY-MM-DD'),
 6900, 700, '50'); 
 
INSERT INTO EMP VALUES
('1037','�ǹ̸�','���','1006',SYSDATE, 6100, 580, '50'); 

commit;

--�޿����̺� ����
CREATE TABLE SALARY(
    SALMONTH CHAR(6),
    EMPNO CHAR(4),
    SAL NUMBER(7, 2),
    COMM NUMBER(7, 2),
    CONSTRAINT PK_SALARY PRIMARY KEY(SALMONTH, EMPNO)
);


--���̺� ���� �� �ܷ�Ű(FK)����
ALTER TABLE SALARY
ADD CONSTRAINT FK_SALMONTH FOREIGN KEY (EMPNO)
REFERENCES EMP(EMPNO);

--�ܷ�Ű �̸��� �߸��Ǿ� ������ ���
ALTER TABLE SALARY DROP CONSTRAINT FK_SAKMONEY;

--EMP���̺� SAL, COMM�� SALARY ���̺�� ����
INSERT INTO SALARY 
SELECT '202312', EMPNO, SAL, COMM
  FROM EMP;
  
INSERT INTO SALARY
SELECT '202311', EMPNO, SAL-100, COMM-50
  FROM SALARY
 WHERE SALMONTH = '202312';
 
COMMIT;

--EMP���̺� SAL, COMM �÷� ����
ALTER TABLE EMP DROP COLUMN SAL;
ALTER TABLE EMP DROP COLUMN COMM;

SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'SALARY';      --USER_CONSTRAINTS
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'SALARY';

SELECT *
  FROM SALARY
 WHERE SALMONTH= TO_CHAR(SYSDATE, 'YYYYMM')
   AND EMPNO = '1001';
   
--NULL�� �ƴ� ��츸 ��ȸ
--NULL : IS NULL, NULL�� �ƴѰ� üũ : IS NOT NULL
--������� ������ ��ȸ�ϴµ� ��� ���� : [������]-[����] Ÿ��Ʋ�� '������� ����'
--����ڵ尡 �����ϴ� ��츸 ��ȸ
SELECT '[' || ENAME || ']-[' || JOB || ']' AS "������� ����"
  FROM EMP
 WHERE MGR IS NOT NULL;
 
--UPPER, LOWER, INITCAP
SELECT UPPER('manager'), LOWER('MaNager'), INITCAP('manager')
  FROM DUAL;
  
--�޿� ���̺� �޿���¥�� '202312'�� �������� ���ʽ��� ��ȸ�� 3�ڸ����� ,�� �����Ͽ� ��ȸ
SELECT COMM
      ,TO_CHAR(NVL(COMM, 0), '9,999,990')
      ,TO_CHAR(NVL(COMM, 0) + 100, '9,999,990')
      ,NVL(COMM, 0) -100
      ,TO_CHAR(NVL(COMM, 0) *3, '9,999,990')
      ,NVL(COMM, 0) / 2
  FROM SALARY
 WHERE SALMONTH = '202312';
 
--BETWEEN
--�̹��� �޿��� ���ʽ��� 300���� 800 ���� �޴� ���� ������ ��ȸ
SELECT *
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM')
 --  AND COMM BETWEEN 700 AND 800;
   AND (COMM >= 700 AND COMM <= 800);           --BETWEEN���� ���� ������ ���

--IN : ������ȣ�� 1001, 1002, 1003, 1005, 1006 ��ȸ
--EMP ���̺� �������� ��ü �÷� ��ȸ
SELECT *
  FROM EMP
 WHERE EMPNO IN ('1001', '1002', '1003', '1004', '1005', '1006');
 
--LIKE
--���������� �̸��� '��'�� ���ԵǾ� �ִ� �������� ��ȸ
SELECT *
  FROM EMP
 WHERE ENAME LIKE '%��%';
 
UPDATE EMP
   SET ENAME = '������'
 WHERE EMPNO = '1025';
 
COMMIT;

--DUAL ���̺�
SELECT SYSDATE            --��¥������ �޴� �������� ȯ�漳�� �����ͺ��̽� -> NLS���� Ȯ��
      ,TO_CHAR(SYSDATE, 'YYYY.MM.DD')          
  FROM DUAL;
  
--ROUND : �ݿø�, TRUNC : �߶�, MOD : ���� ������
SELECT ROUND(10.157, 1)
      ,TRUNC(10.157, 1)
      ,MOD(10, 3)
  FROM DUAL;
  
--���� ó�� �Լ� : LENGTH, CONCAT, SUBSTR, REPLACE
SELECT LENGTH('ABC')
      ,CONCAT('ABC', 'DEF')
      ,SUBSTR('ABCDEF', 3, 2)
      ,REPLACE('DD', 'D', 'ABCDE')
  FROM DUAL;
  
--��¥ �Լ�
SELECT SYSDATE
      ,SYSTIMESTAMP
      ,ADD_MONTHS(SYSDATE, 1)
      ,MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE)
      ,NEXT_DAY(SYSDATE, '�����')
      ,LAST_DAY(SYSDATE)
      ,ROUND(SYSDATE, 'MONTH')
      ,TRUNC(SYSDATE, 'MONTH')
  FROM DUAL;
  
--��¥ ����
SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')
      ,TO_CHAR(SYSDATE, 'YYYY/MM/DD')
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
      ,TO_CHAR(SYSDATE, 'MM/DD')
      ,TO_CHAR(SYSDATE, 'FMMM/DD')
      ,TO_CHAR(TO_DATE('20230506', 'YYYYMMDD'), 'FMMM/DD')
  FROM DUAL;
  
 --�����ڷ� ��¥ ����
SELECT TO_CHAR(SYSDATE, 'YYYY"�� "MM"�� "DD"��"')
      ,TO_CHAR(SYSDATE, 'HH24"�� "MI"��"SS"��"')
  FROM DUAL;
  
--�ð��� ����, ���� ǥ��
SELECT TO_CHAR(SYSDATE, 'AM')
      ,TO_CHAR(SYSDATE, 'AM HH:MI:SS')
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD AMHH:MI:DD')
  FROM DUAL;
  
--��ȯ�Լ�
SELECT TO_CHAR(SYSDATE, 'YYY.MM.DD')
      ,TO_NUMBER('12345')
      ,TO_DATE('20231030', 'YYYYMMDD')
  FROM DUAL;
  
--�����Լ� (COUNT, MAX, MIN, AVG, SUM) : COUNT�� ������ �����Լ��� �ݵ�� �÷����� ������.
--�޿��� 5000�����̻� 7000���� ������ ��ü ���� ���� ��ȸ
SELECT COUNT(SALMONTH)      --SELECT COUNT(*)
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM')
   AND SAL >= 5000
   AND SAL <= 7000;
   
--���� ������ ������ȣ�� ���� ū ������ȣ ��ȸ
SELECT MAX (EMPNO)
  FROM EMP;
  
--�̹��� �޿��� 5000���� 7000������ ������ �޿����� ���� ���� �ݾ��� ��ȸ
SELECT MAX (SAL)
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM')
   AND SAL BETWEEN 5000 AND 7000;
   
--���� ������ ������ȣ�� ���� ���� ������ȣ ��ȸ
SELECT MIN (EMPNO)
  FROM EMP;
  
--�̹��� �޿��� 5000���� 7000������ ������ �޿����� ���� ���� �ݾ��� ��ȸ
SELECT MIN (SAL)
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM')
   AND SAL >= 5000
   AND SAL <= 7000;
   
--�̹��� �޿��� ��ձݾװ� ��ü �޿� �հ踦 ��ȸ
SELECT AVG (SAL)
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM');
 
SELECT SUM (SAL)
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM');
 
--���� ��ȣ�� 1002 - 1006���� ��������� �޿� �հ踦 ���Ͻÿ�.(�����)
--��¿�) 4�� 328000���� ����ϰ� ���� �ۼ�.(��Ī : �����ο�, ���� �ѱݾ�)
SELECT COUNT(EMPNO) || '��' AS �����ο�, SUM(SAL) || '��' AS "���� �ѱݾ�"
  FROM SALARY
 WHERE SALMONTH = TO_CHAR(SYSDATE, 'YYYYMM')
   AND EMPNO BETWEEN 1002 AND 1006;
   
SELECT COUNT(EMPNO), MAX(SAL), MIN(SAL), AVG(SAL), SUM(SAL)
  FROM SALARY
WHERE SALMONTH = '202312'
  AND EMPNO BETWEEN 1002 AND 1006;
  
--�׷���(�����Լ�) GROUP BY
--��纰 �������� ��ȸ
SELECT MGR, COUNT(MGR)
  FROM EMP
 WHERE MGR IS NOT NULL
 GROUP BY MGR;
 
--����)������ ���� �μ��� �ο����� ��ȸ�ϴ� ���� �ۼ�
SELECT DEPTNO �μ���, COUNT(DEPTNO) �ο���
  FROM EMP
 WHERE DEPTNO IS NOT NULL
 GROUP BY DEPTNO;
 
--�ٷ� �� ������� �μ��� �ο��� 7���̻��� �μ��� ��ȸ
SELECT DEPTNO, COUNT(EMPNO)
  FROM EMP
 WHERE DEPTNO IS NOT NULL
 GROUP BY DEPTNO
 HAVING COUNT(EMPNO) >= 7;
 
--����)�������̺��� �����ں� �����ϴ� ����� ���� ��ȸ�ϴ� �����ۼ�
--��, �����ڰ� ���� ������ �����ϰ� ����������� 5���̻��� ��츸 ��ȸ�ǵ��� ��
SELECT MGR, COUNT(EMPNO)
  FROM EMP
 WHERE MGR IS NOT NULL
 GROUP BY MGR
HAVING COUNT(EMPNO) >= 5;
 
--DISTINCT �ߺ�����
SELECT DISTINCT JOB
  FROM EMP;
  
SELECT JOB, COUNT(JOB)
  FROM EMP
 GROUP BY JOB;
 
SELECT DISTINCT JOB, DEPTNO
  FROM EMP;
  
--2023�� 11���� 12�� �δް��� ������ ��� �޿��� ��ȸ
--��, �޿� ����� 7500 �̻��� ������ �����ȸ
SELECT EMPNO, AVG(SAL)
  FROM SALARY
 WHERE SALMONTH IN('202311', '202312')
 GROUP BY EMPNO
HAVING AVG(SAL) >= 7500;

--ORDER BY
SELECT *
  FROM EMP
 ORDER BY DEPTNO; -- DESC;
 
SELECT DISTINCT DEPTNO, MGR
  FROM EMP
 ORDER BY DEPTNO ASC;
 
SELECT *
  FROM EMP
 ORDER BY DEPTNO ASC, MGR DESC;
 
--�޿� ���̺��� �޿����� ���� ���ʽ��� ���� ������ ��ȸ�ϴ� ���� �ۼ�
--��, �ݾ����θ� ó���ϸ�, �ߺ��� ������(2023�� 12�� ����)
SELECT DISTINCT SAL, COMM
  FROM SALARY
 WHERE SALMONTH = '202312'
 ORDER BY SAL DESC, COMM ASC;