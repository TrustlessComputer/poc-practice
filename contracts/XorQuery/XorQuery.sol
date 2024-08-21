// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IXorQuery } from "./IXorQuery.sol";
import { ISolution } from "../ISolution.sol";


contract XorQuery is IXorQuery, ISolution {
    function solve(uint[] calldata a, uint[] calldata l, uint[] calldata r) external returns (uint[] memory) {
        uint[] memory res = new uint[](l.length);
        return res;
    }
    function getProblemName() external view returns (string memory){
        return "XorQuery";
    }
    function getProblemID() external view returns (string memory){
        return "10";
    }
}
