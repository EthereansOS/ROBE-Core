const configuration = require('./configuration').configuration;
const fs = require('fs');
const Aion = require('aion-web3');
const aion = new Aion(configuration.apiKey);

let account = aion.eth.accounts.privateKeyToAccount(configuration.privateKey);

async function main() {
    var balance = await aion.eth.getBalance(account.address);
    balance = aion.utils.fromNAmp(balance, 'aion');
    var compiledContract = await getCompiledContract();
    var index = fs.readFileSync('./index_template.html', 'utf-8');
    index = index.split('__CONTRACT_ABI__').join(JSON.stringify(compiledContract.RobeHTMLWrapper.info.abiDefinition));
    if(fs.existsSync('./index.html')) {
        fs.unlinkSync('./index.html');
    }
    fs.writeFileSync('./index.html', index);
/*    let contractInst = new aion.eth.Contract(compiledContract.RobeHTMLWrapper.info.abiDefinition);

    let deploy = contractInst.deploy({ data: compiledContract.RobeHTMLWrapper.code, arguments: ['0x0'] }).encodeABI();

    let deployTx = { gas: 4000000, gasPrice: 10000000000, data: deploy, from: account.address };

    var signedTx = await aion.eth.accounts.signTransaction(deployTx, account.privateKey);

    aion.eth.sendSignedTransaction(signedTx.rawTransaction 
        ).on('receipt', receipt => { 
           console.log("Receipt received!\ntxHash =", receipt.transactionHash, 
                       "\ncontractAddress =", receipt.contractAddress);
             ctAddress = receipt.contractAddress;
      });*/
}

async function getCompiledContract() {
    var contract = await getContractSource();
    var compiledContract = await aion.eth.compileSolidity(contract);
    return compiledContract;
}

function getContractSource() {
    return new Promise(function(ok, ko) {
        fs.readdir('./', function(err, items) {
            var contract = 'pragma solidity ^0.4.0;\n';
            if(err) {
                ko(err);
                return;
            }
            for (var i = 0; i < items.length; i++) {
                var path = './' + items[i];
                if(path.indexOf('.sol') !== -1) {
                    contract += (getContractContent(path) + '\n');
                }
            }
            ok(contract);
        });
    });
}

function getContractContent(path) {
    var contract = fs.readFileSync(path, 'utf-8').split('\n');
    var lines = [];
    for(var i in contract) {
        var line = contract[i];
        if(line.indexOf('pragma ') === 0 || line.indexOf('import ') === 0) {
            continue;
        }
        lines.push(line);
    }
    return lines.join('\n');
}

main().catch(console.error);