# Amazon Sales Analytics Pipeline

## Project Overview
This project establishes an end-to-end data analytics pipeline designed to process and analyze real-world Amazon retail data. The pipeline automatically ingests a 69MB raw transactional dataset, executes targeted cleaning operations, maps the data structural schema into a relational MySQL database server, and serves aggregated business metrics directly to an interactive Power BI executive dashboard.

---

## Repository Architecture
```text
amazon-sales-analytics-pipeline/
├── .gitignore                 # Prevents large data payloads from tracking to Git
├── README.md                  # Comprehensive portfolio documentation page
├── requirements.txt           # Inbound Python production libraries
├── data/                      # Local warehouse for source spreadsheets (Ignored by Git)
│   └── Amazon_Sale_Report.csv
├── scripts/                   
│   └── data_pipeline.py       # Python Pandas ETL data pipeline engine
├── sql/                       
│   ├── view_creations.sql     # Aggregated view layer for dashboard stability
│   └── ad_hoc_queries.sql     # Query catalog solving core retail metrics
└── dashboard/                 
    ├── sales_overview.pbix    # Finished Power BI production workbook
    └── preview_image.png      # High-resolution visual snapshot of dashboard
```

---

## Technical Stack & Infrastructure
* **Data Engineering & ETL:** Python 3.x, Pandas, SQLAlchemy
* **Database Management System:** MySQL Server v8.x, PyMySQL Driver
* **Business Intelligence & Presentation:** Power BI Desktop, DAX 
* **Version Control:** Git, GitHub Desktop

---

## Core Business Questions Solved (SQL View Layer)
To maximize data performance and reduce processing lag inside Power BI, raw records were aggregated into optimized database views:

1. **Monthly Sales Performance:** Tracked overall transaction volumes, item units sold, and gross monthly revenue velocities over time.
2. **Product SKU Optimization:** Identified the top-performing inventory styles and stock-keeping units (SKUs) based on net cash flow generation.
3. **Fulfillment Logistics Mix:** Analyzed the distribution ratio between Expedited and Standard shipping levels to optimize carrier contract negotiations.
4. **Operations Loss Control:** Measured delivery failure rates, customer cancellations, and the financial impact of unfulfilled orders.
5. **Geographic Distribution:** Isolated the top 10 highest-spending states and cities to pinpoint target marketing regions.
6. **Sales Channel Value:** Calculated the Average Order Value (AOV) across different transaction environments to determine platform profitability.

---

## Operational Workflow Pipeline

### Step 1: Python Extraction & Cleanse
The `data_pipeline.py` script streams the localized raw source document, eliminates duplicate transaction lines, converts column strings into clean database snake_case syntax, standardizes broken calendar timestamps, and handles empty tracking categories.

### Step 2: Relational Server Upload
Using a chunked memory layout via SQLAlchemy, Python directly updates the active MySQL database instance, automatically generating table structures without manual intervention.

### Step 3: SQL Aggregations
The analytical engine creates reusable views on top of the base transaction ledger table. This encapsulates complex business logic into clean virtual tables.

### Step 4: Power BI Reporting
Power BI establishes an interactive pathway to the database server, fetching the predefined summary views to render low-latency charts, maps, and executive performance metrics.

