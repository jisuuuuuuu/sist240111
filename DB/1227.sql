--������ ��������
--�μ��ڵ尡 30���� ������ �޿��� ���� ���� �޴� ������� �� ���� �޿��� �޴� �����
--�̸��� �޿��� ����ϴ� ���� �ۼ�(2023�� 12�� ����)
--��ȸ�׸� : ������, �޿�
SELECT MAX(S.SAL)
  FROM SALARY S, EMP E
 WHERE S.SALMONTH = '202312'
   AND E.DEPTNO = 30
   AND E.EMPNO = S.EMPNO;

SELECT E.ENAME, S.SAL
  FROM EMP E, SALARY S
 WHERE S.SALMONTH = '202312'
   AND E.EMPNO = S.EMPNO
   AND S.SAL > (SELECT MAX(A.SAL)
                   FROM SALARY A, EMP B
                  WHERE A.SALMONTH = '202312'
                    AND B.DEPTNO = 30
                    AND B.EMPNO = A.EMPNO);
                    
--���� �� ��ձ޿��� �̻��� �޴� ���忡 ���� ��ȸ�ϴ� �����ۼ�.
--��ȸ�׸� : ������ȣ, ������, �޿� (2023�� 12�� ����)
--��� �޿����� �Ҽ������� �ݿø����� ������.
SELECT SUM(SAL), COUNT(SAL)
  FROM SALARY
 WHERE SALMONTH = '202312'
   AND EMPNO IN (SELECT DISTINCT A.EMPNO
                   FROM EMP A, EMP B
                  WHERE A.EMPNO = B.MGR);
                  
SELECT A.EMPNO, S.SAL--, SUM(S.SAL), COUNT(S.SAL)
  FROM SALARY S, EMP A, EMP B
 WHERE S.SALMONTH = '202312'
   AND A.EMPNO = B.MGR
   AND S.EMPNO = A.EMPNO;

SELECT DISTINCT A.EMPNO
                   FROM EMP A, EMP B
                  WHERE A.EMPNO = B.MGR;
                  
SELECT E.EMPNO ������ȣ, E.ENAME ������, S.SAL �޿�
  FROM EMP E, SALARY S
 WHERE S.SALMONTH = '202312'
   AND E.EMPNO = S.EMPNO
   AND E.EMPNO IN (SELECT DISTINCT A.EMPNO
                    FROM EMP A, EMP B
                   WHERE A.EMPNO = B.MGR)
   AND S.SAL > (SELECT ROUND(AVG(SAL), 0)
                  FROM SALARY
                 WHERE SALMONTH = '202312'
                   AND EMPNO IN (SELECT DISTINCT A.EMPNO
                                   FROM EMP A, EMP B
                                  WHERE A.EMPNO = B.MGR));
                                  
--������ �������� (ALL������ ���)
--�μ��ڵ尡 30���� ������ �޿��� �̻����� �޴� ��� ������ ��ȸ�ϴ� ����
--��ȸ�׸� : ������, �޿� (��, ������ 2023�� 12��)
SELECT SAL
  FROM EMP E, SALARY S
 WHERE S.SALMONTH = '202312'
   AND S.EMPNO = E.EMPNO
   AND E.DEPTNO = '30';
   
SELECT ENAME, SAL
  FROM EMP E1, SALARY S1
 WHERE E1.EMPNO = S1.EMPNO
   AND S1.SALMONTH = '202312'
   AND S1.SAL > ALL(SELECT SAL
                      FROM EMP E, SALARY S
                     WHERE S.SALMONTH = '202312'
                       AND S.EMPNO = E.EMPNO
                       AND E.DEPTNO = '30');
                       
--ANY ������ ���
--������ : �μ��ڵ尡 30�� �����޿� �� ���� ���������� ���� �޿��� �޴� �������� �̸�, �޿��� ����ϴ� ���α׷�
--��ȸ�׸� : ������, �޿�, ��, 2023�� 12��
SELECT MIN(SAL)
  FROM EMP A, SALARY B
 WHERE B.SALMONTH = '202312'
   AND B.EMPNO = A.EMPNO
   AND A.DEPTNO = '30';
   
--GROUP BY, HAVING ���
SELECT MIN(SAL)
  FROM EMP A, SALARY B
 WHERE B.SALMONTH = '202312'
   AND B.EMPNO = A.EMPNO
 GROUP BY DEPTNO
 HAVING DEPTNO = '30';
 
SELECT E1.ENAME, S1.SAL
  FROM EMP E1, SALARY S1
 WHERE S1.SALMONTH = '202312'
   AND E1.EMPNO = S1.EMPNO
   AND S1.SAL > (SELECT MIN(B.SAL)
                   FROM EMP A, SALARY B
                  WHERE B.SALMONTH = '202312'
                    AND B.EMPNO = A.EMPNO
                    AND A.DEPTNO = '30');
                    
--�Ǽ� ����
SELECT COUNT(*) FROM SALARY WHERE SALMONTH = '202312' AND SAL > 6800;

--������ ��������
SELECT E.ENAME, S.SAL
  FROM EMP E, SALARY S
 WHERE S.SALMONTH = '202312'
   AND S.EMPNO = E.EMPNO
   AND S.SAL > ANY(SELECT B.SAL
                     FROM EMP A, SALARY B
                    WHERE B.SALMONTH = '202312'
                      AND B.EMPNO = A.EMPNO
                      AND A.DEPTNO = '30');
                      
--EXISTS / NOT EXISTS
SELECT DISTINCT A.EMPNO          --20���� �ش��ϴ� ��� ������ȣ
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR
   AND A.DEPTNO = '20';
   
SELECT EMPNO, ENAME
  FROM EMP
 WHERE NOT EXISTS (SELECT DISTINCT A.EMPNO   
                 FROM EMP A, EMP B
                WHERE A.EMPNO = B.MGR
                  AND A.DEPTNO = '90');
                  
--�ζ��κ�
SELECT E.EMPNO, E.ENAME, E.JOB
  FROM EMP E,
       (SELECT DISTINCT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) EE
 WHERE E.EMPNO = EE.EMPNO;
 
--�ζ��κ� ���������� �̿��Ͽ�
--������ �޿��� 8500�̻��� ������������ ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, ������, ����, �޿�
--��, �ζ��κ� �������������� �����ڹ�ȣ(������ȣ)�� ��ȸ�ϰ� �ݾ�üũ�� ����
--2023�� 12�� ����
SELECT DISTINCT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����, S.SAL �޿�
  FROM EMP E,
       (SELECT A.EMPNO, S1.SAL
          FROM SALARY S1, EMP A, EMP B
         WHERE S1.SALMONTH = '202312'
           AND A.EMPNO = B.MGR
           AND A.EMPNO = S1.EMPNO
           AND S1.SAL >= 8500) S
 WHERE E.EMPNO = S.EMPNO;
 
 --���� ����� �����ϰ� �����ϵ� �ζ��κ信�� ��ȸ�׸��� �����ڹ�ȣ�� �� ��� �����ۼ�
SELECT DISTINCT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����, S.SAL �޿�
  FROM EMP E, SALARY S,
       (SELECT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) M
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.EMPNO = M.EMPNO
   AND S.SAL >= 8500;
   
--������
SELECT EMPNO, ENAME
  FROM EMP
  
MINUS

SELECT DISTINCT A.EMPNO, A.ENAME
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
--�Ի�����  2021�� 1�� 1�� ���� �Ի��� �� ������ ������ �����鸸 ��ȸ�ϴ� ����
--��ȸ�׸� : ������ȣ, ������, ����, �Ի���(YYYY-MM-DD)
SELECT EMPNO ������ȣ, ENAME ������, JOB ����, TO_CHAR(HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM EMP
 WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
 
 MINUS
 
SELECT DISTINCT A.EMPNO, A.ENAME, A.JOB, TO_CHAR(A.HIREDATE, 'YYYY-MM-DD')
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
--������� ������ �ζ��κ�� ����ϴ� ���� �ۼ�(��, �ζ��κ信���� ������ȣ�� ��ȸ��)
SELECT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM EMP E,
       (SELECT EMPNO
          FROM EMP
         WHERE JOB = '���'
            OR JOB = '����') EE
 WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
   AND E.EMPNO = EE.EMPNO;
   
SELECT E1.EMPNO ������ȣ, E1.ENAME ������, E1.JOB ����, TO_CHAR(E1.HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM EMP E1,
      (SELECT EMPNO
         FROM EMP
         WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
 
         MINUS
         
        SELECT DISTINCT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) E2
 WHERE E1.EMPNO = E2.EMPNO;
 
--�޿����� 6500 �̻��̸鼭 20230101 ���� �Ի�� �� ������ ������ �����鸸 ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, ������, ����, �޿�. �Ի���(YYYY-MM-DD)
--��, MINUS������ �̿�
SELECT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����, S.SAL �޿�, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM EMP E, SALARY S
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND S.SAL > 6500
   AND E.HIREDATE < TO_DATE('20230101', 'YYYYMMDD')
   
MINUS

SELECT DISTINCT A.EMPNO, A.ENAME, A.JOB, S1.SAL, TO_CHAR(A.HIREDATE, 'YYYY-MM-DD')
  FROM EMP A, EMP B, SALARY S1
 WHERE A.EMPNO = B.MGR
   AND A.EMPNO = S1.EMPNO
   AND S1.SALMONTH = '202312';
   
--�� ����� �����ϰ� �ۼ��ϸ�, �� SQL���� �ζ��κ�� ó����.
--�ζ��κ� ��ȸ�׸��� �޿��� ������ ������ �׸� ����.
SELECT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����, S.SAL �޿�, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') �Ի���
  FROM SALARY S,
       (SELECT EMPNO, ENAME, JOB, HIREDATE
          FROM EMP
         WHERE HIREDATE < TO_DATE('20230101', 'YYYYMMDD')
         MINUS
        SELECT DISTINCT A.EMPNO, A.ENAME, A.JOB, A.HIREDATE
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) E
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND S.SAL > 6500;
   
--�������� �� 2021�� 3�� 1�� ���� 2022�� 2�� 28�� ���̿� �Ի��� ���� �� 2023�� 12�� �޿��� ��պ��� �۰�
--���ʽ��� ��պ��� ���� ������ ���� ������ ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, ������, �޿�, ���ʽ�
--��, �޿��� ��հ� ���ʽ� ��տ� ���� ���������� ����ϰ� �Ҽ��� ���ϴ� �ݿø�
--   �޿��װ� ���ʽ� ��ձݾ� ��ȸ�� �Ի��Ͽ� ������� �����ۼ�
--MINUS �����ڸ� �̿��ϸ� �ζ��κ�� �ۼ��ϸ� ��ȸ�׸��� ������ȣ, �޿���, ���ʽ��� ��
SELECT E.EMPNO, E.ENAME, S.SAL, S.COMM
  FROM EMP E,
       (SELECT EMPNO, SAL, COMM
          FROM SALARY
         WHERE SALMONTH = '202312'
         MINUS 
         SELECT EMPNO, SAL, COMM
          FROM SALARY
         WHERE SALMONTH = '202312'
           AND SAL < (SELECT ROUND(AVG(SAL))
                        FROM SALARY
                       WHERE SALMONTH = '202312')
           AND COMM < (SELECT ROUND(AVG(COMM))
                         FROM SALARY
                        WHERE SALMONTH = '202312')) S
 WHERE E.EMPNO = S.EMPNO
   AND E.HIREDATE BETWEEN TO_DATE('20210301', 'YYYYMMDD') AND TO_DATE('20220228', 'YYYYMMDD');