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
			
-- Question 9: Th???ng k?? s??? l?????ng account trong m???i group
SELECT		G.GroupID, COUNT(GA.AccountID) AS 'SO LUONG'
FROM		GroupAccount GA 
RIGHT JOIN 	`Group` G ON	GA.GroupID = G.GroupID
GROUP BY	G.GroupID
ORDER BY	G.GroupID ASC;

-- Question 10: T??m ch???c v??? c?? ??t ng?????i nh???t
SELECT 		P.PositionID, P.PositionName, COUNT(A.PositionID) AS 'SO LUONG'
FROM		Position P 
INNER JOIN 	`Account` A ON P.PositionID = A.PositionID
GROUP BY 	P.PositionID
HAVING		COUNT(A.PositionID)	=	(SELECT 	MIN(CountP)
									 FROM		(SELECT 	COUNT(P.PositionID) AS CountP
												FROM		Position P 
												INNER JOIN 	`Account` A ON P.PositionID = A.PositionID		
												GROUP BY	P.PositionID) AS MinCountP);

-- Question 11: th???ng k?? m???i ph??ng ban c?? bao nhi??u dev, test, scrum master, PM

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

-- Question 12: L???y th??ng tin chi ti???t c???a c??u h???i bao g???m: th??ng tin c?? b???n c???a question, lo???i c??u h???i, ai l?? ng?????i t???o ra c??u h???i, c??u tr??? l???i l?? g??, ???
SELECT 		T.TypeName AS 'LOAI CAU HOI', Q.CreatorID AS 'ID NGUOI TAO', Q.Content AS 'CAU HOI', A.Content AS 'CAU TRA LOI', Q.CreateDate AS 'NGAY TAO'
FROM		Question Q 
INNER JOIN 	Answer A ON	Q.QuestionID = A.QuestionID
INNER JOIN	TypeQuestion T ON Q.TypeID = T.TypeID;

-- Question 13: l???y ra s??? l?????ng c??u h???i c???a m???i lo???i t??? lu???n hay tr???c nghi???m
SELECT		T.TypeName AS 'LOAI CAU HOI', COUNT(Q.TypeID) AS 'SO LUONG'
FROM		Question Q 
INNER JOIN 	TypeQuestion T ON Q.TypeID = T.TypeID
GROUP BY	Q.TypeID;

-- Question 14: l???y ra group kh??ng c?? account n??o
SELECT 		DISTINCT G.GroupName
FROM 		`Group` G
LEFT JOIN 	GroupAccount GA ON G.GroupID = GA.GroupID
WHERE 		GA.AccountID IS NULL;

-- Question 15: l???y ra group kh??ng c?? account n??o
SELECT		*
FROM		`Group` 
WHERE		GroupID  NOT IN	(SELECT		GroupID
							 FROM		GroupAccount);
                    
-- Question 16: l???y ra question kh??ng c?? answer n??o 
SELECT		*
FROM		Question
WHERE		QuestionID NOT IN (SELECT	QuestionID
							   From		Answer);
                        
-- Question 17:
-- a) L???y c??c account thu???c nh??m th??? 1
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 1;

-- b) L???y c??c account thu???c nh??m th??? 3
SELECT 		A.FullName
FROM 		`Account` A
JOIN 		GroupAccount GA ON A.AccountID = GA.AccountID
WHERE 		GA.GroupID = 3;

-- c) Gh??p 2 k???t qu??? t??? c??u a) v?? c??u b) sao cho kh??ng c?? record n??o tr??ng nhau
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
-- a) L???y c??c group c?? l???n h??n b???ng 3 th??nh vi??n 
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong >= 3;

-- b) L???y c??c group c?? nh??? h??n 7 th??nh vi??n 
SELECT 		G.GroupName, COUNT(1) AS so_luong
FROM 		`Group` G
JOIN 		GroupAccount GA ON G.GroupID = GA.GroupID
GROUP BY	GA.GroupID
HAVING 		so_luong <= 7;

-- c) Gh??p 2 k???t qu??? t??? c??u a) v?? c??u b) 
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







