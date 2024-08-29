// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRepeatModulo} from "./IRepeatModulo.sol";
import {ISolution} from "../../ISolution.sol";

contract RepeatModulo is IRepeatModulo, ISolution {
    function solve(uint256 x, uint256 n, uint256 m) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "RepeatModulo";
    }

    function getProblemID() external view returns (string memory){
        return "22";
    }
}
