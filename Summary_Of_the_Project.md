# 🇮🇳 India Election Results 2024 – SQL Analysis  

##  Project Overview  
This project performs a **comprehensive SQL-based analysis** of the **2024 Indian General Election** results.  
It explores, cleans, and analyzes election data stored across multiple related tables — including party-wise, state-wise, and constituency-wise datasets — to draw key insights such as seat distribution, alliances, winning candidates, and voting patterns.  

---

##  Database & Table Setup  
The SQL script creates and prepares the database:  
- **Database:** `india_election_result`  
- **Tables Used:**  
  - `partywise_results`  
  - `statewise_results`  
  - `constituencywise_results`  
  - `constituencywise_details`  
  - `states`  

Primary keys and foreign key relationships are defined to ensure consistency.


##  Key Analysis Performed  

### 1️ **State-wise Seat Distribution**  
Counts how many constituencies exist in each state and how many seats were available for the election.  

### 2️ **Alliance Classification (NDA, I.N.D.I.A, Others)**  
Each party is grouped under one of three alliances:  
- **NDA** (e.g., BJP, JD(U), TDP, etc.)  
- **I.N.D.I.A.** (e.g., INC, SP, DMK, AITC, etc.)  
- **Others** (Independent or small regional parties)  

A new column `Alliance` is added and updated accordingly.

### 3️ **Seats Won by Alliances & Parties**  
Aggregate queries calculate:  
- Total seats won by each alliance  
- Total seats won by each party inside its alliance  

### 4️ **Winning Candidate & Margin of Victory**  
For any given state and constituency, retrieves:  
- Winning candidate  
- Party name  
- Total votes received  
- Margin of victory (difference between winner and runner-up)

### 5️ **Winner vs Runner-Up Comparison (State-wise)**  
Lists all constituencies in a state with both the winner and runner-up along with their vote difference.

### 6️ **EVM vs Postal Vote Analysis**  
Compares the number of **EVM votes** and **postal votes** for all candidates within a given constituency.

---

##  Tech Stack  
- **Database:** MySQL  
- **Language:** SQL  
- **Tools:** MySQL Workbench / phpMyAdmin  

---

##  How to Use  
1. Create the database:
   ```sql
   CREATE DATABASE india_election_result;
   USE india_election_result;
   ```
2. Import your CSV files into the respective tables.  
3. Run the queries from `india_election_analysis_clean.sql`.  
4. Modify placeholders like `<state_here>` or `<constituency_here>` to analyze specific regions.  

---

##  Insights You Can Derive  
- State-wise and alliance-wise dominance  
- Performance of NDA vs I.N.D.I.A. alliances  
- Close contests and large-margin victories  
- Regional voting trends via EVM vs Postal votes  

---

##  Conclusion  
This project showcases how **SQL can be used for real-world political data analysis**.  
It demonstrates data cleaning, aggregation, joining, and conditional logic — key skills for a **Data Analyst or SQL Developer** portfolio.  
