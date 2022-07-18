// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CarToken.sol";
import "../src/CarFactory.sol";
import "../src/CarMarket.sol";
import "../src/attacker/Attack.sol";

contract ContractTest is Test {
    CarToken token;
    CarFactory factory;
    CarMarket market;
    Attack attacker;

    address alice = address(0xbabe);
    address bob = address(0xb0b);
    address tester = address(this);

    function setUp() public {
        token = new CarToken();
        market = new CarMarket(address(token));
        factory = new CarFactory(address(market), address(token));

        token.priviledgedMint(address(factory), 100000 ether);
        token.priviledgedMint(address(market), 100000 ether);

        market.setCarFactory(address(factory));

        vm.prank(alice);
        attacker = new Attack(
            address(token),
            address(market),
            address(factory)
        );

        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(tester, "Tester");
        vm.label(address(token), "CarToken");
        vm.label(address(market), "CarMarket");
        vm.label(address(factory), "CarFactory");
    }

    function testCorrectSetup() public {
        assertEq(attacker.owner(), alice);
        assertEq(token.balanceOf(address(factory)), 100000 ether);
        assertEq(token.balanceOf(address(market)), 100000 ether);
    }

    function testAttack() public {
        vm.prank(alice);
        attacker.attack();

        // Assert that attacker has two cars
        assertEq(market.getCarCount(address(attacker)), 2);
    }
}
