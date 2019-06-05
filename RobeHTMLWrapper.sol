pragma solidity ^0.4.0;

import "./Robe.sol";

/**
  * @title A simple HTML-based Robe NFT
  * 
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
contract RobeHTMLWrapper is Robe {

    function RobeHTMLWrapper(address syntaxCheckerAddress) public {
        _myAddress = address(this);
        if(syntaxCheckerAddress != _voidAddress) {
            _syntaxCheckerAddress = syntaxCheckerAddress;
            _syntaxChecker = IRobeSyntaxChecker(_syntaxCheckerAddress);
        }
    }

    function mint(string memory html) public returns(uint) {
        return super.mint(bytes(html));
    }

    function mint(uint tokenId, string memory html) public returns(uint) {
        return super.mint(tokenId, bytes(html));
    }

    function getHTML(uint tokenId) public constant returns(string memory) {
        return string(super.getContent(tokenId));
    }

    function getCompleteInfoInHTML(uint tokenId) public constant returns(uint, address, string memory) {
        var (position, owner, payload) = super.getCompleteInfo(tokenId);
        return (position, owner, string(payload));
    }
}