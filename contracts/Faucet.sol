// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import "./IERC20.sol";

contract Faucet {
    uint256 public amountAllowed = 100;//每次领100单位代币
    address public tokenContract; //token合约地址
    mapping (address => bool) public requestedAddress; //记录领取过代币的地址

    event SendToken(address indexed Receiver, uint256 indexed Amount);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestTokens() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times");
        IERC20 token = IERC20(tokenContract);
        bool isAmountEnough = false;
        if (token.balanceOf(address(this)) >= amountAllowed) {
            isAmountEnough = true;
        }
        require(isAmountEnough, "Faucet Empty!");//水龙头空了

        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;//记录领取地址

        emit SendToken(msg.sender, amountAllowed);//释放SendToken事件
    }
}
