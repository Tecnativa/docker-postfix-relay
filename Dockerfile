FROM ubuntu:16.04

MAINTAINER antespi@gmail.com

EXPOSE 25

ENV HOST=localhost \
    DOMAIN=localdomain \
    MAILNAME=localdomain \
    MAIL_RELAY_HOST='' \
    MAIL_RELAY_PORT='' \
    MAIL_RELAY_USER='' \
    MAIL_RELAY_PASS='' \
    MAIL_VIRTUAL_FORCE_TO='' \
    MAIL_VIRTUAL_ADDRESSES='' \
    MAIL_VIRTUAL_DEFAULT='' \
    MAIL_CANONICAL_DOMAINS='' \
    MAIL_NON_CANONICAL_PREFIX='' \
    MAIL_NON_CANONICAL_DEFAULT=''

RUN apt-get update && \
    apt-get upgrade -y && \
    echo "postfix postfix/mailname string $MAILNAME" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postfix rsyslog

RUN postconf -e smtp_tls_security_level=may && \
    postconf -e smtp_sasl_auth_enable=yes && \
    postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd && \
    postconf -e smtp_sasl_security_options=noanonymous && \
    postconf -e myhostname=$HOST && \
    postconf -e mydomain=$DOMAIN && \
    postconf -e mydestination=localhost && \
    postconf -e mynetworks='127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128' && \
    postconf -e inet_interfaces=loopback-only && \
    postconf -e smtp_helo_name=\$myhostname.\$mydomain && \
    postconf -e virtual_maps='hash:/etc/postfix/virtual, regexp:/etc/postfix/virtual_regexp' && \
    postconf -e sender_canonical_maps=regexp:/etc/postfix/sender_canonical_regexp

ADD postfix /etc/postfix

RUN postmap /etc/postfix/sasl_passwd && \
    postmap /etc/postfix/virtual_regexp && \
    postmap /etc/postfix/virtual && \
    postmap /etc/postfix/sender_canonical_regexp

ADD entrypoint test /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/entrypoint"]
# CMD ["tail", "-f", "/var/log/syslog"]
CMD ["bash"]
