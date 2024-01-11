--INDEX관리
SELECT * FROM USER_INDEXES;

SELECT * FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'PK_EMP';
SELECT * FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'PK_SALARY';
SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = 'EMP';

--인덱스 추가
CREATE INDEX EX_EMPNO ON SALARY (EMPNO, SAL);

SELECT *
  FROM SALARY
 WHERE SALMONTH = '202311' AND EMPNO = '1001';
  
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'SALARY';

---인덱스 리빌드
ALTER INDEX PK_EMP REBUILD;
ALTER INDEX PK_DEPT REBUILD;
ALTER INDEX PK_SALARY REBUILD;
ALTER INDEX EX_EMPNO REBUILD;

SELECT 'ALTER INDEX ' || INDEX_NAME || ' REBUILD;'
  FROM USER_INDEXES
 WHERE TABLE_OWNER = 'C##SISTUSER'          --오라클 계정
   AND INDEX_NAME LIKE 'PK_%';              --인덱스명
   
ALTER INDEX PK_DEPT REBUILD;
ALTER INDEX PK_EMP REBUILD;
ALTER INDEX PK_SALARY REBUILD;

--시퀸스
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE EX_TEST_SEQ
INCREMENT BY 10
START WITH 70
MINVALUE 1
MAXVALUE 90
CYCLE
NOCACHE;

SELECT EX_SEQ.NEXTVAL
  FROM DUAL;
  
SELECT EX_SEQ.CURRVAL
  FROM DUAL;
  
SELECT * FROM DEPT;

INSERT INTO DEPT VALUES (EX_SEQ.NEXTVAL, '기획팀', '서울 강남구');

SELECT * FROM USER_SEQUENCES;

SELECT EX_TEST_SEQ.NEXTVAL
  FROM DUAL;
  
DROP SEQUENCE EX_TEST_SEQ;

--직원번호생성에 필요한 시퀀스 생성
SELECT MAX(EMPNO) FROM EMP;

CREATE SEQUENCE EX_EMPNO_SEQ
INCREMENT BY 1
START WITH 2004
MINVALUE 1001
MAXVALUE 9999
NOCYCLE
NOCACHE;

SELECT MAX(EMPNO)+1 FROM EMP;

INSERT INTO EMP (EMPNO, ENAME, HIREDATE, DEPTNO)
VALUES ((SELECT MAX(EMPNO)+1 FROM EMP), '테스트1', SYSDATE, '20');

COMMIT;

INSERT INTO EMP(EMPNO, ENAME, HIREDATE, DEPTNO)
VALUES (EX_EMPNO_SEQ.NEXTVAL, '테스트2', SYSDATE, '20');

SELECT EX_EMPNO_SEQ.CURRVAL FROM DUAL;

SELECT MAX(EMPNO) FROM EMP;

/*팀별과제
1. 회원 테이블(사용자)
테이블명은 T_USER로 정의, 회원가입시 필요한 컬럼을 정의하고, 회원상태(사용(Y),정지(N))가 관리될 수 잇도록 정의
각 컬럼에 대한 COMMENT를 정의하여 컬럼의 의미를 전달할 수 있도록 함
사용자 아이디를 PK로 정의함.(단, 테이블 생성 후 PK생성)

2. 게시판테이블(댓글관련 자유)
테이블명은 T_BOARD로 정의, 게시판글번호는 NUMBER(12)로 정하고 시퀸스는 SEQ_BOARD로 정의함
각 컬럼에 대한 COMMENT를 정의하고 컬럼의 의미를 전달할수 있도록
게시판글번호를 PK로 정의함(단, 테이블생성후 PK생성)
게시판 조회갯수를 관리함. 크기는 게시판 글번호와 동일하게 적용
게시판 테이블은 글제목, 글내뇽(TEXTAREA), 조회갯수 등
*/
CREATE TABLE T_USER(
    U_ID VARCHAR2(12),
    U_PW VARCHAR2(12),
    U_EMAIL VARCHAR2(25),
    U_NAME VARCHAR2(20),
    U_BIRTH DATE,
    U_STA CHAR(1)
);

COMMENT ON TABLE T_USER IS '회원정보';
COMMENT ON COLUMN T_USER.U_ID IS '아이디';
COMMENT ON COLUMN T_USER.U_STA IS '회원상태';
COMMENT ON COLUMN T_USER.U_NAME IS '이름';
COMMENT ON COLUMN T_USER.U_PW IS '비밀번호';
COMMENT ON COLUMN T_USER.U_EMAIL IS '이메일주소';
COMMENT ON COLUMN T_USER.U_BIRTH IS '생일';


ALTER TABLE T_USER ADD U_JOIN DATE; --가입일 추가
COMMENT ON COLUMN T_USER.U_JOIN IS '가입일';

ALTER TABLE T_USER MODIFY U_BIRTH CHAR(8); --생일 타입변경

ALTER TABLE T_USER
ADD CONSTRAINTS PK_U_ID PRIMARY KEY(U_ID);

INSERT INTO T_USER VALUES('jsu0723', '12345678', 'jisu@gmail.com', '김지수', TO_DATE('2000-06-14', 'YYYY-MM-DD'), 'Y');
ROLLBACK;

CREATE TABLE T_BOARD(
    B_NUM NUMBER(12),
    B_TITLE VARCHAR2(50),
    TEXTAREA CLOB,
    U_ID VARCHAR2(12),
    B_UPLOAD DATE,
    B_CNT NUMBER(12)
);

COMMENT ON TABLE T_BOARD IS '게시판';
COMMENT ON COLUMN T_BOARD.B_NUM IS '글 번호';
COMMENT ON COLUMN T_BOARD.B_TITLE IS '글 제목';
COMMENT ON COLUMN T_BOARD.TEXTAREA IS '글 내용';
COMMENT ON COLUMN T_BOARD.U_ID IS '작성자';
COMMENT ON COLUMN T_BOARD.B_UPLOAD IS '등록일자';
COMMENT ON COLUMN T_BOARD.B_CNT IS '조회갯수';

ALTER TABLE T_BOARD
ADD CONSTRAINTS PK_B_NUM PRIMARY KEY(B_NUM);

ALTER TABLE T_BOARD
ADD CONSTRAINTS FK_U_ID FOREIGN KEY(U_ID)
REFERENCES T_USER(U_ID);


CREATE SEQUENCE SEQ_BOARD
INCREMENT BY 1
START WITH 1
MINVALUE 1
NOMAXVALUE
NOCYCLE
NOCACHE;

ALTER SEQUENCE SEQ_BOARD                --MAXVALUE 수정
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999999999
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES;

INSERT INTO T_BOARD
VALUES (SEQ_BOARD.NEXTVAL, '테스트입니다', '내용입니다', 'jsu0723', SYSDATE, '20');

ROLLBACK;