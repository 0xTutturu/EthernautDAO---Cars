// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/attacker/Attack.sol";

contract Deploy is Script {
    address factory = 0x012f0c715725683A5405B596f4F55D4AD3046854;
    address market = 0x07AbFccEd19Aeb5148C284Cd39a9ff2Ac835960A;
    address token = 0x66408824A99FF61ae2e032E3c7a461DED1a6718E;

    function run() external {
        vm.startBroadcast();

        Attack attacker = new Attack(token, market, factory);

        attacker.attack();

        vm.stopBroadcast();
    }
}
