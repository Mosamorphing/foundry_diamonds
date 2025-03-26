// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/facets/RewardFacet.sol";
import "../contracts/libraries/LibAppStorage.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardsTest is Test {
    RewardsFacet rewards;
    IERC20 rewardToken;
    address user = address(1);

    function setUp() public {
        rewards = new RewardsFacet();
        rewardToken = IERC20(deployERC20());

        // Modify storage via a helper function
        _setStakerData(user, 100 ether, block.timestamp - 1 days);

        // Set reward rate in storage
        _setRewardRate(1 ether);
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

    /// @dev Deploys a simple ERC20 token for testing
    function deployERC20() internal returns (address) {
        ERC20 token = new ERC20("Test Token", "TTK");
        return address(token);
    }

    /// @dev Helper function to modify staker data in storage
    function _setStakerData(address _user, uint256 _staked, uint256 _lastUpdated) internal {
        LibAppStorage.AppStorage storage s = LibAppStorage.appStorage();
        s.stakers[_user].erc20Staked = _staked;
        s.stakers[_user].lastUpdated = _lastUpdated;
    }

    /// @dev Helper function to modify reward rate in storage
    function _setRewardRate(uint256 _rate) internal {
        LibAppStorage.AppStorage storage s = LibAppStorage.appStorage();
        s.rewardRate = _rate;
    }
}
