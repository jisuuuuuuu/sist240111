--������ ������ all
--��� �߾ּ� ���ʽ��� 800�̻� �޴� ��縸 ��ȸ�ϴ� �����ۼ�
--��ȸ�׸� : ������ȣ, ������, ����
SELECT E.EMPNO ������ȣ, E.ENAME ������, E.JOB ����
  FROM EMP E
 WHERE E.EMPNO IN (SELECT DISTINCT E1.EMPNO
                     FROM EMP E1, EMP E2, SALARY S1
                    WHERE E1.EMPNO = E2.MGR
                      AND E1.EMPNO = S1.EMPNO
                      AND S1.SALMONTH = '202312'
                      AND S1.COMM >= ALL(SELECT DISTINCT COMM
                                          FROM EMP A, EMP B, SALARY C
                                         WHERE A.EMPNO = B.MGR
                                           AND A.EMPNO = C.EMPNO
                                           AND C.SALMONTH = '202312'
                                           AND C.COMM >= 800));
SELECT DISTINCT COMM
  FROM EMP A, EMP B, SALARY C
 WHERE A.EMPNO = B.MGR
   AND A.EMPNO = C.EMPNO
   AND C.SALMONTH = '202312'
   AND C.COMM >= 800;
   
--�λ����� 2023�� 12�� �޿��� ������ȣ�� ��ȸ�ϴ� �����ۼ�
--��, ���������θ� �����.(WHERE �������� ��� -- FROM���� ���̺��� 1���� ���)
--�λ��� �μ������� �𸣹Ƿ� �λ��� ������ �˻�
--��ȸ�׸� : �����ȣ, �޿���
SELECT EMPNO, SAL
  FROM SALARY
 WHERE SALMONTH = '202312'
   AND EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE DEPTNO IN (SELECT DEPTNO
                                     FROM DEPT
                                    WHERE DNAME = '�λ���'));
                                    
--���� ����� �����ϸ�, �ζ��κ�� ����ϴ� ���� �ۼ�
--��, FROM���� SALARY�� ���������� ����ϵ��� �ۼ�(SALARY S, �ζ��κ�� A��)
SELECT A.EMPNO, S.SAL
  FROM SALARY S,
       (SELECT E.EMPNO
          FROM EMP E, DEPT D
         WHERE E.DEPTNO = D.DEPTNO
           AND D.DNAME = '�λ���') A
 WHERE SALMONTH = '202312'
   AND S.EMPNO = A.EMPNO;
   
--�λ����� 2023�� 12�� �ְ� �޿����� ������ȣ�� �޿��� ��ȸ�ϴ� �����ۼ�
--��, ���������θ� �����.(WHERE�� ���), �λ����� �ڵ带 �� �� ����
--��ȸ�׸� : ����, ������, �޿���
SELECT EMPNO ����, (SELECT ENAME FROM EMP WHERE EMPNO = S.EMPNO) ������, SAL �޿���
  FROM SALARY S
 WHERE SALMONTH = '202312'
   AND SAL = (SELECT MAX(SAL)
                 FROM SALARY 
                WHERE EMPNO IN (SELECT EMPNO
                                  FROM EMP
                                  WHERE DEPTNO IN (SELECT DEPTNO
                                                     FROM DEPT
                                                    WHERE DNAME = '�λ���')))
   AND EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE DEPTNO IN (SELECT DEPTNO
                                     FROM DEPT
                                    WHERE DNAME = '�λ���'));
                                    
--�μ��� 2023�� 12�� �ѱ޿�(�޿� + ���ʽ�)�� 50000�̻��� ���� ��ȸ�ϰ�, ��ȸ�� �μ��� ���ϴ�
--�������� ������ ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, �μ��ڵ�, �ѱ޿���
--��, ��ȸ�� �ѱ޿����� ���� ������ ������
SELECT E.EMPNO ������ȣ, E.DEPTNO �μ��ڵ�, (SAL+COMM) �ѱ޿���
  FROM EMP E, SALARY S
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO IN (SELECT A.DEPTNO
                      FROM SALARY B, EMP A
                     WHERE SALMONTH = '202312'
                       AND A.EMPNO = B.EMPNO
                     GROUP BY A.DEPTNO
                    HAVING (SUM(B.SAL+B.COMM)) >= 50000)
 ORDER BY (SAL+COMM) DESC;
 
SELECT E.EMPNO ������ȣ, E.DEPTNO �μ��ڵ�, (SAL+COMM) �ѱ޿���
  FROM EMP E, SALARY S,
       (SELECT A.DEPTNO, SUM(B.SAL+B.COMM)
          FROM SALARY B, EMP A
         WHERE SALMONTH = '202312'
           AND A.EMPNO = B.EMPNO
         GROUP BY A.DEPTNO
        HAVING (SUM(B.SAL+B.COMM)) >= 50000) B
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO = B.DEPTNO
 ORDER BY (SAL+COMM) DESC;
   
SELECT D.DEPTNO
  FROM DEPT D,
       (SELECT E.DEPTNO, SUM(S.SAL+S.COMM) A
                 FROM SALARY S, EMP E
                WHERE SALMONTH = '202312'
                  AND E.EMPNO = S.EMPNO
                GROUP BY E.DEPTNO) B
 WHERE D.DEPTNO = B.DEPTNO
   AND B.A > 50000;
                
SELECT SUM(S.SAL+S.COMM) A
  FROM SALARY S, EMP E
 WHERE SALMONTH = '202312'
   AND E.EMPNO = S.EMPNO
 GROUP BY E.DEPTNO;
 
--�μ��� 12�� �ѱ޿�(�޿�+���ʽ�)�� 550000 �̻��� ���� ��ȸ�ϰ�, ��ȸ�� �μ��� ���ϴ� �����߿�
--������� �ѱ޿����� ���� ������ ��ȸ�ϴ� ���� �ۼ�
--��ȸ�׸� : ������ȣ, �μ��ڵ�, �ѱ޿���
--��, ��ȸ�� �� �޿����� ���� ������ ������.
SELECT E.EMPNO ������ȣ, E.DEPTNO �μ��ڵ�, (SAL+COMM) �ѱ޿���
  FROM EMP E, SALARY S
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO IN (SELECT A.DEPTNO
                      FROM SALARY B, EMP A
                     WHERE SALMONTH = '202312'
                       AND A.EMPNO = B.EMPNO
                     GROUP BY A.DEPTNO
                    HAVING (SUM(B.SAL+B.COMM)) >= 55000)
   AND E.EMPNO IN(SELECT S1.EMPNO
                    FROM SALARY S1, SALARY S2
                   WHERE S1.EMPNO = S2.EMPNO
                     AND S1.SALMONTH = '202312'
                     AND S2.SALMONTH = '202311'
                     AND (S1.SAL+S1.COMM) > (S2.SAL+S2.COMM))
 ORDER BY (SAL+COMM) DESC;

SELECT E.EMPNO ������ȣ, E.DEPTNO �μ��ڵ�, (S.SAL+S.COMM) �ѱ޿���
  FROM EMP E, SALARY S,
       (SELECT A.DEPTNO, SUM(B.SAL+B.COMM)
          FROM SALARY B, EMP A
         WHERE SALMONTH = '202312'
           AND A.EMPNO = B.EMPNO
         GROUP BY A.DEPTNO
        HAVING (SUM(B.SAL+B.COMM)) >= 55000) B,
        (SELECT S1.EMPNO
           FROM SALARY S1, SALARY S2
          WHERE S1.EMPNO = S2.EMPNO
            AND S1.SALMONTH = '202312'
            AND S2.SALMONTH = '202311'
            AND (S1.SAL+S1.COMM) > (S2.SAL+S2.COMM)) C
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO = B.DEPTNO
   AND E.EMPNO = C.EMPNO
 ORDER BY (S.SAL+S.COMM) DESC;
  
  
SELECT A.EMPNO
           FROM SALARY A, SALARY B
          WHERE A.EMPNO = B.EMPNO
            AND A.SALMONTH = '202312'
            AND B.SALMONTH = '202311'
            AND A.SAL > B.SAL;
  
UPDATE SALARY 
   SET SAL = 8000, COMM = 800 
 WHERE SALMONTH = '202312' 
   AND EMPNO = '1004';  
   
COMMIT;

UPDATE SALARY SET SAL=6500, COMM=400 WHERE SALMONTH = '202312' AND EMPNO = '1030';
UPDATE SALARY SET SAL=6200, COMM=350 WHERE SALMONTH = '202312' AND EMPNO = '1031';
COMMIT;
--�μ��� 12���� �ѱ޿��� 55000�̻��� ���� ��ȸ�ϰ�, ��ȸ�� �μ��߿� ���� ���� �ѱ޿��� ���� �μ��� ������ ��, ������� �޿��� ���� �������� ��ȸ.
--��ȸ�׸� : �����ȣ, �����, �μ��ڵ�, �μ���, �Ǽ��ɾ�
SELECT EE.EMPNO, EE.ENAME, EE.DEPTNO, DD.DNAME, SS.SAL+SS.COMM
  FROM EMP EE, DEPT DD, SALARY SS, SALARY AA,           --SS : 12, AA : 11
       (SELECT A.DEPTNO, MAX(B.SAL+B.COMM) AS SAL1
          FROM EMP A, SALARY B,
               (SELECT E.DEPTNO, SUM(SAL+COMM)
                  FROM SALARY S, EMP E
                 WHERE S.SALMONTH = '202312'
                   AND E.EMPNO = S.EMPNO
                 GROUP BY E.DEPTNO
                HAVING (SUM(SAL+COMM)) >= 55000) C
         WHERE B.SALMONTH = '202312'
           AND B.EMPNO = A.EMPNO
           AND A.DEPTNO = C.DEPTNO
         GROUP BY A.DEPTNO) CC
 WHERE SS.SALMONTH = '202312'
   AND SS.EMPNO = EE.EMPNO
   AND EE.DEPTNO = CC.DEPTNO
   AND DD.DEPTNO = EE.DEPTNO
   AND SS.SAL+SS.COMM = CC.SAL1
   AND AA.SALMONTH = '202311'
   AND AA.EMPNO = EE.EMPNO
   AND SS.SAL+SS.COMM >= AA.SAL+AA.COMM;

SELECT * FROM SALARY WHERE SALMONTH = '202312'
AND EMPNO IN ('1004','1013','1014','1028','1029','1030','1031');

SELECT E.EMPNO ������ȣ, E.ENAME �����, (S.SAL+S.COMM) �Ǽ��ɾ�, E.DEPTNO �μ��ڵ�, D.DNAME �μ���
  FROM EMP E, SALARY S, DEPT D,
       (SELECT M1.DEPTNO, MAX(M1.U1) AS V
          FROM (SELECT A1.DEPTNO, SUM(B1.SAL+B1.COMM) U1
                  FROM SALARY B1, EMP A1
                 WHERE SALMONTH = '202312'
                   AND A1.EMPNO = B1.EMPNO
                 GROUP BY A1.DEPTNO
                HAVING (SUM(B1.SAL+B1.COMM)) >= 50000) M1
         GROUP BY DEPTNO) B,
        (SELECT S1.EMPNO
           FROM SALARY S1, SALARY S2
          WHERE S1.EMPNO = S2.EMPNO
            AND S1.SALMONTH = '202312'
            AND S2.SALMONTH = '202311'
            AND (S1.SAL+S1.COMM) > (S2.SAL+S2.COMM)) C
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO = B.DEPTNO
   AND E.EMPNO = C.EMPNO
   AND E.DEPTNO = D.DEPTNO
   AND (S.SAL+S.COMM) = B.V;

SELECT E.EMPNO, SAL, SAL+COMM
  FROM SALARY S, EMP E
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.DEPTNO = '30';


SELECT M1.DEPTNO, MAX(M1.U1)
  FROM (SELECT A.DEPTNO, SUM(B.SAL+B.COMM ) U1
          FROM SALARY B, EMP A
         WHERE SALMONTH = '202312'
           AND A.EMPNO = B.EMPNO
         GROUP BY A.DEPTNO
        HAVING (SUM(B.SAL+B.COMM)) >= 55000) M1
 GROUP BY DEPTNO;

SELECT A.DEPTNO, SUM(B.SAL+B.COMM ) S1
          FROM SALARY B, EMP A
         WHERE SALMONTH = '202312'
           AND A.EMPNO = B.EMPNO
         GROUP BY A.DEPTNO
        HAVING (SUM(B.SAL+B.COMM)) >= 55000;
