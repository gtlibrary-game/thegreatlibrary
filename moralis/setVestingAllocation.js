var tools = require('./tools');
const myArgs = process.argv.slice(2);

async function doit() {

        try {
                const ret = await tools.setVestingAllocation();
        } catch (e) {
                console.log('error calling setVestingContract: ',  e);
                return;
        }
}

doit();

