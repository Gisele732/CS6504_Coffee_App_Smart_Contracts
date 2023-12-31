// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProducerRegistration.sol";
import "./TransitionContract.sol";

contract RetailerRegistration {

    ProducerRegistration public producerRegistration;
    CoffeeBatchMovement public coffeeBatchMovement;

    constructor(
            address _producerRegistrationAddress,
            address _coffeeBatchMovementAddress
        ) {
            producerRegistration = ProducerRegistration(_producerRegistrationAddress);
            coffeeBatchMovement = CoffeeBatchMovement(_coffeeBatchMovementAddress);
        }

    // struct that consolidates information from ProducerRegistration and TransitionContract
    struct FinalDetails {
        uint256 timestamp;
        string retailerName;
        string coffeeInformation;
        string coffeeMovements;
        uint256 retailPrice;
    }

    mapping(string=>FinalDetails) public finalDetails;

    // create a final product registration that will be used by the retailer
    function registerRetailCoffeeBatch (
        string memory _retailerName,
        string memory _batchId,
        uint256 _retailPrice) public {
            require(producerRegistration.isBatchRegistered(_batchId), "Batch ID not found");
            (string memory batchOrigin, string memory batchprocessingMethod, uint256 batchHarvestDate, string memory batchCertification) = producerRegistration.getBatchDetails(_batchId);
            finalDetails[_batchId] = FinalDetails({
                timestamp: block.timestamp,
                retailerName : _retailerName,
                coffeeInformation: producerRegistrationToString(
                    batchOrigin,
                    batchprocessingMethod,
                    batchHarvestDate,
                    batchCertification
                ),
                coffeeMovements : movementsToString(coffeeBatchMovement.getMovements(_batchId)),
                retailPrice : _retailPrice
            });
    }

    // Helper function to convert an array of Movement structs to a string
    function movementsToString(CoffeeBatchMovement.Movement[] memory movements) internal pure returns (string memory) {
        string memory result = "";
        for (uint256 i = 0; i < movements.length; i++) {
            string memory movementString = string(abi.encodePacked(
                "Timestamp: ", uintToString(movements[i].timestamp), "\n",
                "Location: ", movements[i].location, "\n",
                "Action: ", movements[i].action, "\n"
            ));
            result = string(abi.encodePacked(result, movementString));
        }
        return result;
    }

    // helper function to convert an array of ProducerRegistration structs to a string
   function producerRegistrationToString(string memory origin, string memory processingMethod, uint256 harvestDate, string memory certification) internal pure returns (string memory) {
        string memory result = "";
        string memory coffeeBatchString = string(abi.encodePacked(
            "Origin: ", origin, "\n",
            "processing Method: ", processingMethod, "\n",
            "Harvest Date: ", uintToString(harvestDate), "\n",
            "Certification: ", certification, "\n"
        ));
        result = string(abi.encodePacked(result, coffeeBatchString));
        return result;
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
}
    

     
