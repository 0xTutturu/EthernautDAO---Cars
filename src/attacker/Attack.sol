pragma solidity 0.8.13;

import "../interfaces/ICarMarket.sol";
import "../interfaces/ICarToken.sol";

error NotOwner();

contract Attack {
    address public owner;
    ICarToken token;
    ICarMarket market;
    address factory;

    constructor(
        address _token,
        address _market,
        address _factory
    ) {
        owner = msg.sender;
        token = ICarToken(_token);
        market = ICarMarket(_market);
        factory = _factory;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ATTACK FUNCTIONS
}
