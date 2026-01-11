# 🎵 MusicTrendy - Premium Musical Instrument Store

> **Course:** CAT201 Integrated Software Development Workshop  
> **Session:** 2025/2026  
> **School:** School of Computer Sciences, Universiti Sains Malaysia

## 📖 Introduction
**MusicTrendy** is a web-based e-commerce application designed to sell musical instruments online. It provides a seamless shopping experience for musicians and a robust management system for store administrators. 

This project was built **entirely using standard Java Web technologies** (Servlets, JSP, JDBC) without relying on high-level enterprise frameworks like Spring or Struts, demonstrating a deep understanding of core web development concepts.

---

## 🚀 Features

### 🛒 Customer Features
* **User Authentication:** Secure Registration and Login system.
* **Product Discovery:**
    * Interactive Hero Carousel showcasing new arrivals.
    * **Shop by Category:** Filter products by Drums, Guitars, Keyboards, etc.
    * **Shop by Brand:** Filter by top brands like Fender, Yamaha, Roland, etc.
* **Shopping Cart:** Session-based cart management (Add, Remove, Update Quantity).
* **Secure Checkout:**
    * Real-time stock validation.
    * Multi-step checkout process with visual progress indicators.
    * Interactive credit card input with visual feedback.
    * Multiple payment options: Online Banking, Credit Card, and COD.
* **Order History:** Track order status (To Ship, To Receive, Completed).

### 🛡️ Admin Features
* **Dashboard Analytics:** Real-time overview of Total Orders, Total Customers, and Top Selling Products.
* **Inventory Management:** * Add, Edit, and Delete products.
    * Upload product images.
* **Order Fulfillment:** View customer orders and update shipping statuses.

---

## 🛠️ Technology Stack

* **Backend:** Java (JDK 17+), Java Servlets, JSP (JavaServer Pages).
* **Frontend:** HTML5, CSS3, **Bootstrap 5.3**, JavaScript, FontAwesome 6.
* **Database:** MySQL.
* **Data Access:** JDBC (Java Database Connectivity) with DAO Pattern.
* **Build Tool:** Maven.
* **Server:** Apache Tomcat 10.

---

## ⚙️ Installation & Setup

### 1. Prerequisites
Ensure you have the following installed:
* Java Development Kit (JDK) 17 or higher.
* Apache Maven.
* Apache Tomcat 10 (Jakarta EE 9+ compatible).
* MySQL Server.
* An IDE (IntelliJ IDEA, Eclipse, or NetBeans).

### 2. Database Configuration
1.  Open your MySQL Workbench or Command Line.
2.  Create a database named `musictrendy_db`.
    ```sql
    CREATE DATABASE musictrendy_db;
    ```
3.  Import the SQL schema (tables for `users`, `products`, `orders`, `order_items`, `cart`, `cart_items`).
4.  **Note:** The application connects using the default user `root` with no password. If your configuration is different, update the credentials in:
    * `src/main/java/util/DBConnection.java`

### 3. Build and Run
1.  Clone this repository.
    ```bash
    git clone [https://github.com/yourusername/musictrendy.git](https://github.com/yourusername/musictrendy.git)
    ```
2.  Open the project in your IDE.
3.  Configure the Tomcat Server in your IDE and deploy the artifact (`musictrendy.war` or exploded directory).
4.  Run the server.
5.  Access the application at: `http://localhost:8080/MusicTrendy`

---

## 📂 Project Structure

```bash
MusicTrendy
├── src
│   ├── main
│   │   ├── java
│   │   │   ├── controller   # Servlets (Login, Checkout, AdminDashboard)
│   │   │   ├── dao          # Data Access Objects (OrderDAO, ProductDAO)
│   │   │   ├── model        # POJOs (Product, User, CartItem)
│   │   │   └── util         # Database Connection Utility
│   │   └── webapp
│   │       ├── admin        # Admin JSPs (Dashboard, Product Mgmt)
│   │       ├── images       # Product and UI Images
│   │       ├── WEB-INF      # Web Configuration
│   │       ├── index.jsp    # Homepage
│   │       ├── products.jsp # Product Catalog
│   │       ├── payment.jsp  # Interactive Payment Page
│   │       └── ...
└── pom.xml                  # Maven Dependencies
