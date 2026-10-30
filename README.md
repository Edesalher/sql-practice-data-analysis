# SQL Practice for Data Analysis

A collection of hands-on **SQL Server (T-SQL)** exercises focused on building SQL querying skills and applying them to data analysis and business questions.

The practice uses **ChatGPT** and **Claude** as tutors to propose exercises and analytical questions, as well as to evaluate my SQL queries and conclusions.

## Purpose

This repository documents my progress toward becoming a **Data Analyst**, with an emphasis on using SQL not just to retrieve data, but also to answer questions and support data-informed decisions.

The repository has two stages of practice using the **Chinook sample database**: an initial 10-day program covering SQL fundamentals and intermediate techniques, followed by a second 10-day program focused on analytical thinking, interpreting results, and drawing meaningful conclusions.

## Database

The exercises use the **Chinook** sample database, available from the original project:

**Source:** [lerocha/chinook-database](https://github.com/lerocha/chinook-database)

I use the **SQL Server** version of Chinook. The database creation script is **not included** in this repository; download the appropriate SQL Server script from the source repository and follow its instructions to create the database locally.

## Repository structure

```text
sql-practice-data-analysis/
├── parte-1/
│   ├── dia_01.sql
│   ├── dia_02.sql
│   └── ...
├── parte-2/
│   ├── dia_01.sql
│   ├── dia_02.sql
│   └── ...
├── .gitignore
└── README.md
```

## Practice overview

### Part 1 — SQL foundations and intermediate querying

A 10-day practice program covering:

- `SELECT`, `WHERE`, `ORDER BY`, `TOP`, and `DISTINCT`
- Filtering with `AND`, `OR`, `IN`, `BETWEEN`, `LIKE`, and `NULL`
- Aggregate functions, `GROUP BY`, and `HAVING`
- Joins and subqueries
- `CASE` expressions and date functions
- Common Table Expressions (CTEs)
- Window functions such as `ROW_NUMBER()`, `RANK()`, and `PARTITION BY`
- Interpreting query outputs in a business context

### Part 2 — Analytical SQL practice

A second 10-day practice program emphasizing:

- Translating business questions into SQL queries
- Analyzing patterns and comparing segments or time periods
- Selecting meaningful metrics
- Interpreting results and communicating conclusions

*This part is a work in progress; scripts will be added as each day is completed.*

## Tools

- Microsoft SQL Server
- T-SQL
- Visual Studio Code

## How to use

1. Get the SQL Server version of the Chinook database from the [original repository](https://github.com/lerocha/chinook-database).
2. Create the database in your local SQL Server instance.
3. Open the scripts in `parte-1/` or `parte-2/` using your preferred SQL editor.
4. Connect to the Chinook database and execute the queries.

The scripts are organized by practice day; they are learning exercises rather than a single application that must be run in sequence.

## Acknowledgments

Chinook is maintained by its original contributors. See the [Chinook database repository](https://github.com/lerocha/chinook-database) for its source files, documentation, and licensing information.
