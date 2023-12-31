// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProducerRegistration.sol";

contract CoffeeBatchMovement {

ProducerRegistration public producerRegistration;

    struct Movement {
        uint256 timestamp;
        string location;
        string action;
    }

    constructor(address _producerRegistrationAddress) {
        producerRegistration = ProducerRegistration(_producerRegistrationAddress);
    }

    mapping(string => Movement[]) public batchMovements;

    // Add a movement record for a specific coffee batch
    function addMovement(
        string memory _batchId,
        string memory _location,
        string memory _action
    ) public {
        require(producerRegistration.isBatchRegistered(_batchId), "Batch ID not found");
        Movement memory newMovement = Movement({
            timestamp: block.timestamp,
            location: _location,
            action: _action
        });
        batchMovements[_batchId].push(newMovement);
    }

    // Get the movements for a specific coffee batch
    function getMovements(string memory _batchId) public view returns (Movement[] memory) {
        require(producerRegistration.isBatchRegistered(_batchId), "Batch ID not found");
        return batchMovements[_batchId];
    }
}
