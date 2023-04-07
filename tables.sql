CREATE DATABASE exminations_db;
GO

USE examinations_db;
GO
CREATE TABLE GroupType(
GroupTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
GroupTypeName NVARCHAR(20) NOT NULL
);
GO
CREATE TABLE [Group](
GroupId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
GroupName NVARCHAR(10) NOT NULL,
GroupTypeId INT NOT NULL,
CONSTRAINT FK_GroupType_Group FOREIGN KEY (GroupTypeId)
REFERENCES GroupType(GroupTypeId)
);
GO
CREATE TABLE Student(
StudentId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(100) NOT NULL,
Surname NVARCHAR(100) NOT NULL,
Age INT NOT NULL,
GroupId INT NOT NULL,
Course INT NOT NULL,
StudentTypeId INT NOT NULL,
CONSTRAINT FK_Group_Student FOREIGN KEY (GroupId)
REFERENCES [Group](GroupId)
);
GO
ALTER TABLE Student
ADD CONSTRAINT FK_StudentType_Student FOREIGN KEY (StudentTypeId)
REFERENCES StudentType(StudentTypeId);
GO
CREATE TABLE StudentType (
StudentTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
StudentTypeName NVARCHAR(40) NOT NULL
);
GO
CREATE TABLE Faculty(
FacultyId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FacultyName NVARCHAR(100) NOT NULL
);
GO
CREATE TABLE [Subject](
SubjectId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
SubjectName NVARCHAR(100) NOT NULL,
StudentId INT NOT NULL,
FacultyId INT NOT NULL,
TeacherId INT NOT NULL
);

ALTER TABLE [Subject]
ADD CONSTRAINT FK_Student_Subject FOREIGN KEY (StudentId)
REFERENCES Student(StudentId);

ALTER TABLE [Subject] 
ADD CONSTRAINT FK_Faculty_Subject FOREIGN KEY (FacultyId)
REFERENCES Faculty(FacultyId);

ALTER TABLE [Subject]
ADD CONSTRAINT FK_Teacher_Subject FOREIGN KEY (TeacherId)
REFERENCES Teacher(TeacherId);
GO
CREATE TABLE Teacher(
TeacherId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(100) NOT NULL,
Surname NVARCHAR(100) NOT NULL,
RankTypeId INT NOT NULL
);

ALTER TABLE Teacher
ADD CONSTRAINT FK_RankType_Teacher FOREIGN KEY (RankTypeId)
REFERENCES RankType(RankTypeId);
GO
CREATE TABLE RankType(
RankTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
RankTypeName NVARCHAR (100) NOT NULL
);
GO
CREATE TABLE Credit(
CreditId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
DateOfCredit DATETIME NOT NULL,
Hours INT NOT NULL,
SubjectId INT NOT NULL,
CreditTypeId INT NOT NULL,
TeacherId INT NOT NULL
);

ALTER TABLE Credit
ADD CONSTRAINT FK_Subject_Credit FOREIGN KEY (SubjectId)
REFERENCES [Subject](SubjectId);

ALTER TABLE Credit
ADD CONSTRAINT FK_Teacher_Credit FOREIGN KEY (TeacherId)
REFERENCES Teacher(TeacherId);

ALTER TABLE Credit
ADD CONSTRAINT FK_CreditType_Credit FOREIGN KEY (CreditTypeId)
REFERENCES CreditType(CreditTypeId);
GO
CREATE TABLE CreditType(
CreditTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
CreditTypeName NVARCHAR(100) NOT NULL
);
GO
CREATE TABLE CreditResult(
CreditResultId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Result INT NOT NULL,
CreditId INT NOT NULL,
StudentId INT NOT NULL,
);

ALTER TABLE CreditResult
ADD CONSTRAINT FK_Student_CreditResult FOREIGN KEY (StudentId)
REFERENCES Student(StudentId);

ALTER TABLE CreditResult
ADD CONSTRAINT FK_Credit_CreditResult FOREIGN KEY (CreditId)
REFERENCES Credit(CreditId);

ALTER TABLE [Subject]
DROP CONSTRAINT FK_Student_Subject;
GO
CREATE TABLE StudentSubject(
StudentId INT NOT NULL,
SubjectId INT NOT NULL,
CONSTRAINT FK_Student FOREIGN KEY (StudentId)
REFERENCES Student(StudentId),
CONSTRAINT FK_Subject FOREIGN KEY (SubjectId)
REFERENCES [Subject](SubjectId)
);

ALTER TABLE [Subject]
DROP COLUMN StudentId;

ALTER TABLE CreditResult
DROP CONSTRAINT FK_Student_CreditResult;
GO
CREATE TABLE StudentMark(
StudentId INT NOT NULL,
CreditResultId INT NOT NULL,
CONSTRAINT FK_ResultId FOREIGN KEY (CreditResultId)
REFERENCES CreditResult(CreditResultId),
CONSTRAINT FK_StudentId FOREIGN KEY (StudentId)
REFERENCES Student(StudentId)
);

ALTER TABLE CreditResult
DROP COLUMN StudentId;


ALTER DATABASE examinations_db
SET MULTI_USER;
GO

CREATE LOGIN Viewer
WITH PASSWORD = '12345';