pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minContribution) public {
        address newCampaign = new Campaign(minContribution);
        // add to the list of campaigns
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns(address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {

    struct Request {
        string description;
        uint value;
        address recipient;
        bool closed;
        uint approvalCount;
        mapping(address => bool) votes;
    }

    address public manager;
    uint public minContribution;
    mapping(address => bool) public approvers;
    uint public approversAmount;
    uint[] public contributionsValue;
    Request[] public requests;
    
    // modifiers usually add above constructor func
    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimalContribution) public {
        manager = tx.origin;
        minContribution = minimalContribution;
    }

    function contribute() public payable {
        require(msg.value >= minContribution);
        approvers[msg.sender] = true;
        contributionsValue.push(msg.value);
        approversAmount++;
    }

    function createRequest(string description, uint value, address recipient) public onlyManager {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            closed: false,
            approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint requestIndex) public {
        Request storage request = requests[requestIndex];
        // should be from approvers
        require(approvers[msg.sender]);
        // should vote only once per Request
        require(!request.votes[msg.sender]);

        // increment approvalCount on certain requestIndex
        request.approvalCount++;
        // add to already voted
        request.votes[msg.sender] = true;
    }

    function finalizeRequest(uint requestIndex) public onlyManager{
        Request storage request = requests[requestIndex];
        // it supposes to run once per money request
        require(!request.closed);
        // can be activated only if > than 50% of contributor's approved it
        require(request.approvalCount > approversAmount / 2);

        // withdraw money to the recipient
        request.recipient.transfer(request.value);
        // mark it as closed
        request.closed = true;
    }

    function cancelRequest(uint requestIndex) public onlyManager{
        Request storage request = requests[requestIndex];
        //should has opened status
        require(!request.closed);

        //close active request
        request.closed = true;
    }

    function getContractBalance() public view returns(uint){
        return this.balance;
    }
}