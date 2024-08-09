// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRotation {
    function solve(uint256[] calldata nums) external returns (uint256);
}
