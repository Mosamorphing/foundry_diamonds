// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/facets/StakingFacet.sol";
import "../contracts/libraries/LibAppStorage.sol";
// import "../contracts/interfaces/IERC20.sol";
// import "../contracts/interfaces/IERC721.sol";
// import "../contracts/interfaces/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingTest is Test {
    StakingFacet staking;
    IERC20 erc20;
    IERC721 erc721;
    IERC1155 erc1155;
    address user = address(1);

    function setUp() public {
        staking = new StakingFacet();
        erc20 = IERC20(deployERC20());
        erc721 = IERC721(deployERC721());
        erc1155 = IERC1155(deployERC1155());

        deal(address(erc20), user, 1000 ether);  // Give user 1000 ERC20 tokens
        dealERC721(erc721, user, 1);  // Give user an ERC721 token (ID 1)
        dealERC1155(erc1155, user, 1, 10);  // Give user 10 ERC1155 tokens (ID 1)
    }

    function testStakeERC20() public {
        vm.startPrank(user);
        erc20.approve(address(staking), 100 ether);
        staking.stakeERC20(address(erc20), 100 ether);
        vm.stopPrank();

        assertEq(LibAppStorage.appStorage().stakers[user].erc20Staked, 100 ether);
    }

    function testStakeERC721() public {
        vm.startPrank(user);
        erc721.approve(address(staking), 1);
        staking.stakeERC721(address(erc721), 1);
        vm.stopPrank();

        assertEq(LibAppStorage.appStorage().stakers[user].erc721Staked, 1);
    }

    function testStakeERC1155() public {
        vm.startPrank(user);
        erc1155.setApprovalForAll(address(staking), true);
        staking.stakeERC1155(address(erc1155), 1, 5);
        vm.stopPrank();

        assertEq(LibAppStorage.appStorage().stakers[user].erc1155Staked, 5);
    }
}
