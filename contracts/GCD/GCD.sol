// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGCD} from "./IGCD.sol";
import { ISolution } from "../ISolution.sol";


contract GCD is IGCD, ISolution {
    function solve(uint256 a, uint256 b) external pure returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "GCD";
    }

    function getProblemID() external view returns (string memory){
        return "1";
    }
}
