// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IFavoriteNumbers} from "./IFavoriteNumbers.sol";
import {ISolution} from "../../ISolution.sol";

contract FavoriteNumbers is IFavoriteNumbers, ISolution {
    function solve(uint256[] calldata a) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "FavoriteNumbers";
    }

    function getProblemID() external view returns (string memory){
        return "28";
    }
}
