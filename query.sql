USE examinations_db;

SELECT Name,Surname,[Group].GroupName FROM Student --1.Select all students by group name
INNER JOIN [Group] ON Student.GroupId= [Group].GroupId
ORDER BY GroupName;

SELECT Student.Name, Student.Surname, CreditResult.Result FROM Student --2. Select all students name and surname and marks bounded to their ID
LEFT JOIN StudentMark ON Student.StudentId = StudentMark.StudentId
LEFT JOIN CreditResult ON StudentMark.CreditResultId = CreditResult.CreditResultId
WHERE Result IS NOT NULL;

SELECT Student.Name, Student.Surname, Student.Age, Student.Course, [Group].GroupName FROM Student --3. Select Students inf and group name
INNER JOIN [Group] ON Student.GroupId = [Group].GroupId
ORDER BY [Group].GroupName;

SELECT [Subject].SubjectName, Teacher.Name, Teacher.Surname, Faculty.FacultyName FROM [Subject] --4. Select subjects + faculty + teacher
INNER JOIN Faculty ON [Subject].FacultyId = Faculty.FacultyId
INNER JOIN Teacher ON [Subject].TeacherId = Teacher.TeacherId
ORDER BY Faculty.FacultyName;

SELECT [Subject].SubjectName,DateOfCredit,Hours,Teacher.Name,Teacher.Surname, RankType.RankTypeName FROM Credit --5. Select credit + teacher + subject + rank
INNER JOIN [Subject] ON Credit.SubjectId = [Subject].SubjectId
INNER JOIN Teacher ON [Subject].TeacherId = Teacher.TeacherId
INNER JOIN RankType ON Teacher.RankTypeId = RankType.RankTypeId
ORDER BY [Subject].SubjectName;

SELECT Student.Name, Student.Surname, Student.Age, StudentType.StudentTypeName FROM Student --6 Select student inf + student type
INNER JOIN StudentType ON Student.StudentTypeId = StudentType.StudentTypeId
ORDER BY StudentType.StudentTypeName;

SELECT [Group].GroupName,GroupType.GroupTypeName FROM [Group] --7 group and group type
JOIN GroupType ON [Group].GroupTypeId = GroupType.GroupTypeId
ORDER BY [Group].GroupName;

SELECT Teacher.Name, Teacher.Surname, RankType.RankTypeName AS [Rank] FROM Teacher --8 select teachers with ranks
INNER JOIN RankType ON Teacher.RankTypeId = RankType.RankTypeId;

SELECT [Subject].SubjectName, CreditType.CreditTypeName FROM Credit --9 select all credits
INNER JOIN [Subject] ON Credit.SubjectId = [Subject].SubjectId
INNER JOIN CreditType ON Credit.CreditTypeId = CreditType.CreditTypeId;

SELECT [Subject].SubjectName,Credit.Hours FROM Credit --10 select subj where time for credit >=2
INNER JOIN [Subject] ON Credit.SubjectId = [Subject].SubjectId
WHERE Hours>=2;

SELECT [Subject].SubjectName,Credit.DateOfCredit FROM Credit --11 Select credit where credit
INNER JOIN CreditType ON Credit.CreditTypeId = CreditType.CreditTypeId
INNER JOIN [Subject] ON Credit.SubjectId = [Subject].SubjectId
WHERE CreditType.CreditTypeName = 'Залік';

SELECT [Subject].SubjectName,Credit.DateOfCredit FROM Credit --12 select credit where Exam
INNER JOIN CreditType ON Credit.CreditTypeId = CreditType.CreditTypeId
INNER JOIN [Subject] ON Credit.SubjectId = [Subject].SubjectId
WHERE CreditType.CreditTypeName = 'Екзамен';
GO
CREATE VIEW StudentWithTheirResults 
AS
SELECT Student.Name AS Name,Student.Surname AS Surname,Student.Course AS Course,[Group].GroupName AS [Group],CreditResult.Result AS Result
FROM Student
INNER JOIN [Group] ON Student.GroupId = [Group].GroupId
JOIN StudentMark ON StudentMark.StudentId = Student.StudentId
JOIN CreditResult ON StudentMark.CreditResultId = CreditResult.CreditId
WHERE CreditResult.Result IS NOT NULL
GO

SELECT StudentWithTheirResults.[Group] AS Groups,AVG(Result) AS AvgResult FROM StudentWithTheirResults --13
GROUP BY StudentWithTheirResults.[Group]
HAVING AVG(Result)>75;
GO
CREATE FUNCTION SelectSubjectByFaculty (@Faculty nvarchar(10)) --15
RETURNS TABLE
AS
RETURN
(
SELECT [Subject].SubjectName FROM [Subject]
JOIN Faculty ON [Subject].FacultyId = Faculty.FacultyId
WHERE Faculty.FacultyName = @Faculty
);
GO

SELECT * FROM SelectSubjectByFaculty('ФІОТ');

SELECT Credit.CreditId AS CreditId, Result FROM CreditResult --16
INNER JOIN Credit ON CreditResult.CreditId = Credit.CreditId
WHERE Result > 59;

CREATE PROC SelectAllStudents @Result int
AS
SELECT  [Group].GroupName,Student.Name, Student.Surname, CreditResult.Result FROM Student
INNER JOIN [Group] ON Student.GroupId = [Group].GroupId
LEFT JOIN StudentMark ON Student.StudentId = StudentMark.StudentId
LEFT JOIN CreditResult ON StudentMark.CreditResultId = CreditResult.CreditResultId
WHERE Result IS NOT NULL AND @Result<Result
go

EXEC SelectAllStudents @Result = 80; --14
SELECT Student.[Name] AS Name, Student.Surname AS Surname, CreditResult.Result, [Subject].SubjectName FROM Student --17
INNER JOIN StudentMark ON StudentMark.StudentId = Student.StudentId
INNER JOIN CreditResult ON StudentMark.CreditResultId = CreditResult.CreditResultId
INNER JOIN StudentSubject ON StudentSubject.StudentId = Student.StudentId
INNER JOIN [Subject] ON StudentSubject.SubjectId = [Subject].SubjectId;

SELECT [Subject].SubjectName FROM [Subject] --18
INNER JOIN Credit ON Credit.SubjectId = [Subject].SubjectId
INNER JOIN CreditResult ON CreditResult.CreditId = Credit.CreditId
WHERE CreditResult.Result >95;

SELECT Faculty.FacultyName, COUNT([Subject].SubjectName) FROM [Subject]  --19
INNER JOIN Faculty ON [Subject].FacultyId = Faculty.FacultyId
GROUP BY Faculty.FacultyName;

SELECT Teacher.Surname, COUNT([Subject].SubjectName) AS AmountOfSubject FROM Teacher --20
INNER JOIN [Subject] ON [Subject].TeacherId = Teacher.TeacherId
GROUP BY Teacher.Surname
ORDER BY AmountOfSubject;

SELECT Student.Surname, MIN(CreditResult.Result) AS MinimalResult FROM Student --21
INNER JOIN StudentMark ON StudentMark.StudentId = Student.StudentId
INNER JOIN CreditResult ON StudentMark.CreditResultId = CreditResult.CreditResultId
GROUP BY Surname;
