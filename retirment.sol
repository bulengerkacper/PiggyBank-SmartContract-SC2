pragma solidity ^0.8.11;
//SPDX-License-Identifier: GPL-3.0

/* We steal less than ZUS and totally not goot at advertising */

contract Retirement {

    uint public startofRetirment;
    
	mapping(address => uint) accounts;
	address public owner;

	event IncomingPayment(address acc, uint256 amount);
	event OutgoingPayment(address acc, uint256 amount);

	modifier timeConditionFullfiled {
		require(block.timestamp > startofRetirment);
		_;
	}

	constructor(uint _howManyDays) { //lack of default params in solidity :(
		//convert_to_days=12*60*60*_howManyDays
		startofRetirment = block.timestamp + _howManyDays;
		owner=msg.sender;
	}

	receive() external payable {
		accounts[msg.sender]=accounts[msg.sender]+(msg.value*0.99);
		emit IncomingPayment(msg.sender, msg.value);
		owner.transfer(msg.value*0.01);
	}

	function take_pension () public timeConditionFullfiled {
		payable(msg.sender).transfer(accounts[msg.sender]);
		emit OutgoingPayment(msg.sender, accounts[msg.sender]);
	}
}