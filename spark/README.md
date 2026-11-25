# Do city events pull taxis? (PySpark)

Three monthly files of New York yellow-taxi trips (2016) and the city's 511 event feed, processed with
PySpark on Databricks: cleaning and typing, parsing event times out of free text, joining trips to
events in space and time, and comparing taxi demand around events with normal hours. `aux_func.py`
holds the map helpers (folium). Data: public NYC TLC trip records and NY 511 events (not committed).
