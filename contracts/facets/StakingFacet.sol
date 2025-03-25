// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/LibAppStorage.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IERC721.sol";
import "../interfaces/IERC1155.sol";

contract StakingFacet {
    event Staked(address indexed user, uint256 amount, uint256 tokenType);
    event Unstaked(address indexed user, uint256 amount, uint256 tokenType);

    function stakeERC20(address token, uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        AppStorage storage s = LibAppStorage.appStorage();
        s.stakers[msg.sender].erc20Staked += amount;
        s.stakers[msg.sender].lastUpdated = block.timestamp;
        
        emit Staked(msg.sender, amount, 20);
    }

    function stakeERC721(address token, uint256 tokenId) external {
        IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);
        
        AppStorage storage s = LibAppStorage.appStorage();
        s.stakers[msg.sender].erc721Staked += 1;
        s.stakers[msg.sender].lastUpdated = block.timestamp;
        
        emit Staked(msg.sender, tokenId, 721);
    }

    function stakeERC1155(address token, uint256 tokenId, uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        IERC1155(token).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");
        
        AppStorage storage s = LibAppStorage.appStorage();
        s.stakers[msg.sender].erc1155Staked += amount;
        s.stakers[msg.sender].lastUpdated = block.timestamp;
        
        emit Staked(msg.sender, amount, 1155);
    }

    function unstakeERC20(address token, uint256 amount) external {
        AppStorage storage s = LibAppStorage.appStorage();
        require(s.stakers[msg.sender].erc20Staked >= amount, "Not enough balance");
        
        s.stakers[msg.sender].erc20Staked -= amount;
        IERC20(token).transfer(msg.sender, amount);
        
        emit Unstaked(msg.sender, amount, 20);
    }

    function unstakeERC721(address token, uint256 tokenId) external {
        AppStorage storage s = LibAppStorage.appStorage();
        require(s.stakers[msg.sender].erc721Staked > 0, "No ERC721 staked");
        
        s.stakers[msg.sender].erc721Staked -= 1;
        IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);
        
        emit Unstaked(msg.sender, tokenId, 721);
    }

    function unstakeERC1155(address token, uint256 tokenId, uint256 amount) external {
        AppStorage storage s = LibAppStorage.appStorage();
        require(s.stakers[msg.sender].erc1155Staked >= amount, "Not enough balance");
        
        s.stakers[msg.sender].erc1155Staked -= amount;
        IERC1155(token).safeTransferFrom(address(this), msg.sender, tokenId, amount, "");
        
        emit Unstaked(msg.sender, amount, 1155);
    }
}
