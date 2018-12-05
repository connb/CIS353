SPOOL companyDML-a.out
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: < ***** Brandon Conn ***** >
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/

SELECT	 Ssn, Lname
FROM	 Employee
WHERE	 Super_ssn IS NULL OR
         Lname LIKE '%a%' AND
         Lname LIKE '%a%'
ORDER BY Ssn;

/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/

SELECT	 E.Ssn, E.Lname, P.Pnumber, P.Pname, W.Hours
FROM	 Employee E, Project P, Works_on W
WHERE	 W.Hours > 30 AND
         W.Essn = E.Ssn AND
         W.Pno = P.Pnumber
ORDER BY Ssn;

/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/

SELECT	 E.Lname, E.Dno, W.Pno, P.Pnumber, P.Dnum
FROM	 Employee E, Project P, Works_on W
WHERE	 P.Dnum != E.Dno AND
         W.pno = P.Pnumber AND
         E.Ssn = W.Essn
ORDER BY Lname;

/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/

SELECT	 distinct E.Ssn, E.Lname, W.Pno, P.Plocation, P.Dnum, P.Plocation
FROM	 Employee E, Project P, Works_on W, Dept_locations D
WHERE	 P.Dnum = E.Dno AND
	 W.Hours > 20 AND
         W.pno = P.Pnumber AND
         E.Ssn = W.Essn AND
         D.Dlocation = P.Plocation
ORDER BY Lname;

/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/

SELECT	 E1.Ssn, E1.Lname, E1.Salary, E2.Ssn, E2.Lname, E2.Salary
FROM	 Employee E1, Employee E2
WHERE	 E1.Super_ssn = E2.ssn AND
	 E1.Salary < E2.Salary*0.70
ORDER BY E1.Ssn;

/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/

SELECT    E1.Lname, W1.Pno, E2.Lname, W2.Pno, P.Plocation
FROM      Employee E1, Employee E2, Works_On W1, Works_On W2, Project P
WHERE     E1.Ssn = W1.Essn AND
          E2.Ssn = W2.Essn AND
          E1.Ssn > E2.Ssn AND
          W1.Pno = W2.Pno AND
          W1.Pno = P.Pnumber AND
          P.PLocation = 'Houston'
ORDER BY  E1.Lname; 

/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 

SELECT	 E.Ssn, E.Lname, SUM(W.Hours)
FROM	 Employee E, Works_on W
WHERE	 E.Ssn = W.Essn
GROUP BY E.Ssn, E.Lname
HAVING   SUM(W.Hours) < 40
ORDER BY Lname;

/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 

SELECT    P.Pnumber, P.Pname, COUNT(*), SUM(W1.Hours)
FROM      Employee E1, Employee E2, Works_On W1, Works_On W2, Project P
WHERE     E1.Ssn = W1.Essn AND
          E2.Ssn = W2.Essn AND
          E1.Ssn > E2.Ssn AND
          W1.Pno = W2.Pno AND
          W1.Pno = P.Pnumber
GROUP BY  P.Pnumber, P.Pname
HAVING    COUNT(*) > 2
ORDER BY  P.Pnumber;

/*(18A)
For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
*/



--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
-- <<< Your SQL code goes here >>>
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/

SELECT   E.Ssn, E.Lname
FROM     Employee E
WHERE    NOT EXISTS ((SELECT P.Pnumber
		     FROM Project P
		     WHERE P.Plocation = 'Stafford')
		   MINUS
		    (SELECT P.Pnumber
		     FROM Works_on W, Project P
		     WHERE W.Pno = P.Pnumber AND
		           W.Essn = E.Ssn AND
		           P.Plocation = 'Stafford'))
ORDER BY Lname;

SET ECHO OFF
SPOOL OFF

