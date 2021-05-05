/*----------Query----------*/

-- Question 1: Lay danh sach thong tin phong ban nhan vien
SELECT A.Fullname, A.DepartmentID, D.DepartmentName FROM Account A
INNER JOIN Department AS D ON A.DepartmentID=D.DepartmentID;

-- Question 2: Lay Account sau ngay 20/12/2010
SELECT * FROM Account
WHERE CreateDate > '2010-12-20';

--Question 3: Lay ra tat ca Dev
SELECT * FROM Position P
INNER JOIN Account A ON P.PositionID=A.PositionID
WHERE PositionName='Dev';

-- Question 4: Lay danh sach phong ban >3 nhan vien
SELECT D.DepartmentID, DepartmentName From Department D
INNER JOIN Account AS A ON D.DepartmentID=A.DepartmentID
GROUP BY D.DepartmentID
HAVING COUNT(D.DepartmentID)>3;

-- *Question 5: Lay cau hoi su dung nhieu nhat trong Exam
SELECT EQ.QuestionID,Count(EQ.QuestionID) AS t,EQ.ExamID, Q.Content,Q.TypeID,Q.CategoryID,Q.CreateDate FROM ExamQuestion EQ
INNER JOIN Question AS Q ON EQ.QuestionID=Q.QuestionID
INNER  JOIN Exam AS E ON EQ.ExamID=E.ExamID
GROUP BY EQ.QuestionID,Q.Content,Q.TypeID,Q.CategoryID,Q.CreateDate,EQ.ExamID
HAVING COUNT(EQ.QuestionID) = (SELECT MAX(Count(EQ.QuestionID)) FROM ExamQuestion )
--ORDER BY Q.QuestionID DESC LIMIT 3;

;


SELECT EQ.QuestionID,Q.Content FROM ExamQuestion EQ
INNER  JOIN Exam AS E ON EQ.ExamID=E.ExamID
INNER JOIN Question AS Q ON EQ.QuestionID=Q.QuestionID
GROUP BY EQ.QuestionID
HAVING COUNT(EQ.QuestionID) = (SELECT MAX(Count(EQ.QuestionID)) FROM ExamQuestion )
ORDER BY Q.QuestionID DESC 
;

-- Question 6: Thong ke so lan su dung categoryQ trong Question
SELECT Q.CategoryID,Count(Q.CategoryID) AS 'So lan su dung',C.CategoryName FROM Question Q
INNER JOIN CategoryQuestion AS C ON Q.CategoryID=C.CategoryID
GROUP BY Q.CategoryID;

-- Question 7: Thong ke moi Question su dung bao nhieu lan trong Exam
SELECT  Q.QuestionID,COUNT(EQ.QuestionID) AS 'Number Of Uses' FROM Question Q 
INNER JOIN ExamQuestion AS EQ ON Q.QuestionID=EQ.QuestionID
GROUP BY EQ.QuestionID;

--Question 8: Lay Question co nhieu cau tra loi nhat
SELECT 		Q.QuestionID, Q.Content, COUNT(A.QuestionID) AS 'SO LUONG'
FROM		Question Q 
INNER JOIN 	Answer A ON	Q.QuestionID = A.QuestionID
GROUP BY	A.QuestionID
HAVING		COUNT(A.QuestionID) =	(SELECT 	MAX(CountQ)
									 FROM		(SELECT 		COUNT(A.QuestionID) AS CountQ
												FROM			Answer A 
												RIGHT JOIN  Question Q ON A.QuestionID = Q.QuestionID 
												GROUP BY		A.QuestionID) AS MaxCountQ);
			
-- Question 9: Thống kê số lượng account trong mỗi group
SELECT		G.GroupID, COUNT(GA.AccountID) AS 'SO LUONG'
FROM		GroupAccount GA 
RIGHT JOIN 	`Group` G ON	GA.GroupID = G.GroupID
GROUP BY	G.GroupID
ORDER BY	G.GroupID ASC;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT 		P.PositionID, P.PositionName, COUNT(A.PositionID) AS 'SO LUONG'
FROM		Position P 
INNER JOIN 	`Account` A ON P.PositionID = A.PositionID
GROUP BY 	P.PositionID
HAVING		COUNT(A.PositionID)	=	(SELECT 	MIN(CountP)
									 FROM		(SELECT 	COUNT(P.PositionID) AS CountP
												FROM		Position P 
												INNER JOIN 	`Account` A ON P.PositionID = A.PositionID		
												GROUP BY	P.PositionID) AS MinCountP);

-- Question 11: thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM

SELECT 
    t1.DepartmentID,
    t1.PositionID,
    IF((t2.number_of_account IS NULL),
        0,
        t2.number_of_account) AS number_of_account
FROM
    (SELECT 
        d.DepartmentID, p.PositionID
    FROM
        `Department` d
    CROSS JOIN `Position` p
    WHERE
        p.PositionName IN ('Developer' , 'Tester', 'Scrum Master', 'Project Manager')
    ORDER BY d.DepartmentID , p.PositionID) AS t1
        LEFT JOIN
    (SELECT 
        d.DepartmentID,
            p.PositionID,
            COUNT(a.AccountID) AS number_of_account
    FROM
        `Position` p
    LEFT JOIN `Account` a ON p.PositionID = a.PositionID
    RIGHT JOIN `Department` d ON a.DepartmentID = d.DepartmentID
    WHERE
        p.PositionName IN ('Developer' , 'Tester', 'Scrum Master', 'Project Manager')
    GROUP BY d.DepartmentID , p.PositionID) AS t2 ON t1.DepartmentID = t2.DepartmentID
        AND t1.PositionID = t2.PositionID
GROUP BY t1.DepartmentID , t1.PositionID
ORDER BY t1.DepartmentID , t1.PositionID;

-----
SELECT A.DepartmentID,P.PositionName,COUNT(P.PositionName) FROM Account A
INNER JOIN Position AS P ON A.PositionID=P.PositionID
WHERE A.PositionID  in (2)

GROUP BY A.DepartmentID;
--HAVING COUNT(A.PositionName) = Count(A.PositionName) ;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT 		T.TypeName AS 'LOAI CAU HOI', Q.CreatorID AS 'ID NGUOI TAO', Q.Content AS 'CAU HOI', A.Content AS 'CAU TRA LOI', Q.CreateDate AS 'NGAY TAO'
FROM		Question Q 
INNER JOIN 	Answer A ON	Q.QuestionID = A.QuestionID
INNER JOIN	TypeQuestion T ON Q.TypeID = T.TypeID;

-- Question 13: lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT		T.TypeName AS 'LOAI CAU HOI', COUNT(Q.TypeID) AS 'SO LUONG'
FROM		Question Q 
INNER JOIN 	TypeQuestion T ON Q.TypeID = T.TypeID
GROUP BY	Q.TypeID;

-- Question 14: lấy ra group không có account nào
SELECT 		DISTINCT G.GroupName
FROM 		`Group` G
LEFT JOIN 	GroupAccount GA ON G.GroupID = GA.GroupID
WHERE 		GA.AccountID IS NULL;

-- Question 15: lấy ra group không có account nào
SELECT		*
FROM		`Group` 
WHERE		GroupID  NOT IN	(SELECT		GroupID
							 FROM		GroupAccount);
                    
-- Question 16: lấy ra question không có answer nào 
SELECT		*
FROM		Question
WHERE		QuestionID NOT IN (SELECT	QuestionID
							   From		Answer);
                        
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 1;

-- b) Lấy các account thuộc nhóm thứ 3
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 3;

-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 1
UNION
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 3;

-- Question 18: 
-- a) Lấy các group có lớn hơn bằng 3 thành viên 
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong >= 3;

-- b) Lấy các group có nhỏ hơn 7 thành viên 
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong <= 7;

-- c) Ghép 2 kết quả từ câu a) và câu b) 
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong >= 3
UNION
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong <= 7;







