// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IHouseRobber } from "./IHouseRobber.sol";
import { ISolution } from "../ISolution.sol";


contract HouseRobber is IHouseRobber, ISolution {
    function solve(uint256[] calldata a) external returns (uint256) {
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "HouseRobber";
    }

    function getProblemID() external view returns (string memory){
        return "11";
    }
}
