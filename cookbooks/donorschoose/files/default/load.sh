#!/bin/sh
# Uses the -U $DBUSER -h $DBHOST -d $DBNAME environment variables.

(
  # \COPY opendata_projects FROM PSTDIN WITH CSV HEADER
  zcat 04-open_data-projects.csv.gz
  echo '\.'

  # \COPY opendata_resources FROM PSTDIN WITH CSV HEADER
  zcat 05-open_data-resources.csv.gz
  echo '\.'

  # \COPY opendata_essays FROM PSTDIN WITH CSV HEADER
  zcat 02-open_data-essays.csv.gz
  echo '\.'

  # \COPY opendata_donations FROM PSTDIN WITH CSV HEADER
  zcat 01-open_data-donations.csv.gz
  echo '\.'

  # \COPY opendata_giftcards FROM PSTDIN WITH CSV HEADER
  zcat 03-open_data-giftcards.csv.gz
  echo '\.'
) \
| psql -U $DBUSER -h $DBHOST -d $DBNAME -f load.sql
psql -U $DBUSER -h $DBHOST -d $DBNAME -f normalize.sql