import web3 from './web3';
import { interface } from './build/CampaignFactory.json';

const factoryInstance = new web3.eth.Contract(
  JSON.parse(interface),
  '0xb0d034F69309c6F295397c05CDB9A37ed4B2B634'
);

export default factoryInstance;