// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IATimesBPlusC} from "./IATimesBPlusC.sol";
import {ISolution} from "../../ISolution.sol";

contract ATimesBPlusC is IATimesBPlusC, ISolution {
    function solve(uint256 n) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "ATimesBPlusC";
    }

    function getProblemID() external view returns (string memory){
        return "21";
    }
}
