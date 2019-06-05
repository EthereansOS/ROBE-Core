pragma solidity ^0.4.0;

/**
  * @title Syntax Checker for Robe-based NFT contract
  * 
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
interface IRobeSyntaxChecker {

    /**
     * @return true if the given payload respects the syntax of the Robe NFT reachable at the given robeAddress, false otherwhise
     */
    function check(uint rootTokenId, uint newTokenId, address owner, bytes payload, address robeAddress) public constant returns(bool);
}