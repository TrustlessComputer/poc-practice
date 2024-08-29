// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITeamSplitting} from "./ITeamSplitting.sol";
import {ISolution} from "../../ISolution.sol";

contract TeamSplitting is ITeamSplitting, ISolution {
    function solve(uint256 n, uint256 k) external returns (uint256, uint256) {
        return (0, 0);
    }

    function getProblemName() external view returns (string memory){
        return "TeamSplitting";
    }

    function getProblemID() external view returns (string memory){
        return "26";
    }
}
