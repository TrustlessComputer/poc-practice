// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IClosestSum {
    function solve(int256[] calldata input, int256 target) external returns (uint256);
}
