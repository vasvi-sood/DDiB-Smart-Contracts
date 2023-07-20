// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.20;

// Import the ERC-20 interface from OpenZeppelin

contract Donation {


  
    // Structure to store organization details

    enum State { Review, Collecting, Completed }
    struct Organization {
        address orgAddress;
        string name;
        string description;
        uint256 amountToCollect;
        State state;
    }

    // Map to store organizations
    mapping(uint256 => Organization) public organizations;
    mapping(uint256 => bool) public isStarred;
    constructor() {
        // Replace the following details with the desired organization information
        address orgAddress = msg.sender; // The contract deployer's address will be the organization's address
        string memory name = "Support the Developer";
        string memory description = "Theis will be deployed on the genesis.The developer of the application is seeking your support.";
        uint256 amountToCollect = 100 ether; // Amount to collect in wei (e.g., 100 ether)
        uint256 amountCollected = 0; // Initial amount collected is zero
        // Add the organization to the map
        organizations[0] = Organization(orgAddress, name, description, amountToCollect,State.Collecting);
    }

    // Function to add an organization
    function addOrganization(
        uint256 id,
        address orgAddress,
        string memory name,
        string memory description,
        uint256 amountToCollect
    ) public {
        // Verify if the organization ID already exists in the map
        require(organizations[id].orgAddress == address(0) , "Organization ID already exists");
        // Create a new organization and add it to the map
        organizations[id] = Organization(orgAddress, name, description, amountToCollect,State.Review);
    }

    // Function to retrieve organization details by ID (read-only)
    function getOrganizationDetails(uint256 id) public view returns (address, string memory, string memory, uint256, State) {
        return (
            organizations[id].orgAddress,
            organizations[id].name,
            organizations[id].description,
            organizations[id].amountToCollect,
            organizations[id].state
        );
    }

function donate(uint256 id) public payable
    {
        uint amt=organizations[id].amountToCollect-msg.value;
        require(amt>=0,"you cannot add more amount than required");
        require(organizations[id].state==State.Collecting,"only send funds to organisation that are in the collecting period");
        organizations[id].amountToCollect=amt;
    }

// if the organisations needs to be removed
    function removeOrg(uint256 id) public 
    {
        //check if the organisation exists
        require(organizations[id].orgAddress != address(0),"The organisation id does not exist");
        delete organizations[id];
    }
// only person holding the governance token can acess this function
    function report(uint256 id) public 
     {
        removeOrg(id);
     }

     // change status from Review to Collecting after a fixed no of days
     function changeStatusToCollecting(uint256 id) public
     {
         require(organizations[id].state==State.Review, "change state only if it is review");
         organizations[id].state=State.Collecting;
     }
     //change state from Colllecting to fixed to completed once the funds are raised
       function changeStatusToCompleted(uint256 id) public
     {
         require(organizations[id].state==State.Collecting, "change state only if it is collecting");
         organizations[id].state=State.Completed;
     }

// using the governance token any individual can star an organisation they support
     function star(uint256 id) public
     {
        isStarred[id]=true;
     }
}

