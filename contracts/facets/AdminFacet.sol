// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/LibAppStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "../interfaces/IERC20.sol";
import "../libraries/LibDiamond.sol";

contract AdminFacet {
    event RewardParamsUpdated(uint256 apr, uint256 rewardRate, uint256 decayRate);

    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }

    function setRewardToken(address token) external onlyOwner {
        AppStorage storage s = LibAppStorage.appStorage();
        s.rewardToken = IERC20(token);
    }

    function setRewardParams(uint256 apr, uint256 rewardRate, uint256 decayRate) external onlyOwner {
        AppStorage storage s = LibAppStorage.appStorage();
        s.apr = apr;
        s.rewardRate = rewardRate;
        s.decayRate = decayRate;
        emit RewardParamsUpdated(apr, rewardRate, decayRate);
    }
}
