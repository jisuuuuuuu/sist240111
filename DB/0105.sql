CREATE TABLE SMEMBER (
    M_ID VARCHAR2(12) CONSTRAINT PK_SMEMBER PRIMARY KEY,
    M_PWD VARCHAR2(12),
    M_NAME VARCHAR2(20),
    M_NIC CHAR(10),
    M_EMAIL VARCHAR2(25),
    M_PHONE CHAR(11),
    M_GRADE VARCHAR(6),
    M_STA CHAR(4),
    M_BIRTH CHAR(8)
);

CREATE TABLE SGRADE (
    M_GRADE VARCHAR2(6)CONSTRAINT PK_SGRADE PRIMARY KEY,
    M_COUPON VARCHAR(20)
);

CREATE TABLE SCLO_CATE (
    C_TYPE VARCHAR2(20) CONSTRAINT PK_SCLO_CATE PRIMARY KEY,
    C_SEASON VARCHAR2(10),
    C_AGE VARCHAR2(20)
);

CREATE TABLE SCLOTHES (
    C_NUM VARCHAR(25) CONSTRAINT PK_SCLOTHES PRIMARY KEY,
    C_TYPE VARCHAR(20),
    C_NAME VARCHAR(30),
    C_PRICE NUMBER(10, 0),
    C_PHOTO BLOB,
    C_EXPLAIN CLOB,
    C_SIZE VARCHAR(5),
    C_HITS NUMBER(12)
);


CREATE TABLE SORDER(
    O_NUM VARCHAR2(12) CONSTRAINT PK_SORDER PRIMARY KEY,
    M_ID VARCHAR2(12),
    C_NUM VARCHAR2(25),
    O_NAME VARCHAR2(20),
    O_ADDRESSEE VARCHAR2(20),
    O_ADDRESS CLOB,
    O_CODE CHAR(5),
    O_PHONE CHAR(11),
    O_REQUEST CLOB
);

CREATE TABLE SREVIEW (
    R_NUM VARCHAR(25) CONSTRAINT PK_SREVIEW PRIMARY KEY,
    M_ID VARCHAR2(12),
    C_NUM VARCHAR2(25),
    R_TEXT BLOB,
    R_DATE DATE,
    R_MARK NUMBER(2, 2)
);

CREATE TABLE SBASKET (
    B_NUM VARCHAR2(25) CONSTRAINT PK_SBASKET PRIMARY KEY,
    M_ID VARCHAR2(12),
    C_NUM VARCHAR2(25),
    B_CNT NUMBER(3, 0)
);

CREATE TABLE SPAYMENT (
    P_NUM VARCHAR2(25) CONSTRAINT PK_SPAYMENT PRIMARY KEY,
    M_ID VARCHAR2(12),
    C_NUM VARCHAR2(25),
    S_NAME VARCHAR2(12),
    S_MILEAGE NUMBER(10, 0),
    S_CNT NUMBER(3, 0)
);

ALTER TABLE SPAYMENT ADD CA_NUM VARCHAR2(25);

CREATE TABLE SMANAGER (
    N_NUM VARCHAR2(12) CONSTRAINT PK_SPAYMENT_NUM PRIMARY KEY,
    N_ID VARCHAR2(12), --CONSTRAINT PK_SPAYMENT_ID PRIMARY KEY,
    N_PWD VARCHAR2(12),
    N_NAME VARCHAR2(20)
);

CREATE TABLE SINQUIRY (
    I_NUM VARCHAR2(25) CONSTRAINT PK_SINQUIRY PRIMARY KEY,
    M_ID VARCHAR2(12),
    C_NUM VARCHAR2(25),
    N_NUM VARCHAR2(12),
    I_TEXT_M CLOB,
    I_DATE DATE,
    I_TEXT_N CLOB,
    I_STA CHAR(2)
);

CREATE TABLE SCHARGE (
    CA_NUM VARCHAR2(25) CONSTRAINT PK_SCHARGE PRIMARY KEY,
    M_ID VARCHAR2(12),
    CA_METHOD VARCHAR(20),
    CA_DATE DATE,
    CA_PRICE NUMBER(10, 0),
    CA_MILEAGE NUMBER(10, 0)
);

ALTER TABLE SMEMBER
ADD CONSTRAINTS FK_SGRADE_SMEMBER FOREIGN KEY(M_GRADE)
REFERENCES SGRADE(M_GRADE);

ALTER TABLE SCLOTHES
ADD CONSTRAINTS FK_SCATE_SCLOTHES FOREIGN KEY(C_TYPE)
REFERENCES SCLO_CATE(C_TYPE);

ALTER TABLE SORDER
ADD CONSTRAINTS FK_SMEMBER_SORDER FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SORDER
ADD CONSTRAINTS FK_SCLOTHES_SORDER FOREIGN KEY(C_NUM)
REFERENCES SCLOTHES(C_NUM);

ALTER TABLE SREVIEW
ADD CONSTRAINTS FK_SMEMBER_SREVIEW FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SREVIEW
ADD CONSTRAINTS FK_SCLOTHES_SREVIEW FOREIGN KEY(C_NUM)
REFERENCES SCLOTHES(C_NUM);

ALTER TABLE SBASKET
ADD CONSTRAINTS FK_SMEMBER_SBASKET FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SORDER
ADD CONSTRAINTS FK_SCLOTHES_SBASKET FOREIGN KEY(C_NUM)
REFERENCES SCLOTHES(C_NUM);

ALTER TABLE SCHARGE
ADD CONSTRAINTS FK_SMEMBER_SCHARGE FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SPAYMENT
ADD CONSTRAINTS FK_SMEMBER_SPAYMENT FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SPAYMENT
ADD CONSTRAINTS FK_SCLOTHES_SPAYMENT FOREIGN KEY(C_NUM)
REFERENCES SCLOTHES(C_NUM);

ALTER TABLE SPAYMENT
ADD CONSTRAINTS FK_SCHARCE_SPAYMENT FOREIGN KEY(CA_NUM)
REFERENCES SCHARGE(CA_NUM);

ALTER TABLE SINQUIRY
ADD CONSTRAINTS FK_SMEMBER_SINQURY FOREIGN KEY(M_ID)
REFERENCES SMEMBER(M_ID);

ALTER TABLE SINQUIRY
ADD CONSTRAINTS FK_SCLOTHES_SINQUIRY FOREIGN KEY(C_NUM)
REFERENCES SCLOTHES(C_NUM);

ALTER TABLE SINQUIRY
ADD CONSTRAINTS FK_SMANAGER_SINQUIRY FOREIGN KEY(N_NUM)
REFERENCES SMANAGER(N_NUM);