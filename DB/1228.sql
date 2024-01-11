--다중행 연산자 all
--상사 중애서 보너스를 800이상 받는 상사만 조회하는 쿼리작성
--조회항목 : 직원번호, 직원명, 직급
SELECT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급
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
   
--인사팀의 2023년 12월 급여와 직원번호를 조회하는 쿼리작성
--단, 서브쿼리로만 사용함.(WHERE 절에서만 사용 -- FROM절에 테이블은 1개만 사용)
--인사팀 부서쿼리를 모르므로 인사팀 명으로 검색
--조회항목 : 사원번호, 급여액
SELECT EMPNO, SAL
  FROM SALARY
 WHERE SALMONTH = '202312'
   AND EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE DEPTNO IN (SELECT DEPTNO
                                     FROM DEPT
                                    WHERE DNAME = '인사팀'));
                                    
--위와 결과가 동일하며, 인라인뷰로 사용하는 쿼리 작성
--단, FROM절에 SALARY와 서브쿼리로 사용하도록 작성(SALARY S, 인라인뷰는 A로)
SELECT A.EMPNO, S.SAL
  FROM SALARY S,
       (SELECT E.EMPNO
          FROM EMP E, DEPT D
         WHERE E.DEPTNO = D.DEPTNO
           AND D.DNAME = '인사팀') A
 WHERE SALMONTH = '202312'
   AND S.EMPNO = A.EMPNO;
   
--인사팀의 2023년 12월 최고 급여자의 직원번호와 급여를 조회하는 쿼리작성
--단, 서브쿼리로만 사용함.(WHERE절 사용), 인사팀은 코드를 알 수 없음
--조회항목 : 직원, 직원명, 급여액
SELECT EMPNO 직원, (SELECT ENAME FROM EMP WHERE EMPNO = S.EMPNO) 직원명, SAL 급여액
  FROM SALARY S
 WHERE SALMONTH = '202312'
   AND SAL = (SELECT MAX(SAL)
                 FROM SALARY 
                WHERE EMPNO IN (SELECT EMPNO
                                  FROM EMP
                                  WHERE DEPTNO IN (SELECT DEPTNO
                                                     FROM DEPT
                                                    WHERE DNAME = '인사팀')))
   AND EMPNO IN (SELECT EMPNO
                   FROM EMP
                  WHERE DEPTNO IN (SELECT DEPTNO
                                     FROM DEPT
                                    WHERE DNAME = '인사팀'));
                                    
--부서별 2023년 12월 총급여(급여 + 보너스)가 50000이상인 팀을 조회하고, 조회된 부서에 속하는
--직원들의 정보를 조회하는 쿼리 작성
--조회항목 : 직원번호, 부서코드, 총급여액
--단, 조회는 총급여액이 높은 순으로 정렬함
SELECT E.EMPNO 직원번호, E.DEPTNO 부서코드, (SAL+COMM) 총급여액
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
 
SELECT E.EMPNO 직원번호, E.DEPTNO 부서코드, (SAL+COMM) 총급여액
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
 
--부서별 12월 총급여(급여+보너스)가 550000 이상인 팀을 조회하고, 조회된 부서에 속하는 직원중에
--전월대비 총급여액이 오를 직원을 조회하는 쿼리 작성
--조회항목 : 직원번호, 부서코드, 총급여액
--단, 조회는 총 급여액이 높은 순으로 정렬함.
SELECT E.EMPNO 직원번호, E.DEPTNO 부서코드, (SAL+COMM) 총급여액
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

SELECT E.EMPNO 직원번호, E.DEPTNO 부서코드, (S.SAL+S.COMM) 총급여액
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
--부서별 12월의 총급여가 55000이상인 팀을 조회하고, 조회된 부서중에 가장 높은 총급여를 가진 부서의 직원들 중, 전월대비 급여가 오른 직원들을 조회.
--조회항목 : 사원번호, 사원명, 부서코드, 부서명, 실수령액
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

SELECT E.EMPNO 직원번호, E.ENAME 사원명, (S.SAL+S.COMM) 실수령액, E.DEPTNO 부서코드, D.DNAME 부서명
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
