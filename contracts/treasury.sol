// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";

contract Treasury is Ownable {
    // public
    uint256 public totalAmount;
    uint256 public depositedAmount;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    IERC20 public aaveAToken;
    IERC20 public token;

    mapping(uint256 => uint256) public initiatives;

    constructor(
        address _aaveLendingPoolAddressesProvider,
        address _aTokenAddress,
        address _tokenAddress
    ) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(
            _aaveLendingPoolAddressesProvider
        );
        POOL = IPool(ADDRESSES_PROVIDER.getPool());

        aaveAToken = IERC20(_aTokenAddress);
        token = IERC20(_tokenAddress);
    }

    function addFund(uint256 tokenId, uint256 amount) public onlyOwner {
        initiatives[tokenId] += amount; //* 10**6
        totalAmount += amount;
    }

    function withdrawInitiative(uint256 tokenId, address recipient)
        public
        onlyOwner
    {
        uint256 withdrawable = initiatives[tokenId];
        require(withdrawable != 0, "Nothing to withdraw");
        require(withdrawable <= totalAmount, "Not enough fund to withdraw");

        totalAmount -= withdrawable;
        initiatives[tokenId] = 0;

        token.transfer(recipient, withdrawable);
    }

    function withdrawInitiativeFromAave(uint256 tokenId, address recipient)
        public
        onlyOwner
    {
        uint256 withdrawable = initiatives[tokenId];
        require(withdrawable != 0, "Nothing to withdraw");
        require(withdrawable <= depositedAmount, "Not enough fund to withdraw");

        depositedAmount -= withdrawable;
        initiatives[tokenId] = 0;

        POOL.withdraw(address(token), withdrawable, recipient);
    }

    function supply() public onlyOwner {
        token.approve(address(POOL), type(uint256).max);

        POOL.supply(address(token), totalAmount, address(this), 0);

        depositedAmount += totalAmount;
        totalAmount = 0;
    }

    function withdraw() public onlyOwner {
        POOL.withdraw(address(token), depositedAmount, address(this));

        totalAmount += depositedAmount;
        depositedAmount = 0;
    }
}
