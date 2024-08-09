// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IJosephus {
    function solve(uint n, uint m, uint p, uint y) external returns (uint[2] memory);
}
