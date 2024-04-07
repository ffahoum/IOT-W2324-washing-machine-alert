import functions = require('firebase-functions');
import admin = require('firebase-admin');
admin.initializeApp();

exports.sendWashingCycleFinishNotification = functions.database.
ref("washing_machines/{washing_machine_id}/status/").onUpdate(async (snapshot, context) => {
    const status_before_update : boolean = snapshot.before.val();
    const status_after_update : boolean = snapshot.after.val();
    if (status_before_update == true && status_after_update == false)
    {
        await handleMachineFinished(context.params['washing_machine_id']);
    } else {
        await handleMachineStarted(context.params['washing_machine_id']);
    }
});

function getOptionMins(option: String) {
    switch(option) {
      case "Quick Wash":
      return 3;
      case "Normal Wash":
      return 5;
      case "Delicate Wash":
      return 10;
      default:
      return 10;
    }
  }

function mapMachineIdToName(machineId: String) {
    switch (machineId) {
        case "aqua_sonic_deluxe":
            return 'AquaSonic Deluxe';
        case "eco_clean_pro":
            return "EcoClean Pro";
        case "fresh_cycle_max":
            return "FreshCycle Max";
        case "turbo_wash_elite":
            return "TurboWash Elite";
        default:
            return "default_machine_id";
    }
}

async function  handleMachineFinished(machineId: String)  {
    const machineName = mapMachineIdToName(machineId);
    const subscriberSnapshot = await admin.database().ref(`/washing_machines/${machineId}/subscribers`).once('value');
    const subscribers = subscriberSnapshot.val();
    if (subscribers) {
        const subscribersList: string[] = Object.values(subscribers);
        const usersSnapshot = await admin.database().ref(`/users`).once('value');
        const users = usersSnapshot.val();
        const messaging_tokens: string[] = [];
        for (let i = 0; i < subscribersList.length; i++) {
            if (i == 2) {
                break;
            }
            messaging_tokens.push(users[subscribersList[i]]["token"])
        }
        try {
            const cycleOptionSnapshot = await admin.database().ref(`/users/${subscribersList[0]}/jobs/${machineId}/option`).once('value');
            const startTimeSnapshot = await admin.database().ref(`/users/${subscribersList[0]}/jobs/${machineId}/start_time`).once('value');
            
            const cycleOption = cycleOptionSnapshot.val();
            const startTime = startTimeSnapshot.val();
            const duration = getOptionMins(cycleOption);
            const endTimeUnix = startTime + (duration * 60 * 1000);
            const beforeTime = endTimeUnix > Date.now();
            // Sending a notification to the washing job scheduler - first on subscribers list
            const schedulerToken = messaging_tokens[0];
            if (beforeTime) {
                await admin.messaging().send({
                    token: schedulerToken,
                    notification: {
                    title: 'Cycle Completed Early',
                    body: `${machineName} has finished its cycle earlier than anticipated.`,
                    },
                    android: {
                        priority: 'high',
                    }
                });
            } else {
                await admin.messaging().send({
                    token: schedulerToken,
                    notification: {
                    title: 'Ding-dong! Your laundry is calling.',
                    body: `The washing cycle with ${machineName} has completed, and your clothes are eagerly waiting for you.`,
                    },
                    android: {
                        priority: 'high',
                    }
                });
            }
            // Sending a notification to the first waiting if exists that the machine is free now
            if (messaging_tokens.length > 1) {
                const firstOnWaitingListToken = messaging_tokens[1];
                await admin.messaging().send({
                    token: firstOnWaitingListToken,
                    notification: {
                    title: 'Machine Ready',
                    body: `Your wait is over. ${machineName} is ready and waiting just for you! It's your time to shine!`,
                    },
                    android: {
                        priority: 'high',
                    }
                });
            }
        } catch (error) { 
            console.log('Error sending notification:', error);
        }
        for (let i = 0; i < subscribersList.length; i++) {
            const userRef = admin.database().ref(`/users/${subscribersList[i]}/subscribed_machines/${machineId}`);
            const snapshot = await userRef.once('value');
            if (snapshot.exists()) {
                // Updating machine list for waiting subscribers
                await userRef.update({ status: false });
            } else {
                // Machine finished then removing the job for the scheduler and removing him for the subscription list
                await admin.database().ref(`/users/${subscribersList[i]}/jobs/${machineId}`).remove();
                await admin.database().ref(`/washing_machines/${machineId}/subscribers/0`).remove();
            }
        }
        const newSubscribersList: { [key: string]: any } = {};
        for (let i = 0; i < subscribersList.length - 1; i++) {
            newSubscribersList[i] = subscribersList[i + 1];
        }
        const subscribersRef = admin.database().ref(`/washing_machines/${machineId}/subscribers`);
        console.log(newSubscribersList);
        await subscribersRef.set(newSubscribersList);

    }
}

async function handleMachineStarted(machineId: String) {
    const subscriberSnapshot = await admin.database().ref(`/washing_machines/${machineId}/subscribers`).once('value');
    const subscribers = subscriberSnapshot.val();
    if (subscribers) {
        const tokens: string[] = Object.values(subscribers);
        for (let i = 0; i < tokens.length; i++) {
            const userRef = admin.database().ref(`/users/${tokens[i]}/subscribed_machines/${machineId}`);
            const snapshot = await userRef.once('value');
            if (snapshot.exists()) {
                // Updating machine status for waiting subscribers
                await userRef.update({ status: true });
            } else {
                // Updating machine status for scheduler and updating the start time as well
                await admin.database().ref(`/users/${tokens[i]}/jobs/${machineId}`).update({status: "In Progress", start_time: Date.now()})
            }
        }
    }
}

exports.sendWashingMachineDoorOpen = functions.database.
ref("washing_machines/{washing_machine_id}/door_open").onUpdate(async (snapshot, context) => {
    const is_open_before_update : boolean = snapshot.before.val();
    const is_open_after_update : boolean = snapshot.after.val();
    if (is_open_before_update == false && is_open_after_update == true) {
        const subscriberSnapshot = await admin.database().ref(`/washing_machines/${context.params['washing_machine_id']}/subscribers`).once('value');
        const subscribers = subscriberSnapshot.val();
        const statusSnapshot = await admin.database().ref(`/washing_machines/${context.params['washing_machine_id']}/status`).once('value');
        const status = statusSnapshot.val();
        const subscribersList : string[] = Object.values(subscribers);
        const machineName = mapMachineIdToName(context.params['washing_machine_id']);
        if (subscribersList.length > 0 && status) {
            try {
                const tokenSnapshot = await admin.database().ref(`/users/${subscribersList[0]}/token`).once('value');
                const token = tokenSnapshot.val();
                await admin.messaging().send({
                    token: token,
                    notification: {
                    title: `Uh-oh! Looks like someone's eager to get their laundry done.`,
                    body: `${machineName} door has been opened.`,
                    },
                    android: {
                        priority: 'high',
                    }
                });
                console.log('Notification sent successfully.');
            } catch (error) {
              console.log('Error sending notification:', error);
          }
        }
    }
})

exports.sendInvalidIntensity = functions.database.
ref("washing_machines/{washing_machine_id}/thresholds/{intensity}/").onUpdate(async (snapshot, context) => {
    const status_before_update : boolean = snapshot.before.val();
    const status_after_update : boolean = snapshot.after.val();
    const subscriberSnapshot = await admin.database().ref(`/washing_machines/${context.params['washing_machine_id']}/subscribers`).once('value');
    const subscribers = subscriberSnapshot.val();
    const subscribersList : string[] = Object.values(subscribers);
    const statusSnapshot = await admin.database().ref(`/washing_machines/${context.params['washing_machine_id']}/status`).once('value');
    const status = statusSnapshot.val();
    const machineName = mapMachineIdToName(context.params['washing_machine_id']);
    if (subscribersList.length > 0 && status)
    {
        const tokenSnapshot = await admin.database().ref(`/users/${subscribersList[0]}/token`).once('value');
        const token = tokenSnapshot.val();
        const optionSnapshot = await admin.database().ref(`/users/${subscribersList[0]}/jobs/${context.params['washing_machine_id']}/intensity`).once('value');
        const option: string = optionSnapshot.val().toLowerCase();
        if (option == context.params['intensity'])
        {
            if (status_before_update == true && status_after_update == false)
            {
                try {
                    await admin.messaging().send({
                        token: token,
                        notification: {
                        title: `${machineName} Intensity Issue`,
                        body: `Deviation in intensity detected. Please check settings.`,
                        },
                        android: {
                            priority: 'high',
                        }
                    });
                    console.log('Notification sent successfully.');
                } catch (error) { 
                    console.log('Error sending notification:', error);
                }
            } else if (status_before_update == false && status_after_update == true) {
                try {
                    await admin.messaging().send({
                        token: token,
                        notification: {
                        title: `${machineName} Intensity Issue Resolved`,
                        body: `Intensity has returned to normal levels. Issue resolved.`,
                        },
                        android: {
                            priority: 'high',
                        }
                    });
                    console.log('Notification sent successfully.');
                } catch (error) { 
                    console.log('Error sending notification:', error);
                }
            }
        }    
    }
});


exports.washingMachineHealthMonitor = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
    const thresholdMinutes = 3;
    const currentTime = Math.floor(Date.now() / 1000);
    try {
        const machinesSnapshot = await admin.database().ref(`washing_machines`).once('value');
        const washingMachines = machinesSnapshot.val();
        for (const machineId in washingMachines) {
            const machineData  = washingMachines[machineId];
            const machineName = mapMachineIdToName(machineId);
            const lastHeartbeat = machineData.timestamp;
            const notified = machineData.notified;
            console.log(`Last heart beat is: ${lastHeartbeat}`);
            console.log(`Current time is: ${currentTime}`);
            if (lastHeartbeat && (currentTime - lastHeartbeat) > (thresholdMinutes * 60)) {
                if (!notified) {
                    console.log("Sending notification to the subscribers");
                    const subscribers = machineData.subscribers;
                    if (subscribers) {
                        const usersSnapshot = await admin.database().ref(`/users`).once('value');
                        const users = usersSnapshot.val();
                        console.log(subscribers);
                        console.log(users);
                        const messaging_tokens: string[] = [];
                        for (let i = 0; i < subscribers.length; i++) {
                            messaging_tokens.push(users[subscribers[i]]["token"])
                        }
                        try {
                            await admin.messaging().sendEachForMulticast({
                                tokens: messaging_tokens,
                                notification: {
                                title: 'Washing Machine Emergency',
                                body: `Alert: An issue has been detected with ${machineName}. Please check its status for further details.`,
                                },
                                android: {
                                    priority: 'high',
                                }
                            });
                            console.log('Notification sent successfully.');
                            await admin.database().ref(`/washing_machines/${machineId}/notified`).set(true);
                        } catch (error) {
                            console.log('Error sending notification:', error);
                        }
                }
                }
            } else {
                if (notified) {
                    await admin.database().ref(`/washing_machines/${machineId}/notified`).set(false);
                    console.log('Notification status reset: timestamp is okay.');
                }
            }
        }
    } catch (error) {
        console.error('Error reading database:', error);
    }
});