# Web of Science Query Tool

### Shiny app to query Web of Science XML data 

- Allows SUL staff to run SQL Queries in the browser and generate an [R-wrapped](https://rstudio.github.io/DT/) [jQuery Datatable](https://datatables.net/) that can be sorted and searched
- Can download subsets of the query to .csv format for use in other analysis packages
- Underlying postgresql is only a small subset (~70,000 rows) of the entire database (~400 million rows)
- Postgresql database is parsed from the raw XML based on this generic [parsing tool](https://github.com/wrathofquan/generic_parser)

