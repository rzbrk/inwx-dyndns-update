# inwx-dyndns-update
Bashscript to update INWX domain using DynDNS service

Installation
------
The installation is quite simple.

Copy `dyndns-update.sh` and `dyndns-update.conf.example` to a local folder. Rename `dyndns-update.conf.example` to `dyndns-update.conf` and adjust at least the variables `username`, `password` and `hostname`. Do NOT enter the INWX account login credentials but the INWX DynDNS user login credentials! Ensure that the file permissions are set to 600 to protect the credentials.

To execute, the script can simply be executed in the Bash.

Possible return codes from the INWX server:
* good   - update was successful
* nochg  - update changed no setting (avoid this, can be considered abuse)
* dnserr - DNS error, possibly wrong settings/credentials. Recheck

It is a good idea to store the script in a crontab to keep the DNS entry up to date. For example, this can be done every 5 minutes. This could look like this:
```
*/5 * * * * bash /home/user/dyndns-update.sh >> /home/user/dyndns-update.log
```
