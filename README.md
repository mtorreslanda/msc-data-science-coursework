# MSc Data Science coursework

Selected assignments from the **Master's in Data Science, Big Data & Business Analytics** at
Universidad Complutense de Madrid (2025–2026). All individual work. Notebooks are in Spanish and are
committed with their outputs, so they can be read directly on GitHub.

| | Assignment | Tools | Folder |
|---|---|---|---|
| ![](visualisation/images/points_clock.png) | **How data and rules changed the NFL, 1999–2025.** A visual essay over 27 seasons of play-by-play: fourth-down aggressiveness, field goals by era, the two-point revolution, when points are scored. | pandas · matplotlib · seaborn · plotly | [`visualisation/`](visualisation) |
| ![](nfl-draft/images/draft_dispersion.png) | **Does the NFL draft get it right?** College stats, the combine and draft slot against NFL careers, stored and queried as documents in MongoDB. | nfl_data_py · REST API · MongoDB | [`nfl-draft/`](nfl-draft) |
| | **Do city events pull taxis?** Three months of New York yellow-taxi trips joined with 511 traffic events in PySpark: cleaning, spatial and temporal joins, demand around events. | PySpark · Databricks · folium | [`spark/`](spark) |
| | **SQL on Snowflake: Smart Desk.** Business questions for a sales company — sales, targets, forecasts and accounts — answered in SQL, with a written report. | SQL · Snowflake | [`sql/`](sql) |
| | **Data mining.** Part 1: cleaning and modelling a salary dataset full of impossible values. Part 2: stationarity tests and ARIMA / Holt–Winters forecasts on a stock price series. | scikit-learn · statsmodels | [`data-mining/`](data-mining) |
| | **Text mining: professions in tweets.** Detecting mentions of professions in Spanish tweets (ProfNER shared task) by fine-tuning BETO, a Spanish BERT. | NLP · transformers | [`text-mining/`](text-mining) |

The Pump It Up machine-learning project has its own repository:
[pump-it-up-water-table](https://github.com/mtorreslanda/pump-it-up-water-table) (peaked at #6 on DrivenData).

## Data

Raw data is not committed. The NFL notebooks download public [nflverse](https://github.com/nflverse)
data; the draft notebook also uses the free [CollegeFootballData](https://collegefootballdata.com) API
(set `CFBD_API_KEY` in your environment). The taxi trips are the public NYC TLC records; the other
datasets were provided by the course.

---
Miguel Ángel Castro Torreslanda · [mtorreslanda.com](https://mtorreslanda.com)
