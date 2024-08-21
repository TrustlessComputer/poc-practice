// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRotation} from "./IRotation.sol";
import { ISolution } from "../ISolution.sol";


contract Rotation is IRotation, ISolution {
    function solve(uint256[] calldata nums) external returns (uint256) {
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "Rotation";
    }
    function getProblemID() external view returns (string memory){
        return "6";
    }
}
