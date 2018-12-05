SET ECHO ON 
-- Show my schema objects
--
-- TABLES AND VIEWS
select table_name from user_tables;
select view_name from user_views;
--
PAUSE press ENTER to continue
--
-- CONSTRAINTS
SELECT table_name, constraint_name
FROM user_constraints
ORDER BY table_name, constraint_name;
--
PAUSE press ENTER to continue
--
-- PROCEDURES
SELECT procedure_name FROM user_procedures;
--
PAUSE press ENTER to continue
--
-- TRIGGERS
SELECT trigger_name FROM user_triggers;
--
PAUSE press ENTER to continue
--
-- Show the database instance
SELECT * FROM Sailors;
SELECT * FROM Boats;
SELECT * FROM Reservations;
SELECT * FROM LazySailors;
SET ECHO OFF

