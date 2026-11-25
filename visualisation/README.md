# How data and rules changed the NFL (1999–2025)

Advanced data visualisation assignment. Two forces explain much of how the NFL changed in 27 seasons:
coaches started deciding with data (fourth downs, two-point conversions) and the league kept changing
the rules (kickoffs, extra points). The full report is [`report_es.pdf`](report_es.pdf) (76 pages, Spanish).

![Fourth downs attempted by yards to go](images/fourth_downs.png)

![Points per game in each 30-second block](images/points_clock.png)

Run: `pip install -r requirements.txt`, then the notebook. The first run downloads nflverse
play-by-play and builds a reduced Parquet file in `data/`.
