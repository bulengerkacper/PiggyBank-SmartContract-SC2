pragma solidity ^0.8.11;
//SPDX-License-Identifier: GPL-3.0

/* We steal less than ZUS and totally not goot at advertising */

contract Retirement {

    uint public startofRetirment;
    
	mapping(address => uint) accounts;
	address public owner;

	event IncomingPayment(address acc, uint256 amount);
	event OutgoingPayment(address acc, uint256 amount);

//default value should be useful but solidity seems to not have it.
	constructor(uint _howManyDays) {
		//convert_to_days=12*60*60*_whenEnd
		startofRetirment = block.timestamp + _howManyDays;
		owner=msg.sender;
	}

//czy push zadziala na aktualizacje !?
	receive() external payable {
        accounts[msg.sender]=accounts[msg.sender]+msg.value;
        emit IncomingPayment(msg.sender, msg.value);
        //owner.send(address(this).balance*0,001);
	}

	function take_pension () public {
        require(block.timestamp > startofRetirment);
        payable(msg.sender).transfer(accounts[msg.sender]);
        emit OutgoingPayment(msg.sender, accounts[msg.sender]);
	}
}