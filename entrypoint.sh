#!/bin/sh

echo 'Waiting for postgres...'

while ! nc -z $DB_HOSTNAME $DB_PORT; do
    sleep 0.1
done

echo 'PostgreSQL started'

echo 'Running migrations...'
python manage.py migrate

echo 'Collecting static files...'
python manage.py collectstatic --no-input

exec "$@"

# Копируем entrypoint.sh в образ
COPY entrypoint.sh /code/
# Устанавливаем права на выполнение скрипта
RUN chmod +x /code/entrypoint.sh