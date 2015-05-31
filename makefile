setup:
	git config core.fileMode false
	curl https://install.meteor.com | /bin/sh

export_db:
	mongodump -h 127.0.0.1 --port 3001 -d meteor

import_db:
	# From MiniMongo shell, enter: db.collectionName.drop(); repeat for all collections you wish to restore
	mongorestore -h 127.0.0.1 --port 3001 -d meteor dump/meteor