#!/bin/bash
# This is mikey weeks and I approve this docker standup script
/usr/bin/fleet prepare db \
	--mysql_address=db.fleet.priv:3306 \
	--mysql_database=kolide \
	--mysql_username=root \
	--mysql_password=pleaseH1DEme!

/usr/bin/fleet serve \
	--mysql_address=db.fleet.priv:3306 \
	--mysql_database=kolide \
	--mysql_username=root \
	--mysql_password=pleaseH1DEme! \
	--redis_address=ec.fleet.priv:6379 \
	--server_cert=/opt/fleet/certs/kolide.cert \
	--server_key=/opt/fleet/certs/kolide.key \
	--auth_jwt_key=TXRd+3s8wmQeAfEmIUuVCCyWqjX8c3R+ \
	--logging_json
