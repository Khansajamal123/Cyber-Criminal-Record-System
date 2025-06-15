CREATE DATABASE PJ;

use PJ;

CREATE TABLE Userr (
    userr_id INT PRIMARY KEY,
    UserName VARCHAR(100),
    Password VARCHAR(100)
  
);
INSERT INTO Userr VALUES
(1, 'admin_cyber', 'pass123');
SELECT * FROM Userr


CREATE USER cyber FOR LOGIN cyber;
GO

GRANT SELECT, DELETE ON userr TO cyber;
GO



CREATE TABLE Criminals (
    criminal_id INT PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    nationality VARCHAR(50),
    known_address_street VARCHAR(100),
    known_address_city VARCHAR(50),
    known_address_postal_code VARCHAR(20)
);
INSERT INTO Criminals VALUES
(1, 'Kevin Mitnick', '1963-08-06', 'American', '123 Sunset Blvd', 'Los Angeles', '90001'),
(2, 'Albert Gonzalez', '1981-01-18', 'American', '456 Ocean Ave', 'Miami', '33101'),
(3, 'Gary McKinnon', '1966-02-10', 'British', '789 Sky Rd', 'London', 'EC1A'),
(4, 'Evgeniy Bogachev', '1983-10-28', 'Russian', '12 Red Square', 'Moscow', '101000'),
(5, 'Jeanson James Ancheta', '1985-03-20', 'American', '135 Hacker Ln', 'San Diego', '92101'),
(6, 'Adrian Lamo', '1981-02-20', 'American', '65 Code St', 'New York', '10001'),
(7, 'Max Butler', '1972-07-10', 'American', '49 Breach Rd', 'San Francisco', '94101'),
(8, 'Kristina Svechinskaya', '1989-02-16', 'Russian', '9 Digital Way', 'St. Petersburg', '190000'),
(9, 'Matthew Bevan', '1974-06-10', 'British', '88 Airbase Ct', 'Cardiff', 'CF10'),
(10, 'Lauri Love', '1985-12-14', 'British', '21 Freedom Dr', 'Suffolk', 'IP4');
SELECT * FROM Criminals


CREATE TABLE Criminal_Aliases (
    aliase_id INT PRIMARY KEY,
    criminal_id INT FOREIGN KEY REFERENCES Criminals(criminal_id),
    aliase_name VARCHAR(100)
);
INSERT INTO Criminal_Aliases VALUES
(1, 1, 'Condor'),
(2, 2, 'soupnazi'),
(3, 3, 'Solo'),
(4, 4, 'lucky12345'),
(5, 5, 'Resilient'),
(6, 6, 'The Homeless Hacker'),
(7, 7, 'Iceman'),
(8, 8, 'Money Mule Queen'),
(9, 9, 'Kuji'),
(10, 10, 'nsh');
SELECT * FROM Criminal_Aliases



CREATE TABLE Cases (
    case_id INT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    date_reported DATE,
    status VARCHAR(50)
);
INSERT INTO Cases VALUES
(1, 'Target Data Breach', 'Massive breach of credit card info', '2013-12-15', 'Closed'),
(2, 'Sony Hack', 'Hack by Guardians of Peace', '2014-11-24', 'Closed'),
(3, 'Equifax Breach', '143M records stolen', '2017-09-07', 'Closed'),
(4, 'Facebook Data Leak', 'Cambridge Analytica scandal', '2018-03-17', 'Closed'),
(5, 'Yahoo Account Theft', '3B accounts breached', '2016-12-14', 'Closed'),
(6, 'WannaCry Ransomware', 'Global attack affecting NHS', '2017-05-12', 'Closed'),
(7, 'Home Depot Hack', 'Credit card data breach', '2014-09-08', 'Closed'),
(8, 'LinkedIn Leak', 'Password dump on hacker forums', '2012-06-05', 'Closed'),
(9, 'JPMC Hack', 'Data breach of 83 million accounts', '2014-08-25', 'Closed'),
(10, 'Dropbox Leak', '68M passwords leaked', '2016-08-31', 'Closed');
SELECT * FROM Cases


CREATE TABLE Case_Criminals (
    case_id INT,
    criminal_id INT,
    PRIMARY KEY (case_id, criminal_id),
    FOREIGN KEY (case_id) REFERENCES Cases(case_id),
    FOREIGN KEY (criminal_id) REFERENCES Criminals(criminal_id)
);
INSERT INTO Case_Criminals VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
SELECT * FROM Case_Criminals

INSERT INTO Case_Criminals VALUES
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);



GRANT SELECT, DELETE,INSERT ON Case_Criminals TO cyber;
GO
GRANT SELECT, DELETE,INSERT ON Cases TO cyber;
GO
GRANT SELECT, DELETE,INSERT ON Criminal_Aliases TO cyber;
GO
GRANT SELECT, DELETE,INSERT ON Criminals TO cyber;
GO

CREATE TABLE Victim (
    victim_id INT PRIMARY KEY,
    name VARCHAR(100),
    contact_info VARCHAR(150),
    type VARCHAR(50)
);
INSERT INTO Victim VALUES
(1, 'Target Corporation', 'support@target.com', 'Corporation'),
(2, 'Sony Pictures', 'security@sony.com', 'Corporation'),
(3, 'John Smith', 'johnsmith@gmail.com', 'Individual'),
(4, 'Facebook Inc.', 'info@facebook.com', 'Corporation'),
(5, 'Yahoo!', 'help@yahoo.com', 'Corporation'),
(6, 'Equifax', 'legal@equifax.com', 'Corporation'),
(7, 'U.S. Government', 'usgov@gov.us', 'Government'),
(8, 'NHS UK', 'admin@nhs.uk', 'Government'),
(9, 'Home Depot', 'admin@homedepot.com', 'Corporation'),
(10, 'LinkedIn', 'security@linkedin.com', 'Corporation');
SELECT * FROM Victim

drop table Case_Victims;
CREATE TABLE Case_Victims (
    case_id INT,
    victim_id INT,
    PRIMARY KEY (case_id, victim_id),
    FOREIGN KEY (case_id) REFERENCES Cases(case_id),
    FOREIGN KEY (victim_id) REFERENCES Victim(victim_id)
);
INSERT INTO Case_Victims VALUES
(1, 1),
(2, 2),
(3, 6),
(4, 4),
(5, 5);
SELECT * FROM Case_Victims


INSERT INTO Case_Victims VALUES
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


GRANT SELECT, DELETE ON Case_Victims TO cyber;
GO
GRANT SELECT, DELETE ON Victim TO cyber;
GO

DROP TABLE IF EXISTS Reports;

CREATE TABLE Reports (
    report_id INT PRIMARY KEY,
    case_id INT FOREIGN KEY REFERENCES Cases(case_id),
    userr_id INT FOREIGN KEY REFERENCES Userr(userr_id),
    report_content TEXT,
    date_created DATETIME,
    status VARCHAR(50)
);

INSERT INTO Reports VALUES
(1, 1, 1, 'Detailed report of Target data breach', '2013-12-16', 'Reviewed'),
(2, 2, 1, 'Sony hack details documented', '2014-11-25', 'Closed'),
(3, 3, 1, 'Equifax breach incident filed', '2017-09-08', 'Investigated'),
(4, 4, 1, 'Facebook data misuse reported', '2018-03-18', 'Under Review'),
(5, 5, 1, 'Yahoo accounts breach summary', '2016-12-15', 'Reviewed'),
(6, 6, 1, 'NHS ransomware event submitted', '2017-05-13', 'Closed'),
(7, 7, 1, 'Home Depot case details', '2014-09-09', 'Closed'),
(8, 8, 1, 'LinkedIn password leak report', '2012-06-06', 'Closed'),
(9, 9, 1, 'JPMC attack reviewed', '2014-08-26', 'Reviewed'),
(10, 10, 1, 'Dropbox credentials leak', '2016-09-01', 'Closed');


SELECT * FROM Reports

DROP TABLE IF EXISTS Charges;

CREATE TABLE Charges (
    report_id INT PRIMARY KEY,
    case_id INT,
    userr_id INT,
    report_content TEXT,
    date_created DATETIME,
    FOREIGN KEY (case_id) REFERENCES Cases(case_id),
    FOREIGN KEY (userr_id) REFERENCES Userr(userr_id)
);

INSERT INTO Charges VALUES
(1, 1, 1, 'Target case breach and data theft', '2013-12-16'),
(2, 2, 1, 'Sony case charges of cyber intrusion', '2014-11-25'),
(3, 3, 1, 'Equifax security negligence', '2017-09-08'),
(4, 4, 1, 'Facebook case charges on privacy violations', '2018-03-18'),
(5, 5, 1, 'Yahoo breach cybercrime act violation', '2016-12-15'),
(6, 6, 1, 'WannaCry ransomware act offense', '2017-05-13'),
(7, 7, 1, 'Data breach of Home Depot', '2014-09-09'),
(8, 8, 1, 'LinkedIn credential leak complaint', '2012-06-06'),
(9, 9, 1, 'JPMC mass data breach', '2014-08-26'),
(10, 10, 1, 'Dropbox security breach charge', '2016-09-01');

SELECT * FROM Charges





-- Already Correct:
CREATE TABLE Offenses (
    offense_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    cyber_law_section VARCHAR(50)
);

-- Already Valid Inserts:
INSERT INTO Offenses VALUES
(1, 'Phishing', 'Deceiving users to obtain sensitive data', 'Section 66D'),
(2, 'Hacking', 'Unauthorized access to systems', 'Section 66'),
(3, 'Data Theft', 'Stealing user data without consent', 'Section 43'),
(4, 'Cyber Terrorism', 'Disrupting systems to threaten sovereignty', 'Section 66F'),
(5, 'Identity Theft', 'Using personal information fraudulently', 'Section 66C'),
(6, 'Ransomware Attack', 'Encrypting files for ransom', 'Section 66'),
(7, 'Financial Fraud', 'Digital transactions scam', 'Section 66D'),
(8, 'Cyber Stalking', 'Tracking someone online', 'Section 66A'),
(9, 'Malware Distribution', 'Spreading malicious software', 'Section 65'),
(10, 'Social Engineering', 'Manipulating people for confidential data', 'Section 66');

SELECT * FROM Offenses

GRANT SELECT, DELETE ON Offenses TO cyber;
GO

GRANT SELECT, DELETE ON Charges TO cyber;
GO

GRANT SELECT, DELETE ON Reports TO cyber;
GO


CREATE TABLE Case_Offenses (
    case_id INT,
    offense_id INT,
    PRIMARY KEY (case_id, offense_id),
    FOREIGN KEY (case_id) REFERENCES Cases(case_id),
    FOREIGN KEY (offense_id) REFERENCES Offenses(offense_id)
);
INSERT INTO Case_Offenses VALUES
(1, 3),
(2, 2),
(3, 5),
(4, 10),
(5, 1);
SELECT * FROM Case_Offenses

GRANT SELECT, DELETE ON Case_Offenses TO cyber;
GO

CREATE TABLE Access_Log (
    log_id INT PRIMARY KEY,
    userr_id INT FOREIGN KEY REFERENCES Userr(userr_id),
    action VARCHAR(100),
    timestamp DATETIME,
    ip_address VARCHAR(50)
);


INSERT INTO Access_Log (log_id, userr_id, action, timestamp, ip_address) VALUES
(1, 1, 'Login Successful', '2025-06-14 08:45:00', '192.168.0.1'),
(2, 1, 'Viewed Criminal Record - ID: 3', '2025-06-14 08:47:15', '192.168.0.1'),
(3, 1, 'Viewed Victim Record - ID: 2', '2025-06-14 08:50:22', '192.168.0.1'),
(4, 1, 'Generated Report - Case ID: 4', '2025-06-14 08:52:30', '192.168.0.1'),
(5, 1, 'Deleted Criminal - ID: 5', '2025-06-14 09:00:05', '192.168.0.1'),
(6, 1, 'Logout', '2025-06-14 09:05:10', '192.168.0.1');

SELECT * FROM Access_Log


GRANT SELECT ON Access_Log TO cyber;
GO


