FROM postgres:16

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y postgresql-16-cron build-essential libpq-dev postgresql-server-dev-all

WORKDIR /srv
COPY . /srv

RUN echo "shared_preload_libraries = 'pg_cron'" >> /var/lib/postgresql/data/postgresql.conf
RUN echo "cron.database_name = 'postgres'" >> /var/lib/postgresql/data/postgresql.conf

RUN for v in `seq 13 16`; do pg_buildext build-$v $v; done

RUN TARGETS=$(find * -name pg_uuidv7.so) \
  && tar -czvf pg_uuidv7.tar.gz $TARGETS sql/pg_uuidv7--1.3.sql pg_uuidv7.control \
  && sha256sum pg_uuidv7.tar.gz $TARGETS sql/pg_uuidv7--1.3.sql pg_uuidv7.control > SHA256SUMS
