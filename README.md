# Fetch_Analytics_Model

This repository contains a data model and SQL queries for analyzing receipt data. The data model is designed to handle various business requirements and data quality issues.

The data model consists of the following tables:
Users
Brands
Receipts
ReceiptItems
Items

### Key Points

ReceiptItems:
Added brandID column to reference Brands table and allow easy association of items with brands.
This table does not have a separate surrogate key (id). Instead, it relies on the combination of receiptId and itemId to uniquely identify each receipt item, maintaining the relationship with the Receipts table and avoiding unnecessary duplication.
