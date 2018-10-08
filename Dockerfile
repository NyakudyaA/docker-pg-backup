
FROM kartoza/postgis:9.6-2.4
MAINTAINER tim@kartoza.com

RUN apt-get update 
RUN apt-get install -y postgresql-client postgis
ADD backups-cron /etc/cron.d/backups-cron
RUN touch /var/log/cron.log
ADD backups.sh /backups.sh
ADD start.sh /start.sh
 
CMD ["/start.sh"]
