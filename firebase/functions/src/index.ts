import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp()

export const onBinUpdate = functions.firestore.document('bins/{binId}').onUpdate(async change => {
    const after = change.after

    // Check if it is 10 minites after last notification
    //const last = after.get('notification_stamp')
    const now = admin.firestore.FieldValue.serverTimestamp()
    console.log(now)

    let msgContent = ''
    if(after.get('fill_level') >= 0.7)
        msgContent = 'Garbage ready to be collected!\n'
    if(after.get('fill_level') >= 0.9)
        msgContent = 'Bin filled, collect immediately!\n'
    if(after.get('co_level') >= 0.7)
        msgContent += 'Excess gas content, clean immediately!\n'
    if(after.get('is_fire'))
        msgContent += 'Emergency : Bin is in Fire !!!\n'
    if(after.get('is_tilt'))
        msgContent += 'Emergency : Bin fell down\n'
    
    // No need for notification
    if(msgContent.length == 0)
        return null;

    const msg = {
        notification : {
            title : `Bin : ${after.id}`,
            body : msgContent,
        }
    }

    // Update last notification timestamp in firestore
    // await admin.firestore().collection(`bins`).doc(after.id).update({
    //     notification : admin.firestore.FieldValue.serverTimestamp()
    // })

    let tokens = ['fDHTvz0lY7Y:APA91bGzVSDraL6f1zoNZaZe8aiYq1iOzGx3xQ6_kps6TTkG0LLjC-y69K4bmPFthgfHX_e5U33bIiIQNdjht4DaXZWeNIIljIF1IcvokwcW77AIVOEbYkoLPF-ytAnY-DJH5XNk6Emn',
                    'cTK4zY18iOw:APA91bG38033nH4HVgH6PVyPjxAxAWypyh5_gi3UMtSyiCHKQwKF4h95buL9xv4kriRS8AJnMNCCOv7oSYfC7BbPjcWoaGy2gk3mEUCMhjZtrrqcdaNqY0btj7QM9UjWke_eYnU6bzSG',
                    'dQGzAuDvp4w:APA91bGX8q385AcZ8P7KqpG70hiDpP-RWfLdl3w_EzRZZfVNFT-GcSCtnL68AXpCYBSj1nWBVU97Het06Kkg69yC_1rYeGKg9E69qC2YFAYULN1RGb5niRsQv1Pd_bfXtyAGAMVWVBbt']
    return admin.messaging().sendToDevice(tokens , msg)
})

export const getBins = functions.https.onRequest(async (request, response) => {
    try{
        const snapshot = await admin.firestore().collection('bins/').get()
        const bins = new Map
        snapshot.forEach(binDoc => {
            bins.set(binDoc.id, binDoc.data())
        })
        console.log(bins)
        response.send(bins)
    }catch(error){
        console.log(error)
    }
})


// Needs blaze biling to implement scheduler
// Upgrade to blaze plan to use this function
//
// exports.scheduledFunction = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
//     try{
//         const snapshot = await admin.firestore().collection('bins/').get()
//         snapshot.forEach(binDoc => {
//             const bin = binDoc.data()
//             let msgContent = ''
//             if(bin.get('fill_level') >= 0.7)
//                 msgContent = 'Garbage ready to be collected!\n'
//             if(bin.get('fill_level') >= 0.9)
//                 msgContent = 'Bin filled, collect immediately!\n'
//             if(bin.get('co_level') >= 0.7)
//                 msgContent += 'Excess gas content, clean immediately!\n'
//             if(bin.get('is_fire'))
//                 msgContent += 'Emergency : Bin is in Fire !!!\n'
//             if(bin.get('is_tilt'))
//                 msgContent += 'Emergency : Bin fell down\n'
            
//             // Dont notify if no content in message
//             if(msgContent.length == 0)
//                 return null;
            
//             console.log(bin.id)
//             console.log(bin.get('fill_level'))

//             const msg = {
//                 notification : {
//                     title : `Bin : ${bin.id}`,
//                     body : msgContent,
//                 }
//             }

//             return admin.messaging().sendToDevice('cq1va8OC3sU:APA91bH6qT8vluHM9YQnAWn7n_E9TIL7oWDEES5ZccftzYPIWxLqk6GBM7MChi6IZQ-zDxtxIIXrE4-GFsCi7rtuiM4EhVkbCeCaDDZJ4SdNSACbijdQR5y1fd9O7CIbfe1J1WsRdTyt' , msg)
//         })

//     }catch(error){
//         console.log(error)
//     }
// });

export const test = functions.https.onRequest((request, response) => {
    admin.firestore().collection(`bins`).doc('t0000000003').update({
        notification_stamp : admin.firestore.FieldValue.serverTimestamp()
    })
    .then(() => {
        response.send('done')
    })
    .catch(error => {
        response.send(error)
    })
})