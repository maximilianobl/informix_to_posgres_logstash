FROM logstash:8.3.1

# install dependency
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-jdbc
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-aggregate
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-jdbc_streaming
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-mutate
# https://github.com/theangryangel/logstash-output-jdbc
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-jdbc
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode

# copy lib database jdbc jars
COPY ./jdbc/ifxjdbc-4.50.3.jar /usr/share/logstash/logstash-core/lib/jars/ifxjdbc-4.50.3.jar
COPY ./jdbc/postgresql-42.4.1.jar /usr/share/logstash/logstash-core/lib/jars/postgresql-42.4.1.jar