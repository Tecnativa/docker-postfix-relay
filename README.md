# [Dockerized SMTP relay](https://hub.docker.com/r/tecnativa/postfix-relay)

[![Docker Automated build](https://img.shields.io/docker/automated/tecnativa/postfix-relay.svg)](https://hub.docker.com/r/tecnativa/postfix-relay/)

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

- `MAILNAME`: The default host for cron job mails.
- `MAIL_RELAY_HOST`: The real SMTP server (e.g. `smtp.mailgun.org`).
- `MAIL_RELAY_PORT`: The port in `MAIL_RELAY_HOST`. Depending on the port,
  a specific security configuration will be used.
- `MAIL_RELAY_USER`: The user to authenticate in `MAIL_RELAY_HOST`.
- `MAIL_RELAY_PASS`: The password to authenticate in `MAIL_RELAY_HOST`.
- `MAIL_CANONICAL_DOMAINS`: A space-separated list of domains that are
  considered [canonical][].
- `MAIL_NON_CANONICAL_DEFAULT`: A domain that should be found in the list of
  `MAIL_CANONICAL_DOMAINS`, which will be used as the replacement domain when
  a non-[canonical][] message comes in. Leave it empty to skip that
  replacement system.
- `MAIL_CANONICAL_PREFIX`: Defaults to `noreply+`, and it is what will be
  prefixed to replaced non-[canonical][] sender addresses.
- `MESSAGE_SIZE_LIMIT` in bytes, defaults to 50MiB. Most generous servers offer
  a limit of 25iMB (Gmail, Mailgun...), so by defaulting to 50MiB, basically
  we are forcing the remote server to fail in case of a big email, instead of
  making the local relay to fail. Change at will if you prefer a different
  behavior.
- `ROUTE_CUSTOM` space separated list of subnets in the CIDR standard notation
  (e.g 192.168.0.0/16).

### Examples

#### SMTP relay via Gmail

    docker container run \
        -e MAIL_RELAY_HOST='smtp.gmail.com' \
        -e MAIL_RELAY_PORT='587' \
        -e MAIL_RELAY_USER='your_gmail_addr@gmail.com' \
        -e MAIL_RELAY_PASS='your_gmail_pass' \
        tecnativa/postfix-relay

## FAQ

### What Is A Canonical Domain

It means "domains that are allowed to send from here".

Suppose your app allows users to define their own emails, and that one is used
to send emails to other users from the system.

If you only own the `example.com` and `example.net` domains, but somebody
configures his email as `pink@example.org`. If you send this email as it came,
SPAM filters will block it.

By defining `MAIL_CANONICAL_DOMAINS=example.com example.net` and
`MAIL_NON_CANONICAL_DEFAULT=example.com`, the mail would be modified as if it
came from `noreply+pink-example.org@example.com`, and SPAM filters will
be happy with that.

[canonical]: #what-is-a-canonical-domain
