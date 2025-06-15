use pj;

CREATE LOGIN cyber WITH PASSWORD = '12345678';



select* from Userr;



SELECT 
    cs.title AS case_title,
    c.name AS criminal_name,
    a.aliase_name
FROM 
    Case_Criminals cc
JOIN 
    Criminals c ON cc.criminal_id = c.criminal_id
LEFT JOIN 
    Criminal_Aliases a ON c.criminal_id = a.criminal_id
JOIN 
    Cases cs ON cs.case_id = cc.case_id;



	SELECT 
  V.victim_id,
  V.name AS victim_name,
  V.contact_info,
  V.type AS victim_type,
  C.case_id,
  C.title AS case_title,
  C.description AS case_description,
  C.date_reported,
  C.status AS case_status
FROM 
  Victim V
LEFT JOIN 
  Case_Victims CV ON V.victim_id = CV.victim_id
LEFT JOIN 
  Cases C ON CV.case_id = C.case_id
WHERE 
  V.victim_id = 2;

  select*from criminals;


  SELECT * FROM Charges;
  SELECT * FROM Offenses
  SELECT * FROM Reports
  Select *FROM Case_Offenses;

  delete from criminals
  where criminal_id=14;



  -- 1. LOGIN CHECK
SELECT * FROM Userr WHERE UserName = 1 AND Password = 1;

-- 2. FETCH CRIMINAL DETAILS (JOINED DATA)
SELECT 
    c.criminal_id,
    c.name AS criminal_name,
    c.date_of_birth,
    c.nationality,
    c.known_address_street,
    c.known_address_city,
    c.known_address_postal_code,
    a.aliase_name,
    cs.case_id,
    cs.title AS case_title,
    cs.description AS case_description,
    cs.date_reported,
    cs.status AS case_status
FROM 
    Case_Criminals cc
JOIN 
    Criminals c ON cc.criminal_id = c.criminal_id
LEFT JOIN 
    Criminal_Aliases a ON c.criminal_id = a.criminal_id
JOIN 
    Cases cs ON cs.case_id = cc.case_id
WHERE 
    c.criminal_id = 1;

-- 3. INSERT INTO CRIMINALS
INSERT INTO Criminals (criminal_id, name, date_of_birth, nationality, known_address_street, known_address_city, known_address_postal_code)
VALUES (1, 1, 1, 1, 1, 1, 1);

-- 4. INSERT INTO CRIMINAL_ALIASES (if alias info exists)
INSERT INTO Criminal_Aliases (alias_id, criminal_id, aliase_name)
VALUES (1, 1, 1);

-- 5. FETCH VICTIM DETAILS (JOINED DATA)
SELECT 
    V.victim_id,
    V.name AS victim_name,
    V.contact_info,
    V.type AS victim_type,
    CV.case_id
FROM 
    Victim V
JOIN 
    Case_Victims CV ON V.victim_id = CV.victim_id
WHERE 
    V.victim_id = 1;

-- 6. FETCH CHARGES & OFFENSES ASSOCIATED WITH A CASE
SELECT 
    ch.charge_id,
    ch.charge_type,
    ch.description AS charge_description,
    ch.date_filed,
    o.offense_id,
    o.offense_type,
    o.description AS offense_description,
    o.law_section
FROM 
    Charges ch
LEFT JOIN 
    Offenses o ON ch.offense_id = o.offense_id
WHERE 
    ch.case_id = 1;

-- 7. FETCH REPORT DETAILS
SELECT 
    report_id,
    title,
    content,
    submitted_by,
    submission_date
FROM 
    Reports
WHERE 
    case_id = 1;



	SELECT * FROM Case_Criminals WHERE criminal_id = 12;


	SELECT 
    c.criminal_id,
    c.name AS criminal_name,
    c.date_of_birth,
    c.nationality,
    c.known_address_street,
    c.known_address_city,
    c.known_address_postal_code,
    a.aliase_name,
    cs.title AS case_title
FROM 
    Criminals c
LEFT JOIN 
    Criminal_Aliases a ON c.criminal_id = a.criminal_id
LEFT JOIN 
    Case_Criminals cc ON c.criminal_id = cc.criminal_id
LEFT JOIN 
    Cases cs ON cc.case_id = cs.case_id
WHERE 
    c.criminal_id = 6;

SELECT * FROM Case_Criminals WHERE criminal_id = 6;




SELECT 
    v.victim_id,
    v.name AS victim_name,
    v.contact_info,
    v.type AS victim_type,
    c.title AS case_title
FROM 
    Victim v
LEFT JOIN 
    Case_Victims cv ON v.victim_id = cv.victim_id
LEFT JOIN 
    Cases c ON cv.case_id = c.case_id
WHERE 
    v.victim_id = 6;  -- or whichever victim you're testing


	SELECT 
    c.criminal_id, c.name AS criminal_name,
    cc.case_id, cs.title AS case_title
FROM 
    Criminals c
LEFT JOIN 
    Case_Criminals cc ON c.criminal_id = cc.criminal_id
LEFT JOIN 
    Cases cs ON cc.case_id = cs.case_id
WHERE 
    c.criminal_id <= 10;




	SELECT * FROM Access_Log