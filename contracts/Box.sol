// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Import Ownable from the OpenZeppelin Contracts library
// document: https://docs.openzeppelin.com/contracts/5.x/
import "@openzeppelin/contracts/access/Ownable.sol";

// Make Box inherit from the Ownable contract
contract Box is Ownable {
    uint256 private _value;

    event ValueChanged(uint256 value);

    constructor() Ownable(msg.sender) {}

    // The onlyOwner modifier restricts who can call the store function
    function store(uint256 value) public onlyOwner {
        _value = value;
        emit ValueChanged(value);
    }

    function retrieve() public view returns (uint256) {
        return _value;
    }
}