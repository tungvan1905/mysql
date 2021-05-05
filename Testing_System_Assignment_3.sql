/*---------------Query Database---------------*/

-- Question 2: Lay ra tat ca phong ban
SELECT * FROM Department;

-- Question 3: Lay ra ID phong ban 'Sale'
SELECT DepartmentID FROM Department
WHERE   DepartmentName='Sale';

-- Question 4: Thong tin Account co Fullname dai nhat
SELECT * FROM Account 
WHERE   CHAR_LENGTH(Fullname) = (SELECT MAX(CHAR_LENGTH(Fullname)) FROM `Account`);

-- Question 5: Giong Q4 + Phong ban ID=3
SELECT * FROM Account 
WHERE   CHAR_LENGTH(Fullname) = (SELECT MAX(CHAR_LENGTH(Fullname)) FROM `Account`)
AND DepartmentID=3;

-- Question 6:Lay ten Group tham gia truoc ngay 20-12-2019
SELECT GroupName FROM `Group` 
WHERE DATEDIFF('2019-12-20',CreateDate)>0;

-- Question 7: Lay QuestionID>=4 cau tra loi
SELECT QuestionID FROM Answer
GROUP BY QuestionID
HAVING COUNT(QuestionID)>=4;

-- Question 8: Lay ma de thi >=60' va truoc ngay 20/12/2019
SELECT `Code` FROM Exam
WHERE Duration>=60 AND CreateDate < '2019-12-20';

-- Question 9: Lay ra 5 Gr tao ra gan day nhat
SELECT * FROM `Group`
ORDER BY CreateDate DESC LIMIT 5;

-- Question 10: Dem so nhan vien co DepartmentID=2
SELECT DepartmentID,COUNT(DepartmentID) AS 'So luong nhan vien' FROM Department
GROUP BY DepartmentID
HAVING  DepartmentID=2;

-- Question 11: Lay ten nhan vien 'D%o'
SELECT Fullname FROM Account
WHERE SUBSTRING_INDEX(FullName,' ',-1) LIKE 'D%o';

-- Question 12: Xoa tat ca Exam tao truoc 20/12/2019
DELETE FROM Exam
WHERE CreateDate <'2019-12-20';

-- Question 13: Xoa Question bat dau bang tu 'Câu hỏi'
DELETE FROM Question
WHERE Content LIKE n'Câu hỏi%';

-- Question UPdate thong tin Account
UPDATE Account
SET Fullname=N'Nguyễn Bá Lộc', Email='loc.nguyenba@vti.com.vn'
WHERE AccountID=5;

-- Question 15: Update AccountID=5 thuoc groupid=4
UPDATE GroupAccount
SET GroupID=4
WHERE AccountID=5;



