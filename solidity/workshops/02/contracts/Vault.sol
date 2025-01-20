// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity <= 0.8.28;

// revert failed transfer token (rollback process)
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// prevent withdrawal token, only specific account can withdraw.
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract Vault is Ownable, AccessControl {

  IERC20 private token;
  // ERC721 private myNFT;
  uint256 public maxWithdrawAmount;
  bool public withdrawEnable;
  bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAW_ROLE");

  function setWithdrawEnable(bool _isEnable) public onlyOwner {
    withdrawEnable = _isEnable;
  }

  function setMaxWithdrawAmount(uint256 _amount) public onlyOwner {
    maxWithdrawAmount = _amount;
  }

  function setToken(IERC20 _token) public onlyOwner {
    token = _token;
  }

  constructor() {}

  function withdraw(
    uint256 _amount,
    address _to
  ) external onlyWithdrawer {
    require(withdrawEnable, "Withdraw is not enable");
    require(_amount <= maxWithdrawAmount, "Exceed maximum amount");
    token.transfer(_to, _amount);
  }

  function deposit (
    uint256 _amount
  ) external {
    require(token.balanceOf(msg.sender) >= _amount, "Insuffcient account balance");
    SafeERC20.safeTransferFrom(token, msg.sender, address(this), _amount);
  }

  modifier onlyWithdrawer() {
    require(owner() == _msgSender() || hasRole(WITHDRAWER_ROLE, _msgSender()), "Caller is not a withdrawer");
    _;
  }

}