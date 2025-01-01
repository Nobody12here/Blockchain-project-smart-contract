// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(
        uint minimum,
        uint deadline,
        string memory name,
        string memory description,
        string memory image,
        uint target
    ) public {
        address newCampaign = address(
            new Campaign(
                minimum,
                msg.sender,
                deadline,
                name,
                description,
                image,
                target
            )
        );
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    address public manager;
    uint public minimunContribution;
    string public CampaignName;
    string public CampaignDescription;
    string public imageUrl;
    uint public targetToAchieve;
    uint256 public deadline;
    struct Contributions {
        address contributor;
        uint256 timestamp;
        uint256 amount;
    }

    address[] public contributers;
    Contributions[] public contributions;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    constructor(
        uint minimun,
        address creator,
        uint256 _deadline,
        string memory name,
        string memory description,
        string memory image,
        uint target
    ) {
        manager = creator;
        minimunContribution = minimun;
        CampaignName = name;
        CampaignDescription = description;
        imageUrl = image;
        targetToAchieve = target;
        deadline = _deadline;
    }

    function getContributions() public view returns (Contributions[] memory) {
        return contributions;
    }
    function contibute() public payable {
        require(msg.value > minimunContribution);
        require(block.timestamp < deadline, "The fundraising is over");
        contributers.push(msg.sender);
        contributions.push(
            Contributions({
                contributor: msg.sender,
                amount: msg.value,
                timestamp: block.timestamp
            })
        );
    }

    function withdraw() public restricted {
        uint256 balance = address(this).balance;

        // Check if the campaign has achieved its target
        require(
            balance >= targetToAchieve,
            "The target has not been reached yet"
        );
        // Ensure the fundraising period is over
        require(block.timestamp > deadline, "The fundraising is not over yet");

        // Transfer the balance to the manager
        (bool success, ) = payable(manager).call{value: balance}("");
        require(success, "Transfer failed");
    }

    function getSummary()
        public
        view
        returns (
            uint,
            uint,
            uint,
            address,
            string memory,
            string memory,
            string memory,
            uint
        )
    {
        return (
            minimunContribution,
            address(this).balance,
            deadline,
            manager,
            CampaignName,
            CampaignDescription,
            imageUrl,
            targetToAchieve
        );
    }
    
}
