const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

// remove build folder
const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath)

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
// grab source code from our contract
const source = fs.readFileSync(campaignPath, "utf8");
// compile source code & extract only contracts object from it 
const output = solc.compile(source, 1).contracts;
console.log(source)
// check for existing & create a new directory if it don't exist
fs.ensureDirSync(buildPath);

// create files with our extracted source code
for(let contract in output) {
  fs.outputJSONSync(
    path.resolve(buildPath, `${contract.replace(":", "")}.json`),
    output[contract]
  );
}
