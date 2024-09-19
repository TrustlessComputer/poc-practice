// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDistinctQuery {
    function solve(uint[] calldata a, uint[] calldata l, uint[] calldata r) external returns (uint[] memory);
}
