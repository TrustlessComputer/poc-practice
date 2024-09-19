// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistinctQuery} from "./IDistinctQuery.sol";
import {ISolution} from "../../ISolution.sol";

contract DistinctQuery is IDistinctQuery, ISolution {
    function solve(uint[] calldata a, uint[] calldata l, uint[] calldata r) external returns (uint[] memory) {
        uint[] memory res = new uint[](l.length);
        return res;
    }

    function getProblemName() external view returns (string memory){
        return "DistinctQuery";
    }

    function getProblemID() external view returns (string memory){
        return "25";
    }
}
