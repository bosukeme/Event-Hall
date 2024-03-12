// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Rent an Event Hall for 1 week ( day 1 to day 7)
// Every additional day gets 1% bonus
// Pay owner in ETH

contract EventHall {

    address payable public owner;

    enum Availability {BOOKED, FREE}
    Availability public eventHallAvailbility;

    constructor() {
        owner = payable(msg.sender);
        eventHallAvailbility = Availability.FREE;
    }

    modifier checkHallStatus {
        require(eventHallAvailbility == Availability.FREE, "Event Hall has already been booked");
        _;
    }

    event Booked(address occupant, uint256 amountPaid, uint256 daysBooked);

    function rentEventhall(uint _days) public payable checkHallStatus {
        
        require(_days > 0 && _days < 8, "Booking should be 1 to 7 days");

        uint256 amountToPay  = _days * 1 ether;

        require(amountToPay < msg.value, "You are to pay 1 Eth per booking day!");
        
        uint256 bonusAmountToPay = (amountToPay * _days) / 100;
        amountToPay -= bonusAmountToPay;

        // owner.transfer(msg.value);
        (bool paid, )= owner.call{value: msg.value}("");
        require(paid, "Unable to complete transaction");
        eventHallAvailbility = Availability.BOOKED;
        emit Booked(msg.sender, amountToPay, _days);

    }
}
