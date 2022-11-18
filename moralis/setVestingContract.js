var tools = require('./tools');
const myArgs = process.argv.slice(2);

async function doit() {

        try {
		console.log("jere");
                const ret = await tools.setVestingContract();
		console.log("gere");
        } catch (e) {
                console.log('error calling setVestingContract: ',  e);
                return;
        }
}

doit();

