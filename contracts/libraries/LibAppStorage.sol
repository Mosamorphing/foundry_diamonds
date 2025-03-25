// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";

struct Staker {
    uint256 erc20Staked;
    uint256 erc721Staked;
    uint256 erc1155Staked;
    uint256 lastUpdated;
}

struct AppStorage {
    mapping(address => Staker) stakers;
    IERC20 rewardToken;
    uint256 apr; // Annual Percentage Rate (e.g., 1000 = 10%)
    uint256 rewardRate; // Base reward rate per second
    uint256 decayRate; // Reward decay factor
}

library LibAppStorage {
    bytes32 constant STORAGE_POSITION = keccak256("diamond.staking.appstorage");

    function appStorage() internal pure returns (AppStorage storage s) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
