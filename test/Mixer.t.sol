//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import {Mixer} from "../src/Mixer.sol";
import {HonkVerifier} from "../src/verifier.sol";
import {IncrementalMerkleTree,Poseidon2_BN254} from "../src/IncrementalMerkleTree.sol";


contract MixerTest {

    Mixer public mixer;
    HonkVerifier public verifier;
    Poseidon2_BN254 public hasher;


    address public receipient = makeAddr("receipient");

    function setup() public {

        // deploy the verifier
        verifier  = new HonkVerifier();
        // deploy the hasher
        hasher = new Poseidon2_BN254();
        // deploy the mixer

        mixer = new Mixer(verifier,hasher,20);

    }


    function  _getCommitment() public {

        // use ffi  to run scripts  in the CLI to create the comitment
    }


    function testMakeDeposit()  public {
        // create a commitment 
        // make a deposit
        mixer.deposit(_commitment);

        
    }






}