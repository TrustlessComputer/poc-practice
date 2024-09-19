// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IStringSimilarity} from "./IStringSimilarity.sol";
import {ISolution} from "../../ISolution.sol";

contract StringSimilarity is IStringSimilarity, ISolution {
    function solve(string calldata s) external returns (string memory) {
        return "";
    }

    function getProblemName() external view returns (string memory){
        return "StringSimilarity";
    }

    function getProblemID() external view returns (string memory){
        return "27";
    }
}
