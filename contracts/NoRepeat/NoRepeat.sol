// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { INoRepeat } from "./INoRepeat.sol";
import { ISolution } from "../ISolution.sol";


contract NoRepeat is INoRepeat, ISolution {
    function solve(string calldata s) external pure returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "NoRepeat";
    }

    function getProblemID() external view returns (string memory){
        return "15";
    }
}
