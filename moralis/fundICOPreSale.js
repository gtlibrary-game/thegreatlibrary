var tools = require('./tools');
const myArgs = process.argv.slice(2);
const _amount = myArgs[0];


async function doit() {

        try {
                // Read the file's string contents directly into the contractid
                const ret = await tools.fundICOPreSale(_amount)
        } catch (e) {
                console.log('error calling fundICOPreSale: ',  e);
                return;
        }
}

doit();

