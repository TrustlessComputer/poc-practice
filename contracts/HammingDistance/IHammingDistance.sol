// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHammingDistance {
    function solve(uint[] calldata a) external returns (uint);
}
