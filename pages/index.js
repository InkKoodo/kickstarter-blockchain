import React from 'react';
import factoryInstance from '../ethereum/factory';


export const getStaticProps = async  () => {
  const campaigns = await factoryInstance.methods.getDeployedCampaigns.call();
  const test = JSON.parse(campaigns)
  return {
    props: {
      campaigns: test
    }
  }
};

const CampaignIndex = ({ campaigns }) => {
  console.log(campaigns);

  return (
    <ul>
      <li>
        {campaigns[0]}
      </li>
    </ul>
  )
}

export default CampaignIndex;

