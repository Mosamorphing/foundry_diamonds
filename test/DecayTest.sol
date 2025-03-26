// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/facets/RewardFacet.sol";
import "../contracts/libraries/LibAppStorage.sol";

contract DecayTest is Test {
    RewardsFacet rewards;
    address user = address(1);

    function setUp() public {
        rewards = new RewardsFacet();

        // Set initial staking data
        AppStorage storage s = LibAppStorage.appStorage();
        s.stakers[user].erc20Staked = 100 ether;
        s.stakers[user].lastUpdated = block.timestamp - 30 days; // Staked 30 days ago
        s.rewardRate = 1 ether;
        s.decayRate = 2; // Rewards decrease by half every 30 days
    }

    function testDecay() public {
        uint256 initialRewards = rewards.calculateRewards(user);

        // Simulate another 30 days passing
        vm.warp(block.timestamp + 30 days);

        uint256 newRewards = rewards.calculateRewards(user);

        assertApproxEqAbs(newRewards, initialRewards / 2, 1e18);
    }
}
