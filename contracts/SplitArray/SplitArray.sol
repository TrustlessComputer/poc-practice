// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ISplitArray } from "./ISplitArray.sol";
import { ISolution } from "../ISolution.sol";

contract Rotation is ISplitArray, ISolution {
    function solve(uint[] calldata a, uint k) external returns (uint) {
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "SplitArray";
    }
    function getProblemID() external view returns (string memory){
        return "14";
    }
}
