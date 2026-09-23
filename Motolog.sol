// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Motolog
/// @notice On-chain service history log for vehicles and other physical assets.
contract Motolog {

    struct ServiceRecord {
        string serviceType;   // Example: "Engine Oil Change - Shell 10W-40"
        string technician;    // Technician or workshop name
        string ownerName;     // Name of the owner at the time of service
        string notes;         // Additional service notes
        uint256 mileage;      // Vehicle mileage at the time of service
        uint256 timestamp;    // Block timestamp when the record was created
    }

    struct Item {
        string itemName;      // Example: "Honda Vario 2020 - Pink"
        bool exists;          // Registration status
    }

    mapping(string => Item) public items;
    mapping(string => ServiceRecord[]) public serviceHistory;

    event ItemRegistered(
        string indexed itemIdHash,
        string itemId,
        string itemName
    );

    event ServiceAdded(
        string indexed itemIdHash,
        string itemId,
        string serviceType,
        string technician,
        string ownerName,
        uint256 mileage,
        uint256 timestamp
    );

    error ItemAlreadyExists(string itemId);
    error ItemNotFound(string itemId);
    error EmptyItemId();

    /// @notice Registers a new vehicle or physical asset.
    function registerItem(
        string memory itemId,
        string memory itemName
    ) external {
        if (bytes(itemId).length == 0) {
            revert EmptyItemId();
        }

        if (items[itemId].exists) {
            revert ItemAlreadyExists(itemId);
        }

        items[itemId] = Item({
            itemName: itemName,
            exists: true
        });

        emit ItemRegistered(
            itemId,
            itemId,
            itemName
        );
    }

    /// @notice Adds a new service record with owner and mileage information.
    function addServiceRecord(
        string memory itemId,
        string memory serviceType,
        string memory technician,
        string memory ownerName,
        string memory notes,
        uint256 mileage
    ) external {
        if (!items[itemId].exists) {
            revert ItemNotFound(itemId);
        }

        serviceHistory[itemId].push(
            ServiceRecord({
                serviceType: serviceType,
                technician: technician,
                ownerName: ownerName,
                notes: notes,
                mileage: mileage,
                timestamp: block.timestamp
            })
        );

        emit ServiceAdded(
            itemId,
            itemId,
            serviceType,
            technician,
            ownerName,
            mileage,
            block.timestamp
        );
    }

    /// @notice Returns the complete service history of an item.
    function getServiceHistory(
        string memory itemId
    ) external view returns (ServiceRecord[] memory) {
        if (!items[itemId].exists) {
            revert ItemNotFound(itemId);
        }

        return serviceHistory[itemId];
    }

    /// @notice Returns detailed information about an item.
    function getItem(
        string memory itemId
    ) external view returns (Item memory) {
        if (!items[itemId].exists) {
            revert ItemNotFound(itemId);
        }

        return items[itemId];
    }
}
