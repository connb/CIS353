SET ECHO ON 
DROP TABLE Sailors CASCADE CONSTRAINTS;
DROP TABLE Boats CASCADE CONSTRAINTS;
DROP TABLE Reservations CASCADE CONSTRAINTS;
DROP VIEW LazySailors;
SET ECHO OFF
select table_name from user_tables;
select view_name from user_views;
