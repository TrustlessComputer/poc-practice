// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRangeAddition {
    function solve(uint256 m, uint256 n, uint256[][] calldata ops) external returns (uint256);
}
