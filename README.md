# Web of Science Query Tool

### Shiny app to query Web of Science XML data 

- Run SQL Queries in the browser
- Subsets of the query to .csv for use in other analysis packages
- Underlying postgresql is only a small subset (~100,000 items) of the entire database (~70 million items)
- Postgresql database is parsed from the raw XML based on this generic [parsing tool](https://github.com/wrathofquan/generic_parser)

