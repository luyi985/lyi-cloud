const aws = require("aws-sdk");
const s3 = new aws.S3();
const s3Wrapper = (params, op) => new Promise(resolve => {
    if( typeof op !== "string" || !!!op || !!!op.length)
    throw new Error('Not proper s3 method');

    s3[op](params, (err, data) => {
        if (err) throw new Error(err);
        resolve(data);
    })
})

async function play(event, context, callback){
    try {
        const fileObj = await s3Wrapper({
            Bucket: "lyi-bucket",
            Prefix: "files/"
        }, 'listObjectsV2');

        const img = await s3Wrapper({
            Bucket: "lyi-bucket",
            Key: "files/little-kitty.jpeg"
        }, 'getObject');

        console.log('----img-----', img)
        console.log('----fileObj------', fileObj)
    } catch(e) {
        console.log("e")
    }
}

play()

exports.handler = play;