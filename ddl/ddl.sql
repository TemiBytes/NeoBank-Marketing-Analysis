/*
=====================================================
DDL SCRIPT: Create Tables
=====================================================
Script Purpose:
  This script creates tables in the 'neo' schema, dropping existing tables
  if they already exist.
  Run this script to redefine the DDL Structure of 'neo' Tables
*/

-- campaigns
IF OBJECT_ID('neo.campaigns', 'U') IS NOT NULL
	DROP TABLE neo.campaigns;
GO

CREATE TABLE neo.campaigns(
	campaign_id NVARCHAR(50),
	channel NVARCHAR(50),
	objective NVARCHAR(50),
	country NVARCHAR(50)
)

-- users
IF OBJECT_ID('neo.users','U') IS NOT NULL
	DROP TABLE neo.users;
GO

CREATE TABLE neo.users(
	user_id INT,
	install_time DATE,
	campaign_id NVARCHAR(50),
	channel NVARCHAR(50),
	country NVARCHAR(50),
	device NVARCHAR(50),
	kyc_verified_at DATE,
	first_funding_at DATE
)

-- spend
IF OBJECT_ID('neo.spend','U') IS NOT NULL
	DROP TABLE neo.spend;
GO

CREATE TABLE neo.spend(
	date DATE,
	campaign_id NVARCHAR(50),
	spend DECIMAL(10,2),
	impressions INT,
	clicks INT
)

-- revenue
IF OBJECT_ID('neo.revenue', 'U') IS NOT NULL
	DROP TABLE neo.revenue;
GO

CREATE TABLE neo.revenue(
	txn_time DATE,
	user_id INT,
	product NVARCHAR(50),
	amount DECIMAL(10,2),
	margin DECIMAL(10,2)
)


-- experiments
IF OBJECT_ID('neo.crm_experiments', 'U') IS NOT NULL
	DROP TABLE neo.crm_experiments;
GO

CREATE TABLE neo.crm_experiments(
	user_id INT,
	experiment NVARCHAR(50),
	[group] NVARCHAR(50),
	send_time DATE,
	converted_within_7d BIT
)


-- events
IF OBJECT_ID('neo.events' , 'U') IS NOT NULL
	DROP TABLE neo.events;
GO

CREATE TABLE neo.events(
	user_id INT,
	event_time DATE,
	event_name NVARCHAR(50)
)


--referrals
IF OBJECT_ID('neo.referrals' , 'U') IS NOT NULL
	DROP TABLE neo.referrals;
GO

CREATE TABLE neo.referrals(
	referrer_user_id INT,
	referred_user_id INT,
	referral_time DATE
)

