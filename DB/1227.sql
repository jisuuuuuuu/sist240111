--단일행 서브쿼리
--부서코드가 30번인 직원중 급여를 가장 많이 받는 사원보다 더 많은 급여를 받는 사람의
--이름과 급여를 출력하는 쿼리 작성(2023년 12월 기준)
--조회항목 : 직원명, 급여
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
                    
--팀장 중 평균급여액 이상을 받는 팀장에 대해 조회하는 쿼리작성.
--조회항목 : 직원번호, 직원명, 급여 (2023년 12월 기준)
--평균 급여액은 소숫점이하 반올림으로 적용함.
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
                  
SELECT E.EMPNO 직원번호, E.ENAME 직원명, S.SAL 급여
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
                                  
--다중행 서브쿼리 (ALL연산자 사용)
--부서코드가 30번인 직원의 급여액 이상으로 받는 모든 직원을 조회하는 쿼리
--조회항목 : 직원명, 급여 (단, 기준은 2023년 12월)
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
                       
--ANY 연산자 사용
--단일행 : 부서코드가 30번 직원급여 중 가장 낮은값보다 높은 급여를 받는 직원들의 이름, 급여를 출력하는 프로그램
--조회항목 : 직원명, 급여, 단, 2023년 12월
SELECT MIN(SAL)
  FROM EMP A, SALARY B
 WHERE B.SALMONTH = '202312'
   AND B.EMPNO = A.EMPNO
   AND A.DEPTNO = '30';
   
--GROUP BY, HAVING 사용
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
                    
--건수 검증
SELECT COUNT(*) FROM SALARY WHERE SALMONTH = '202312' AND SAL > 6800;

--다중형 서브쿼리
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
SELECT DISTINCT A.EMPNO          --20번에 해당하는 상사 직원번호
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR
   AND A.DEPTNO = '20';
   
SELECT EMPNO, ENAME
  FROM EMP
 WHERE NOT EXISTS (SELECT DISTINCT A.EMPNO   
                 FROM EMP A, EMP B
                WHERE A.EMPNO = B.MGR
                  AND A.DEPTNO = '90');
                  
--인라인뷰
SELECT E.EMPNO, E.ENAME, E.JOB
  FROM EMP E,
       (SELECT DISTINCT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) EE
 WHERE E.EMPNO = EE.EMPNO;
 
--인라인뷰 서브쿼리를 이용하여
--관리자 급여가 8500이상인 관리자정보를 조회하는 쿼리 작성
--조회항목 : 직원번호, 직원명, 직급, 급여
--단, 인라인뷰 서브쿼리에서는 관리자번호(직원번호)만 조회하고 금액체크도 포함
--2023년 12월 기준
SELECT DISTINCT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급, S.SAL 급여
  FROM EMP E,
       (SELECT A.EMPNO, S1.SAL
          FROM SALARY S1, EMP A, EMP B
         WHERE S1.SALMONTH = '202312'
           AND A.EMPNO = B.MGR
           AND A.EMPNO = S1.EMPNO
           AND S1.SAL >= 8500) S
 WHERE E.EMPNO = S.EMPNO;
 
 --위와 결과가 동일하게 적용하되 인라인뷰에서 조회항목이 관리자번호만 인 경우 쿼리작성
SELECT DISTINCT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급, S.SAL 급여
  FROM EMP E, SALARY S,
       (SELECT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) M
 WHERE E.EMPNO = S.EMPNO
   AND S.SALMONTH = '202312'
   AND E.EMPNO = M.EMPNO
   AND S.SAL >= 8500;
   
--차집합
SELECT EMPNO, ENAME
  FROM EMP
  
MINUS

SELECT DISTINCT A.EMPNO, A.ENAME
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
--입사일이  2021년 1월 1일 이후 입사자 중 팀장을 제외한 팀원들만 조회하는 쿼리
--조회항목 : 직원번호, 직원명, 직급, 입사일(YYYY-MM-DD)
SELECT EMPNO 직원번호, ENAME 직원명, JOB 직급, TO_CHAR(HIREDATE, 'YYYY-MM-DD') 입사일
  FROM EMP
 WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
 
 MINUS
 
SELECT DISTINCT A.EMPNO, A.ENAME, A.JOB, TO_CHAR(A.HIREDATE, 'YYYY-MM-DD')
  FROM EMP A, EMP B
 WHERE A.EMPNO = B.MGR;
 
--위결과와 같으며 인라인뷰로 사용하는 쿼리 작성(단, 인라인뷰에서는 직원번호만 조회함)
SELECT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') 입사일
  FROM EMP E,
       (SELECT EMPNO
          FROM EMP
         WHERE JOB = '사원'
            OR JOB = '직원') EE
 WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
   AND E.EMPNO = EE.EMPNO;
   
SELECT E1.EMPNO 직원번호, E1.ENAME 직원명, E1.JOB 직급, TO_CHAR(E1.HIREDATE, 'YYYY-MM-DD') 입사일
  FROM EMP E1,
      (SELECT EMPNO
         FROM EMP
         WHERE HIREDATE > TO_DATE('20210101', 'YYYYMMDD')
 
         MINUS
         
        SELECT DISTINCT A.EMPNO
          FROM EMP A, EMP B
         WHERE A.EMPNO = B.MGR) E2
 WHERE E1.EMPNO = E2.EMPNO;
 
--급여액이 6500 이상이면서 20230101 이전 입사사 중 팀장을 제외한 팀원들만 조회하는 쿼리 작성
--조회항목 : 직원번호, 직원명, 직급, 급여. 입사일(YYYY-MM-DD)
--단, MINUS연산자 이용
SELECT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급, S.SAL 급여, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') 입사일
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
   
--위 결과와 동일하게 작성하며, 위 SQL문은 인라인뷰로 처리함.
--인라인뷰 조회항목은 급여를 제외한 나머지 항목 적용.
SELECT E.EMPNO 직원번호, E.ENAME 직원명, E.JOB 직급, S.SAL 급여, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') 입사일
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
   
--직원정보 중 2021년 3월 1일 부터 2022년 2월 28일 사이에 입사한 직원 중 2023년 12월 급여액 평균보다 작고
--보너스도 평균보다 작은 직원에 대한 정보를 조회하는 쿼리 작성
--조회항목 : 직원번호, 직원명, 급여, 보너스
--단, 급여액 평균과 보너스 평균에 대한 서브쿼리를 사용하고 소수점 이하는 반올림
--   급여액과 보너스 평균금액 조회시 입사일에 상관없이 쿼리작성
--MINUS 연산자를 이용하며 인라인뷰로 작성하며 조회항목은 직원번호, 급여액, 보너스로 함
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