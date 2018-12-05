/*
Author: JRA 
CREDITS: The SailorsDB is a significant extension of the one that appears
in Ramakrishnan and Gehrke's book. I have added several extensions in order
to demonstrate important SQL features.
*/
-- CREATING THE TABLES
-- --------------------------------------------------------------------
CREATE TABLE  Sailors
(
sid     INTEGER,
sname   CHAR(15)    NOT NULL, 
rating  INTEGER     NOT NULL,
age     NUMBER(4,1) NOT NULL,
trainee INTEGER,    /*Some sailor(s) don't train anybody*/
--
-- sIC1: Sailor Ids are unique
CONSTRAINT sIC1 PRIMARY KEY (sid),
-- sIC2: Every trainee must be a sailor too.
CONSTRAINT sIC2 FOREIGN KEY (trainee) REFERENCES Sailors(sid)
           ON DELETE SET NULL
           DEFERRABLE INITIALLY DEFERRED,
-- sIC3: The rating is between 1 and 15 (inclusive).
CONSTRAINT sIC3 CHECK (rating >= 1 AND rating <= 15)
-- sIC4: The rating of a trainee can't be higher than his/her trainer.
-- Not implemented here. See class notes on SQL/DDL - ASSERTIONs.
);
-- -------------------------------------------------------------------
CREATE TABLE  Boats
(
bid         INTEGER,
bname       CHAR(15)  NOT NULL,
color       CHAR(10)  NOT NULL, 
rate        INTEGER   NOT NULL,
length      INTEGER   NOT NULL,
logKeeper   INTEGER   NOT NULL,
-- bIC1: Boat Ids are unique.
CONSTRAINT bIC1 PRIMARY KEY (bid),
-- bIC2: No two boats can have the same name and color.
CONSTRAINTS bIC2 UNIQUE (bname, color),
-- bIC3: A boat color can be blue, red, green, or white only
CONSTRAINT bIC3 CHECK (color IN ('blue', 'red', 'green', 'white')),
-- bIC4: The rate for a boat of >=30 ft length must be >= $300
CONSTRAINT bIC4 CHECK (NOT (length >= 30 AND rate < 300))
-- bIC5: A logKeeper must be a trainee.
--       Not implemented here. See class notes on SQL/DDL - ASSERTIONs.
);
-- --------------------------------------------------------------------
CREATE TABLE  Reservations
(
bid      INTEGER,
forDate  DATE,
sid      INTEGER  NOT NULL,
onDate   DATE     NOT NULL,
--
-- rIC1: A boat can't be reserved more than once for the same date.
CONSTRAINT rIC1 PRIMARY KEY (bid, forDate),
-- rIC2: A sailor can't have more than one reservation for the same date.
CONSTRAINT rIC2 UNIQUE (sid, forDate),
-- rIC3: Only sailors can reserve boats
CONSTRAINT rIC3 FOREIGN KEY (sid) REFERENCES Sailors(sid)
            ON DELETE CASCADE
            DEFERRABLE INITIALLY DEFERRED,
-- rIC4: A reserved boat must actually exist.
--       Question: SET NULL below is accepted! But will it be enforced?
CONSTRAINT rIC4 FOREIGN KEY (bid) REFERENCES Boats(bid)
                ON DELETE SET NULL
                DEFERRABLE INITIALLY DEFERRED, 
-- rIC5: The date for a reservation must be later than the date it is made on.
CONSTRAINT rIC5 CHECK (forDate > onDate)
-- rIC6: To make a reservation, a sailor's rating must be above 5.
--       Not implemented here. See class notes on SQL/DDL - ASSERTIONs.
);
-- ------------------------------------------------------------------
-- A view containing sailors who don't have reservations
CREATE VIEW  LazySailors AS
    SELECT  sid, sname, rating
    FROM    Sailors
    WHERE   sid NOT IN (SELECT sid FROM Reservations);
-- --------------------------------------------------------------------
-- POPULATING THE DATABASE INSTANCE
-- --------------------------------------------------------------------
INSERT INTO Reservations VALUES (101, TO_DATE('10/10/12', 'MM/DD/YY'),
                                  22, TO_DATE('10/07/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (102, TO_DATE('10/14/12', 'MM/DD/YY'),
                                  22, TO_DATE('10/10/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (103, TO_DATE('11/17/12', 'MM/DD/YY'),
                                  22, TO_DATE('10/10/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (105, TO_DATE('10/14/12', 'MM/DD/YY'),
                                  58, TO_DATE('10/13/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (102, TO_DATE('10/20/12', 'MM/DD/YY'),
                                  31, TO_DATE('10/10/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (103, TO_DATE('11/22/12', 'MM/DD/YY'),
                                  31, TO_DATE('10/20/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (104, TO_DATE('11/23/12', 'MM/DD/YY'),
                                  31, TO_DATE('10/20/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (101, TO_DATE('09/05/12', 'MM/DD/YY'),
                                  64, TO_DATE('08/27/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (102, TO_DATE('11/20/12', 'MM/DD/YY'),
                                  64, TO_DATE('11/03/12', 'MM/DD/YY'));
INSERT INTO Reservations VALUES (103, TO_DATE('10/18/12', 'MM/DD/YY'),
                                  74, TO_DATE('08/04/12', 'MM/DD/YY'));
-- --------------------------------------------------------------------
INSERT INTO Sailors VALUES (22, 'Dave', 7, 45.0, 85);
INSERT INTO Sailors VALUES (29, 'Mike', 1, 33.0,NULL);
INSERT INTO Sailors VALUES (31, 'Mary', 8, 55.0, 85);
INSERT INTO Sailors VALUES (32, 'Albert', 8, 25.0, 31);
INSERT INTO Sailors VALUES (58, 'Jim', 10, 35.0, 32);
INSERT INTO Sailors VALUES (64, 'Jane', 7, 35.0, 22);
INSERT INTO Sailors VALUES (71, 'Dave', 10, 16.0, 32);
INSERT INTO Sailors VALUES (74, 'Jane', 9, 40.0, 95);
INSERT INTO Sailors VALUES (85, 'Art', 3, 25.0, 29);
INSERT INTO Sailors VALUES (95, 'Jane', 3, 63.0, NULL);
-- --------------------------------------------------------------------
INSERT INTO Boats VALUES (101,'Interlake', 'blue', 350, 30, 95);
INSERT INTO Boats VALUES (102, 'Interlake', 'red', 275, 23, 22);
INSERT INTO Boats VALUES (103, 'Clipper', 'green', 160, 15, 85);
INSERT INTO Boats VALUES (104, 'Marine', 'red', 195, 24, 22);
INSERT INTO Boats VALUES (105, 'Weekend Rx', 'white', 500, 43, 31);
INSERT INTO Boats VALUES (106, 'C#', 'red', 300, 27, 32);
INSERT INTO Boats VALUES (107, 'Bayside', 'white', 350, 32, 85);
INSERT INTO Boats VALUES (108, 'C++', 'blue', 100, 12, 95);
-- --------------------------------------------------------------------
-- Now, if no violations were detected, COMMIT all the commands in this file
COMMIT;