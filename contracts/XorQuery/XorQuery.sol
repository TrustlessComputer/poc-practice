// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IXorQuery} from "./IXorQuery.sol";

contract XorQuery is IXorQuery {
    function solve(uint[] calldata a, uint[] calldata l, uint[] calldata r) external returns (uint[] memory) {
        uint[] memory res = new uint[](l.length);
        return res;
    }
}
