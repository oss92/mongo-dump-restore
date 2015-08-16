if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

first_db=first_db_name
second_db=new_db_name
mongo_dbpath=/var/lib/mongo
collections=( collection_1 collection_2 )

for c in ${collections[@]}
do
  mongodump -d $first_db -c $c
done

echo "[SUCCESS] Done dumping"
service mongod stop
echo "[SUCCESS] Stopped mongo"
mongorestore --dbpath $mongo_dbpath --db $second_db dump/$first_db/
echo "[SUCCESS] Done restoring"
chown mongod:mongod $mongo_dbpath/*
service mongod start
echo "[SUCCESS] Started mongo"