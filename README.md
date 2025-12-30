# Retail_Store_Analysis-Using-SQL-

# 🛒 Sales Store SQL Analysis Project

## 📌 Project Overview

This project analyzes daily sales transactions for a retail store chain using **SQL Server**. The goal is to turn raw transactional data into **business insights** that help improve sales performance, customer experience, and profitability.

The project covers **data cleaning, data validation, and business-driven SQL analysis**.

---

## 🏪 Business Context

A retail store chain tracks daily customer transactions, including:

* Customer details
* Product information
* Purchase time
* Payment mode
* Order status (delivered, cancelled, returned)

However, the business lacks clear visibility into:

* Sales trends
* Customer purchasing behavior
* Product performance
* Operational inefficiencies

---

## 🎯 Problem Statement

The company needs structured reporting and analytics to:

* Identify top-selling and low-performing products
* Understand peak sales times
* Track cancellations and returns
* Analyze customer spending patterns
* Improve inventory planning and marketing strategies

---

## 🗂️ Dataset Description

**Database:** `store`
**Table:** `sales`

### Key Columns

* `transaction_id`
* `customer_id`
* `customer_name`
* `customer_age`
* `gender`
* `product_id`
* `product_name`
* `product_category`
* `quantity`
* `price`
* `payment_mode`
* `purchase_date`
* `time_of_purchase`
* `status`

---

## 🧹 Data Cleaning Steps

### 1️⃣ Duplicate Records

* Identified duplicate `transaction_id` values
* Used `ROW_NUMBER()` with CTE to detect duplicates
* Removed extra duplicate records

### 2️⃣ Column Name Corrections

* Fixed spelling errors using `sp_rename`

  * `quantiy` → `quantity`
  * `prce` → `price`

### 3️⃣ Data Type Validation

* Verified column data types using `INFORMATION_SCHEMA.COLUMNS`

### 4️⃣ Null Value Handling

* Checked null counts dynamically for all columns
* Removed records with critical missing values
* Updated missing customer details where possible

### 5️⃣ Data Standardization

* Gender values standardized: `Male/Female` → `M/F`
* Payment mode standardized: `CC` → `Credit Card`

---

## 📊 Business Analysis & Insights

### 🔥 1. Top 5 Most Selling Products (by Quantity)

**Insight:** Identifies high-demand products
**Impact:** Better inventory planning and promotions

---

### 📉 2. Most Frequently Cancelled Products

**Insight:** Highlights products with high cancellation rates
**Impact:** Improve product quality or remove weak items

---

### 🕒 3. Peak Purchase Time of Day

* Night (0–5)
* Morning (6–11)
* Afternoon (12–17)
* Evening (18–23)

**Impact:** Optimize staffing, offers, and system performance

---

### 👥 4. Top 5 Highest Spending Customers

**Insight:** Identifies VIP customers
**Impact:** Loyalty programs and personalized offers

---

### 🛍️ 5. Highest Revenue Generating Categories

**Insight:** Shows which categories drive maximum revenue
**Impact:** Focus investment on profitable categories

---

### 🔄 6. Cancellation & Return Rate by Category

**Insight:** Tracks dissatisfaction trends
**Impact:** Reduce returns, improve logistics and product descriptions

---

### 💳 7. Most Preferred Payment Mode

**Insight:** Understands customer payment preferences
**Impact:** Streamline and prioritize popular payment options

---

### 🧓 8. Purchasing Behavior by Age Group

Age Groups:

* 18–25
* 26–35
* 36–50
* 51+

**Impact:** Targeted marketing and better product recommendations

---

### 🔁 9. Monthly Sales Trend Analysis

* Tracks revenue and quantity month-wise
* Helps identify seasonal trends

**Impact:** Smarter inventory and marketing planning

---

## 📌 Key Insights Summary

* 🏆 **Top-Selling Products Identified:** A small set of products contributes to a large share of delivered sales, helping the business focus inventory and promotions on high-demand items.
* ❌ **Cancellation Hotspots Detected:** Certain products and categories show higher cancellation and return rates, indicating quality, pricing, or expectation gaps.
* ⏰ **Peak Sales Hours Revealed:** Most purchases occur during specific time windows, enabling better staff scheduling, marketing timing, and system optimization.
* 👑 **High-Value Customers Identified:** A few customers contribute significantly to total revenue, highlighting opportunities for loyalty programs and personalized offers.
* 🛍️ **Revenue-Driving Categories:** Some product categories consistently outperform others in revenue, guiding smarter category-level investments.
* 💳 **Preferred Payment Modes:** Customers favor specific payment methods, helping the business streamline checkout and reduce payment friction.
* 🧓 **Age-Based Buying Patterns:** Different age groups show distinct spending behaviors, supporting targeted marketing and age-based recommendations.
* 📈 **Seasonal Sales Trends Observed:** Monthly sales analysis reveals fluctuations that can be used for inventory planning and promotional campaigns.

---

## 🛠️ Tools & Technologies

* **SQL Server**
* **T-SQL** (CTEs, Window Functions, Aggregations)

---

## 📈 Key Business Outcomes

✔ Improved visibility into sales performance
✔ Identified top customers and products
✔ Detected operational issues like cancellations and returns
✔ Enabled data-driven decision-making

---

## 📌 How to Use This Project

1. Import the dataset into SQL Server
2. Run data cleaning scripts
3. Execute analysis queries
4. Use insights for reporting or dashboards

---

## 🚀 Future Improvements

* Build Power BI dashboard
* Add profit & margin analysis
* Customer segmentation (RFM)
* Predictive sales forecasting

---

## 🙌 Author

**Harsh**
Aspiring Data Analyst | SQL | Excel | Power BI

---

⭐ If you find this project helpful, feel free to star the repository!
