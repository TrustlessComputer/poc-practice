// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICourses {
    function solve(uint n, uint[] calldata a, uint[] calldata b) external returns (bool);
}
