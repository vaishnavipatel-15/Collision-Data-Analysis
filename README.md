
# Collision Data Analysis for New York, Chicago, and Austin

## Project Overview
This project focuses on analyzing motor vehicle collisions/crashes data from three cities: New York, Chicago, and Austin. The data was obtained from the respective city data portals provided by the Department of Transportation. The primary goal is to analyze and visualize various aspects of traffic collisions to derive meaningful insights and support data-driven decision-making.

## Data Sources
- **New York**: [Motor Vehicle Collisions - Crashes | NYC Open Data](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95/about_data)
- **Chicago**: [Traffic Crashes - Crashes | City of Chicago | Data Portal](https://data.cityofchicago.org/Transportation/Traffic-Crashes-Crashes/85ca-t3if/about_data)
- **Austin**: [Austin Crash Report Data - Crash Level Records | Open Data | City of Austin Texas](https://data.austintexas.gov/Transportation-and-Mobility/Austin-Crash-Report-Data-Crash-Level-Records/y2wy-tgr5/about_data)

## Project Structure
The repository contains the following files and directories:
- `data/`: Directory containing the crash data for the three cities in Excel format.
- `scripts/`: SQL and validation scripts used in the project.
- `documents/`: Supporting documents including analysis reports, mapping documents, and transformation details.
- `visualizations/`: Tableau and Power BI workbooks.
- `README.md`: Project overview and instructions.

## Analysis and Reports
The project involved various phases, each focusing on different aspects of data analysis and reporting:

### Part 1: Data Profiling and Staging
- Data profiling using Alteryx.
- Analysis document outlining the initial findings.
- Staging tables created using Talend ETL jobs.
- Dimensional model creation with facts and dimensions.
- Detailed mapping document explaining source-to-target mappings.
- SQL scripts and validation scripts included for row count matching and data integrity.

### Part 2: Data Integration and Querying
- Data staged to integration schema using Talend ETL jobs.
- Queries to validate dimensional data and answer specific business questions.
- Change requests handled by adjusting dimensional models and data loads.

### Part 3: Visualizations
- Creation of visualizations using Tableau and Power BI.
- Dashboards to present key findings such as:
  - Number of accidents in each city.
  - Areas with the highest number of accidents.
  - Accidents resulting in injuries.
  - Pedestrian involvement in accidents.
  - Time-based analysis of accidents.
  - Fatality analysis and common factors involved.

## Key Insights
- **Accident Count**: The total number of accidents in each city.
- **High Accident Areas**: Top 3 areas in each city with the highest accident counts.
- **Injury Analysis**: Reports on accidents resulting in injuries, both overall and by city.
- **Pedestrian Involvement**: Frequency of pedestrian involvement in accidents, both overall and by city.
- **Seasonality**: When most accidents occur, including time of day, day of the week, and season.
- **Motorist Injuries and Fatalities**: Number of motorists injured or killed, analyzed overall and by city.
- **Fatality Locations**: Top 5 areas with the most fatal accidents in each city.
- **Common Factors**: Analysis of common factors contributing to accidents.

## Project Requirements
All project requirements and details can be found in the final_project_details.pdf file.

## GitHub Release
You can find the Power BI files and the Integrated DB CSV file in the latest [GitHub release](https://github.com/vaishnavipatel-15/Collision-Data-Analysis/releases/tag/v1.0.1).
