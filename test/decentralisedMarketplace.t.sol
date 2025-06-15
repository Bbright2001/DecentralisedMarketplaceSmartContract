// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {decentralisedMarketplace} from "../src/decentralisedMarketplace.sol";

contract testDecentralisedMarketplace is Test {
        decentralisedMarketplace public store;
        address seller = address(0x1);
        address buyer = address(0x2);

    function setUp() public {
        store = new decentralisedMarketplace();

        // Fund accounts
        vm.deal(seller, 10 ether);
        vm.deal(buyer, 10 ether);
    }

    function testAddStocks() public {
        vm.prank(seller);
        store.addStock("AirCrafts", 3 ether, 5);

        (,,,,,,uint quantity) = store.getStock(0);
        assertEq(quantity, 5);
    }
    function testBuyStock() public {
        vm.prank(seller);
        store.addStock("Phone", 1 ether, 4);

        vm.prank(buyer);
        store.buyStock{value: 1 ether}(0);

        (, , , , address itemBuyer, bool sold,) = store.getStock(0);
        assertEq(itemBuyer, buyer);
        assertTrue(sold);
    }

}