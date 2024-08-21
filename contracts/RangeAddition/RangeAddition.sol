// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRangeAddition} from "./IRangeAddition.sol";
import { ISolution } from "../ISolution.sol";


contract RangeAddition is IRangeAddition, ISolution {
    function solve(uint256 m, uint256 n, uint256[][] calldata ops) external pure returns (uint256) {
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "RangeAddition";
    }

    function getProblemID() external view returns (string memory){
        return "7";
    }
}
