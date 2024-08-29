// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGridPower {
    function solve(uint256 n, uint256[] calldata x, uint256[] calldata y, uint256[] calldata c) external returns (uint256);
}
