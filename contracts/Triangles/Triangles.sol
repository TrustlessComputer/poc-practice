// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ITriangles } from "./ITriangles.sol";
import { ISolution } from "../ISolution.sol";


contract Triangles is ITriangles, ISolution {
    function solve(uint[] calldata a) external pure returns (uint) {
        return 0;
    }
    function getProblemName() external view returns (string memory){
        return "Triangles";
    }
    function getProblemID() external view returns (string memory){
        return "5";
    }
}
