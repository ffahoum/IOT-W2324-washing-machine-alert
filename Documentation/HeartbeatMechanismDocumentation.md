# HeartBeat Mechanism

The project will use a heartbeat mechanism to ensure connectivity between the ESP and firebase. This involves allocating a dedicated node in the Firebase RTDB for timestamps, which will be updated by the ESP. If the ESP fails to connect to WiFi or Firebase, these timestamp nodes will not be updated. We also have a cloud function continuously monitoring these timestamp nodes. If there is a delay of 3 minutes between the timestamps and the current time, the cloud function will trigger a push notification to alert the user about a potential issue or damage.

## HeartBeat Mechanism Implementation Description

The implemented heartbeat mechanism ensures continuous connectivity between the ESP device and Firebase. This is achieved by allocating a specific node within the Firebase Realtime Database (RTDB) to store timestamps. The ESP device updates these timestamp nodes at each loop.

Here's how the process works:

- The cloud function, named "washingMachineMonitor," is scheduled to run every 1 minute using Google Cloud Pub/Sub.
- Upon execution, the function retrieves the current time and calculates the timestamp threshold based on a predefined value (3 minutes).
- It then accesses the "timestamp" node in the Firebase RTDB to retrieve the timestamp of the last heartbeat recorded by the ESP device.
- If the difference between the current time and the last heartbeat timestamp exceeds the threshold, indicating a potential connectivity issue, the function proceeds to check if a notification has already been sent to the user using a boolean ‘notified’ node. If not, a push notification is sent to the users subscribed to the washing machine operated by the ESP system alerting them about the potential issue with the washing machine.
- After successfully sending the notification, the function updates the "notified" node in the database to indicate that a notification has been sent.
- If no connectivity issues are detected, or if the issue has been resolved, the function resets the notification status by updating the "notified" node accordingly.

Overall, this implementation ensures timely detection and notification of potential connectivity issues between the ESP device and Firebase, providing users with timely alerts to monitor the status of their washing machine.

## Cost

Each Google Cloud account is entitled to deploy up to three scheduled jobs without incurring charges. When discussing job scheduling, it's essential to consider the resources consumed, including cloud function invocations, reads and writes to the Firebase Realtime Database (RTDB), and network bandwidth usage.

The job scheduling itself is free because it falls within the quota of the initial three scheduled jobs. However, the reads and writes to the RTDB contribute to the download section of the costs. Each invocation of the cloud function consumes approximately 3KB of data for read/write operations. With 1440 invocations per day (60 invocations every hour for 24 hours), the daily data usage amounts to 4320KB.

Under the free tier, Google Cloud provides 360MB of data transfer per day. Given the daily data usage of 4320, we remain comfortably within the free tier limit. Additionally, Google Cloud offers a monthly quota of 2 million invocations, ensuring that our usage remains well within the allocated quota.

In summary, while job scheduling is free within the initial quota, it's important to monitor and manage resource consumption, especially regarding reads, writes, and network bandwidth, to avoid incurring additional costs.
