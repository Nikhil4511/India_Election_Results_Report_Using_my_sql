-- ==========================================
-- Project: India Election Results 2024 Analysis

-- Description: Complete SQL analysis of 2024 Indian General Election results
-- ==========================================

-- 🏗️ DATABASE SETUP
CREATE DATABASE IF NOT EXISTS india_election_result;
USE india_election_result;

-- ==========================================
-- TABLE STRUCTURE FIXES
-- ==========================================

ALTER TABLE constituencywise_results
MODIFY COLUMN `Parliament Constituency` VARCHAR(255) NOT NULL,
MODIFY COLUMN `Constituency ID` VARCHAR(100) NOT NULL,
ADD PRIMARY KEY (`Parliament Constituency`, `Constituency ID`);

ALTER TABLE statewise_results
MODIFY COLUMN `Parliament Constituency` VARCHAR(255) NOT NULL,
ADD PRIMARY KEY (`Parliament Constituency`);

ALTER TABLE states
MODIFY COLUMN `State ID` VARCHAR(255) NOT NULL,
ADD PRIMARY KEY (`State ID`);

-- ==========================================
-- DATA EXPLORATION
-- ==========================================
SHOW TABLES;
SELECT COUNT(DISTINCT `Parliament Constituency`) AS total_constituencies FROM constituencywise_results;

-- ==========================================
-- TOTAL SEATS PER STATE
-- ==========================================
SELECT
  s.State AS state_name,
  COUNT(DISTINCT cr.`Parliament Constituency`) AS total_seat
FROM
  constituencywise_results cr
  INNER JOIN statewise_results sr ON cr.`Parliament Constituency` = sr.`Parliament Constituency`
  INNER JOIN states s ON sr.State = s.State
GROUP BY s.State
ORDER BY total_seat DESC;

-- ==========================================
-- ALLIANCE CLASSIFICATION
-- ==========================================
ALTER TABLE partywise_results ADD COLUMN Alliance VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;

-- NDA ALLIANCE
UPDATE partywise_results
SET Alliance = 'NDA'
WHERE Party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);

-- I.N.D.I.A. ALLIANCE
UPDATE partywise_results
SET Alliance = 'I.N.D.I.A'
WHERE Party IN (
    'Indian National Congress - INC',
    'Samajwadi Party - SP',
    'Trinamool Congress - AITC',
    'Rashtriya Janata Dal - RJD',
    'Dravida Munnetra Kazhagam - DMK',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Nationalist Congress Party (Sharadchandra Pawar) - NCPSP',
    'Jharkhand Mukti Morcha - JMM',
    'Aam Aadmi Party - AAAP',
    'Communist Party of India (Marxist) - CPI(M)',
    'Communist Party of India - CPI',
    'Indian Union Muslim League - IUML',
    'Viduthalai Chiruthaigal Katchi - VCK',
    'Kerala Congress - KC',
    'Rashtriya Loktantrik Party - RLTP',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Revolutionary Socialist Party - RSP',
    'Kerala Congress (Joseph) - KC(J)'
);

-- OTHER PARTIES
UPDATE partywise_results
SET Alliance = 'Others'
WHERE Alliance IS NULL;

-- ==========================================
-- ANALYTICAL QUERIES
-- ==========================================

-- 🧩 Total Seats by Alliance
SELECT Alliance, SUM(Won) AS Total_Seats_Won
FROM partywise_results
GROUP BY Alliance;

-- 🧩 Total Seats by Party within Each Alliance
SELECT Alliance, Party, SUM(Won) AS Seats_Won
FROM partywise_results
GROUP BY Alliance, Party
ORDER BY Alliance, Seats_Won DESC;

-- 🏆 Winning Candidate and Margin for Specific Constituency
SELECT
    s.State AS State_Name,
    cr.`Parliament Constituency` AS Constituency_Name,
    cd.Candidate AS Winning_Candidate,
    cd.Party AS Party_Name,
    cd.Total_Votes,
    (cd.Total_Votes - (
        SELECT MAX(cd2.Total_Votes)
        FROM constituencywise_details cd2
        WHERE cd2.`Parliament Constituency` = cd.`Parliament Constituency`
          AND cd2.Candidate <> cd.Candidate
    )) AS Margin_of_Victory
FROM
    constituencywise_details cd
    INNER JOIN constituencywise_results cr ON cd.`Parliament Constituency` = cr.`Parliament Constituency`
    INNER JOIN states s ON cr.State_ID = s.State_ID
WHERE
    cd.Position = 1
    AND s.State = '<state_here>'
    AND cr.`Parliament Constituency` = '<constituency_here>';

-- 🥇 Winner and Runner-Up per Constituency in a State
SELECT
    s.State AS State_Name,
    cd.`Parliament Constituency` AS Constituency_Name,
    cd.Candidate AS Winning_Candidate,
    cd.Party AS Winning_Party,
    cd2.Candidate AS Runnerup_Candidate,
    cd2.Party AS Runnerup_Party,
    (cd.`Total Votes` - cd2.`Total Votes`) AS Margin_of_Victory
FROM
    constituencywise_details cd
    INNER JOIN constituencywise_details cd2 ON cd.`Parliament Constituency` = cd2.`Parliament Constituency`
    INNER JOIN constituencywise_results cr ON cd.`Parliament Constituency` = cr.`Parliament Constituency`
    INNER JOIN states s ON cr.State_ID = s.State_ID
WHERE
    cd.Position = 1
    AND cd2.Position = 2
    AND s.State = '<state_here>'
ORDER BY
    s.State, cd.`Parliament Constituency`;

-- 📊 EVM vs Postal Votes Distribution for Constituency
SELECT
    cd.`Parliament Constituency` AS Constituency_Name,
    cd.Candidate,
    cd.Party,
    cd.`EVM Votes`,
    cd.`Postal Votes`,
    cd.`Total Votes`
FROM
    constituencywise_details cd
WHERE
    cd.`Parliament Constituency` = '<constituency_here>'
ORDER BY
    cd.`Total Votes` DESC;
