// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./verifier.sol";
import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "@openzeppelin/contracts/access/Ownable.sol";

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[8] memory input
    ) external view returns (bool);
}

contract Hangman is Ownable {

    uint8 public constant MAX_ROUND = 50;
    uint8 public currentRound = 1;
    address[2] public players;
    address public winner;
}