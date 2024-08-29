// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProductKInteger {
    function solve(int256[] calldata a, uint256 k) external returns (uint256);
}
