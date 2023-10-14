// Producer Registration Contract
// Purpose: 
// - Allows coffee producers to register their product.
// Key Features:
// - Register a new batch of coffee with details like origin, method of cultivation, harvest date, and any certifications.
// - Update details of a batch if necessary.
// - Retrieve details of a batch.

// TODO: Create a batch detail update function

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProducerRegistration {

    // characteristics of a coffee batch for the purpose of tracking
    struct CoffeeBatch {
        string origin;
        string cultivationMethod;
        uint256 harvestDate;
        string certification;
        bool isRegistered; //should this be set to false by default?
    }

    // Mapping to store coffee batches against a unique batch ID
    mapping(string => CoffeeBatch) public coffeeBatches;

    // function to register a new coffee batch
    function registerBatch(
        string memory _batchId,
        string memory _origin,
        string memory _cultivationMethod,
        uint256 _harvestDate,
        string memory _certification
    ) public {
        require(!coffeeBatches[_batchId].isRegistered, "Batch ID already registered.");
        coffeeBatches[_batchId] = CoffeeBatch({
            origin: _origin,
            cultivationMethod: _cultivationMethod,
            harvestDate: _harvestDate,
            certification: _certification,
            isRegistered: true
        });
    }

    // retrieve the details of a coffee batch using its batch ID
    function getBatchDetails(string memory _batchId) public view returns (string memory, string memory, uint256, string memory) {
        require(coffeeBatches[_batchId].isRegistered, "Batch ID not found.");
        CoffeeBatch memory batch = coffeeBatches[_batchId];
        return (batch.origin, batch.cultivationMethod, batch.harvestDate, batch.certification);
    }
    
    // Helper function to convert a uint256 to a string
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }


    function isBatchRegistered(string memory _batchId) public view returns (bool) {
    return coffeeBatches[_batchId].isRegistered;
}
}

