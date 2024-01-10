//*
DROP TABLE Facility cascade constraints;
DROP TABLE Member cascade constraints;
DROP TABLE MembershipPlan cascade constraints;
DROP TABLE MembershipPurchase cascade constraints;
DROP TABLE Attendance cascade constraints;
DROP TABLE Trainer cascade constraints;
DROP TABLE GymClass cascade constraints;
DROP TABLE ClassMemberMap cascade constraints;
/*
*/


SET ECHO OFF;

-- TABLE DROP STATEMENTS

SET VERIFICATION OFF

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Facility CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Member CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MembershipPlan CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MembershipPurchase CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Attendance CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Trainer CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE GymClass CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ClassMemberMap CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/


/* NEW TABLE CREATION */ 
PROMPT '******* Starting Table Creation';


-- FACILITY Table Structure (DDL)
PROMPT '******* Create Facility table';
CREATE TABLE Facility (
    facilityId int NOT NULL PRIMARY KEY,
    facilityName varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    startTime timestamp NOT NULL,
    closeTime timestamp NOT NULL,
    phone varchar(50) NOT NULL,
    addressLine1 varchar(50) NOT NULL,
    addressLine2 varchar(50) DEFAULT NULL,
    state varchar(50) DEFAULT NULL,
    country varchar(50) NOT NULL,
    postalCode varchar(15) NOT NULL
);

PROMPT '******* FACILITY table created';

PROMPT '******* Create Member table';
-- MEMBER (DDL)
CREATE TABLE Member (
  memberID int NOT NULL PRIMARY KEY,
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  email varchar(100) NOT NULL,
  facilityID int NOT NULL,
  gender varchar(10) DEFAULT NULL,
  DOB date NOT NULL,
  phone varchar(50) NOT NULL,
  CONSTRAINT mem_facility_fk FOREIGN KEY (facilityID) REFERENCES Facility(facilityID)
);

PROMPT '******* Member table created';

-- Table structure for table 'MembershipPlan' (DDL)
PROMPT '******* Create MembershipPlan tables';
CREATE TABLE MembershipPlan(
    planID int NOT NULL PRIMARY KEY,
    planName varchar(50) NOT NULL,
    duration varchar(20) NOT NULL,
    price decimal(5,2) NOT NULL,
    description varchar(100) DEFAULT NULL
);



PROMPT '******* Create Attendance table';
CREATE TABLE Attendance (
    attendanceID int NOT NULL PRIMARY KEY,
    memberID int NOT NULL,
    checkInTime timestamp NOT NULL,
    checkOutTime timestamp DEFAULT NULL,
    CONSTRAINT att_mem_fk FOREIGN KEY (memberID) REFERENCES Member (memberID)
);

PROMPT '******* Create Trainer table';
-- Trainer (DDL)
CREATE TABLE Trainer (
    trainerID int NOT NULL PRIMARY KEY,
    lastName varchar(50) NOT NULL,
    firstName varchar(50) NOT NULL,
    email varchar(100) NOT NULL,
    facilityID int NOT NULL,
    specialization varchar(100) DEFAULT NULL,
    CONSTRAINT trainer_facility_fk FOREIGN KEY (facilityID) REFERENCES Facility (facilityID)
);


/*Table structure for table 'GymClass' */
PROMPT '******* Create GymClass table';
CREATE TABLE GymClass(
    classID int NOT NULL PRIMARY KEY,
    className varchar(50) NOT NULL,
    trainerID int NOT NULL,
    schedule varchar(100) NOT NULL,
    maxCapacity int NOT NULL,
    CONSTRAINT gymclass_trainer_fk FOREIGN KEY (trainerID) REFERENCES Trainer (trainerID)
);

CREATE TABLE ClassMemberMap(
    classID int NOT NULL,
    memberID int NOT NULL, 
    PRIMARY KEY (classID, memberID),
    CONSTRAINT map_class_fk FOREIGN KEY (classID) REFERENCES GymClass (classID),
    CONSTRAINT map_member_fk FOREIGN KEY (memberID) REFERENCES Member (memberID)
);

PROMPT '******* Create MembershipPurchase table';
CREATE TABLE MembershipPurchase(
    purchaseID int NOT NULL PRIMARY KEY,
    memberID int NOT NULL,
    planID int NOT NULL,
    purchaseDate date NOT NULL,
    expirationDate date DEFAULT NULL,
    isCancelled NUMBER(1) DEFAULT 0 CHECK (isCancelled IN(0, 1)), --0 for false 1 for true
    CONSTRAINT purchase_mem_fk FOREIGN KEY (memberID) REFERENCES Member (memberID),
    CONSTRAINT purchase_plan_fk FOREIGN KEY (planID) REFERENCES MembershipPlan (planID)
);

PROMPT '******* CREATION SCRIPT COMPLETED ************';
SET VERIFICATION ON
SET ECHO ON

