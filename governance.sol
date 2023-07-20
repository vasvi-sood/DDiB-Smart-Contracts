// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.2/access/Ownable.sol";

contract GovernanceToken is ERC20, Ownable {
    constructor() ERC20("Governnace token", "comDo") {}
    mapping(address => bool) gtoken;
    function mint(address to) public onlyOwner {
        // an adress should not hold more than one token
        require(isAddressPresent(to)==false,"one account can hold one governance token");
        gtoken[to]=true;
        _mint(to, 1);
    }
    function isAddressPresent(address addr) public view returns (bool) {
        // If the value is empty, the address is not present in the mapping
        return gtoken[addr];
    }

    
    
}
