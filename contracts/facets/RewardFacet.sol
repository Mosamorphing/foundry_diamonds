// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/LibAppStorage.sol";
// import "../interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract RewardsFacet {
    event RewardsClaimed(address indexed user, uint256 amount);

    function calculateRewards(address user) public view returns (uint256) {
        AppStorage storage s = LibAppStorage.appStorage();
        Staker storage staker = s.stakers[user];
        uint256 timeElapsed = block.timestamp - staker.lastUpdated;
        uint256 reward = (staker.erc20Staked * s.rewardRate * timeElapsed) / 1e18;
        return reward;
    }

    function claimRewards() external {
        AppStorage storage s = LibAppStorage.appStorage();
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards available");
        s.stakers[msg.sender].lastUpdated = block.timestamp;
        s.rewardToken.transfer(msg.sender, rewards);
        emit RewardsClaimed(msg.sender, rewards);
    }
}
