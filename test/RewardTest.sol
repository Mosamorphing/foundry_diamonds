// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/facets/RewardsFacet.sol";
import "../contracts/libraries/LibAppStorage.sol";
import "../contracts/interfaces/IERC20.sol";

contract RewardsTest is Test {
    RewardsFacet rewards;
    IERC20 rewardToken;
    address user = address(1);

    function setUp() public {
        rewards = new RewardsFacet();
        rewardToken = IERC20(deployERC20());

        // Give user some staked tokens
        LibAppStorage.appStorage().stakers[user].erc20Staked = 100 ether;
        LibAppStorage.appStorage().stakers[user].lastUpdated = block.timestamp - 1 days; // Staked 1 day ago

        // Set reward rate to 1 token per second per ether
        LibAppStorage.appStorage().rewardRate = 1 ether;
    }

    function testCalculateRewards() public {
        uint256 rewardsAmount = rewards.calculateRewards(user);
        assertEq(rewardsAmount, 86400 ether); // 100 * 1 * 86400 (1 day)
    }

    function testClaimRewards() public {
        vm.startPrank(user);
        rewards.claimRewards();
        vm.stopPrank();

        assertEq(rewardToken.balanceOf(user), 86400 ether);
    }
}
