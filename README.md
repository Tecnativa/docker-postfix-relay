# Dockerized SMTP relay

## What?

SMTP relay with local queue.

## Why?

Sending emails through a controlled network (possibly localhost or LAN) is
faster and more controlled than sending them directly through the Internet.

This container retains email queue in a volume under `/var/spool/postfix`, so
in case your network fails or your real SMTP server is down for maintenance
or whatever, queue will be sent when network connection is restored.

This way your app can send emails faster, forget about possible temporary
network failures, and concentrate on its business.

## How?

Configure through these environment variables:

- `MAILNAME`
- `MAIL_RELAY_HOST`
- `MAIL_RELAY_PORT`
- `MAIL_RELAY_USER`
- `MAIL_RELAY_PASS`
- `MAIL_CANONICAL_DOMAINS`
- `MAIL_NON_CANONICAL_DEFAULT`
- `MESSAGE_SIZE_LIMIT` in bytes, defaults to 25MB, just like Gmail.

### Examples

#### SMTP relay via Gmail

    docker container run \
        -e MAIL_RELAY_HOST='smtp.gmail.com' \
        -e MAIL_RELAY_PORT='587' \
        -e MAIL_RELAY_USER='your_gmail_addr@gmail.com' \
        -e MAIL_RELAY_PASS='your_gmail_pass' \
        tecnativa/postfix-relay
