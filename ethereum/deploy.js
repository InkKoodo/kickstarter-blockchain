const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const { interface: factoryInterface, bytecode: factoryBytecode } = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
  'amazing neutral shadow congress protect huge palace gas erosion ball tragic tilt',
  'https://rinkeby.infura.io/v3/5e10e4b09d3042b18a34d1fc5ca8eae4'
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(factoryInterface))
    .deploy({ data: factoryBytecode })
    .send({ from: accounts[0], gas: '1000000' });

  console.log('Contract deployed to', result.options.address);
  provider.engine.stop();
};
deploy();
