// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAPlusB} from "./IAPlusB.sol";
import {ISolution} from "../ISolution.sol";

contract APlusB is IAPlusB, ISolution {
    function solve(uint a, uint b) external pure returns (uint) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "APlusB";
    }

    function getProblemID() external view returns (string memory){
        return "4";
    }
}
