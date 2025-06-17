# Bank Management System SQL Scripts

This repository contains SQL scripts for creating and managing a database system for a Bank Management System. The scripts include database creation, table creation, data insertion, and queries to interact with the data.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Database Details](#database-details)
3. [Table Structures](#table-structures)
   - [Customer Table](#customer-table)
4. [SQL Scripts Overview](#sql-scripts-overview)
5. [How to Use](#how-to-use)
6. [Sample Queries](#sample-queries)

---

## Introduction

This project demonstrates the SQL scripts required to set up and manage a simple bank management system. The scripts create a database named `BankManagement` and its associated tables, such as `Customer`, along with sample data and queries.

---

## Database Details

- **Database Name:** `BankManagement`

---

## Table Structures

### Customer Table

The `Customer` table stores information about bank customers.

| Column Name   | Data Type      | Constraints               |
| ------------- | -------------- | ------------------------- |
| `CustomerID`  | `int`          | `NOT NULL, Identity(1,1)` |
| `FirstName`   | `varchar(50)`  | `NOT NULL`                |
| `LastName`    | `varchar(50)`  | `NOT NULL`                |
| `DateOfBirth` | `datetime`     |                           |
| `PhoneNumber` | `int`          |                           |
| `Email`       | `varchar(50)`  |                           |
| `Address`     | `varchar(100)` |                           |

---

## SQL Scripts Overview

### 1. Create Database

- Script to create the `BankManagement` database.

```sql
CREATE DATABASE BankManagement;
USE BankManagement;
```

### 2. Create Tables

- Script to create the `Customer` table.

```sql
CREATE TABLE Customer (
    CustomerID int NOT NULL IDENTITY(1,1),
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    DateOfBirth datetime,
    PhoneNumber int,
    Email varchar(50),
    Address varchar(100)
);
```

### 3. Insert Data

- Example of inserting records into the `Customer` table.

```sql
INSERT INTO Customer (FirstName, LastName, DateOfBirth, PhoneNumber, Email, Address)
VALUES ('Ali', 'Zeb', '1996-03-29', 0333333333, 'abc1@gmail.com', 'Swabi kp');
```

### 4. Retrieve Data

- Query to retrieve all records from the `Customer` table.

```sql
SELECT * FROM Customer;
```

---

## How to Use

1. Download the SQL script file.
2. Open a SQL Server Management Studio (SSMS) or any compatible SQL editor.
3. Execute the script step by step to set up the database and tables.
4. Use the provided queries to interact with the data.

---

## Sample Queries

- Retrieve all customers:

  ```sql
  SELECT * FROM Customer;
  ```

- Insert a new customer:

  ```sql
  INSERT INTO Customer (FirstName, LastName, DateOfBirth, PhoneNumber, Email, Address)
  VALUES ('John', 'Doe', '1990-01-01', 0123456789, 'john.doe@example.com', '123 Main Street');
  ```

---
