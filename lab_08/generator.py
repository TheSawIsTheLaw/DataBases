import json
from time import sleep
from datetime import *
from random import randint

currentID = 1

while currentID < 10:
    data = []
    for i in range(50):
        data.append({
            'debtorID': randint(1, 1000),
            'value': randint(1, 1000000),
            'dateOfPayment': "2020-{}-{}".format(randint(1, 12), randint(1, 28))
        })
    curTime = datetime.isoformat(datetime.now(), sep='_', timespec='seconds')
    curTime = curTime.replace(":", "_")
    file = open("{}_Pays_{}.json".format(currentID, curTime), "w+")
    json.dump(data, file)
    file.close()

    currentID += 1
    print("Successfully created. I want to sleep... 5 minutes.")
    sleep(60 * 5)
