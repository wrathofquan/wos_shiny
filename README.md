# Web of Science Query Tool

### Shiny app to query Web of Science XML data 

- Allows SUL staff to run SQL Queries in the browser and generates an [R-wrapped](https://rstudio.github.io/DT/) [jQuery Datatable](https://datatables.net/) that can be sorted and searched
- Can download subsets of the query to .csv format for use in other analysis packages
- Underlying postgresql is only a small subset (~50,000 rows) of the entire database (~200 million rows)
- Postgresql database is parsed from the raw XML based on this generic [parsing tool](https://github.com/wrathofquan/generic_parser)


## To-do

- Testing to see if this scales to entire database
- Parameterize queries for better usability/safety
- Visualizations for exploratory data analysis
- Tools to do ad-hoc bibliometric analysis

