# Dockerized SMTP server#

SMTP server and SMTP relay host

## Run container

### SMTP relay via Gmail

    docker run -it -d --name smtp_relay \
           -e MAIL_RELAY_HOST='smtp.gmail.com' \
           -e MAIL_RELAY_PORT='587' \
           -e MAIL_RELAY_USER='your_gmail_addr' \
           -e MAIL_RELAY_PASS='your_gmail_pass' \
           tecnativa/postfix-relay
