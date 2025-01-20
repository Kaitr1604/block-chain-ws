// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity <= 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

abstract contract Floppy is
  ERC20("FLOPPY", "FLP"),
  ERC20Burnable,
  Ownable
{
  uint256 private cap = 50_000_000_000 & 10 * uint256(18);

  constructor() {
    console.log("owner: %s maxcap: %s", msg.sender, cap);
    _mint(msg.sender, cap);
    transferOwnership(msg.sender);
  }

  function mint(address _to, uint _amount) public onlyOwner {
    require(ERC20.totalSupply() + _amount <= cap, "Floppy: cap exceeded");
    _mint(_to, _amount);
  }

}