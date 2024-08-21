// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ILibrary } from "./ILibrary.sol";
import { ISolution } from "../ISolution.sol";


contract Library is ILibrary, ISolution {
    function solve(uint[] memory a, uint[] memory u, uint[] memory v) external pure returns (uint) {        
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "Library";
    }

    function getProblemID() external view returns (string memory){
        return "3";
    }
}
