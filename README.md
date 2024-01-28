# SQL-COVID-19 Data Exploration-project

## Description
This project explores the real world Covid-19 data dated prior to April 2021. Number of deaths, infections and vaccinations across countries and continents are primarily analyzed by SQL basic queries on Microsoft SQL Server Management Studio. The results are going to be visualized by Tableau. The intention of this personal project is to showcase SQL skills.

## Getting Started
### Prerequisites
- Microsoft SQL Server Management Studio
- Microsoft Excel
### Installing
- Dataset: download from [Our World in Data](https://ourworldindata.org/covid-deaths), this file is in CSV. Data is seperated and saved into 2 xlsx files in order to perform `JOIN` clause between two tables.
  - CovidDeaths that keeps column A - Z.
  - CovidVaccinations that keeps column A - D and AA to the end.
- Import data into SQL Server for analysis.

## Running
Perfomr a series of SQL queries to extract crucial data and analyze the trends including:
  - `WHERE`
  - `MIN` `MAX` `SUM` functions
  - `PARTITION BY`
  - `CREATE TABLE`
  - Common Table Expression (CTE)
  - `JOIN`
  - `INSERT INTO`
  - `CREATE VIEW`
    
## Inspiration
This project is inspired by Alex The Analyst tutorial by [@AlexTheAnalyst](https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&index=1). 
