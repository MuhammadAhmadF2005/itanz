--week3 sql project on student data--

-- a. View to show average score per student
CREATE VIEW student_average_scores AS
SELECT 
    s.student_id,
    s.name,
    AVG(qs.marks_obtained) AS average_score
FROM Students s
JOIN QuizScores qs ON s.student_id = qs.student_id
GROUP BY s.student_id, s.name;

-- b. View to show quiz-wise average scores
CREATE VIEW quiz_average_scores AS
SELECT 
    q.quiz_id,
    q.quiz_title,
    AVG(qs.marks_obtained) AS average_score
FROM Quizzes q
JOIN QuizScores qs ON q.quiz_id = qs.quiz_id
GROUP BY q.quiz_id, q.quiz_title;

-- Stored Procedure to get performance by student

DELIMITER $$

CREATE PROCEDURE GetStudentPerformance(IN input_student_id INT)
BEGIN
    SELECT 
        s.name,
        q.quiz_title,
        qs.marks_obtained,
        q.total_marks,
        ROUND((qs.marks_obtained / q.total_marks) * 100, 2) AS percentage
    FROM Students s
    JOIN QuizScores qs ON s.student_id = qs.student_id
    JOIN Quizzes q ON qs.quiz_id = q.quiz_id
    WHERE s.student_id = input_student_id;
END $$

DELIMITER ;

