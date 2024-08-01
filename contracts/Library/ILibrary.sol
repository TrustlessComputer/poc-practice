// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILibrary {
    function solve(uint256[] memory a, uint256[] memory u, uint256[] memory v) external pure returns (uint256);
}
