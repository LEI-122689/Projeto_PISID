import time
import pymongo
import mysql.connector

mongo_client = pymongo.MongoClient("mongodb://localhost:27017/")
mongo_database = mongo_client["pisid_maze"]
mongo_collection = mongo_database["sensor_data"]

while True:
    try:
        mysql_connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="pisid_maze",
            port=3306
        )
        mysql_cursor = mysql_connection.cursor()

        new_records = mongo_collection.find({"migrated": {"$ne": True}})

        for record in new_records:
            try:
                room_origin = record.get("RoomOrigin")
                room_destiny = record.get("RoomDestiny")
                marsami = record.get("Marsami")
                status = record.get("Status")

                insert_query = """
                               INSERT INTO medicoes_passagens (SalaOrigem, SalaDestino, Marsami, Status)
                               VALUES (%s, %s, %s, %s) \
                               """
                values = (room_origin, room_destiny, marsami, status)

                mysql_cursor.execute(insert_query, values)
                mysql_connection.commit()

                update_filter = {"_id": record["_id"]}
                update_action = {"$set": {"migrated": True}}
                mongo_collection.update_one(update_filter, update_action)

            except mysql.connector.Error:
                continue

        mysql_cursor.close()
        mysql_connection.close()

    except mysql.connector.Error:
        pass

    time.sleep(5)