pragma solidity ^0.5.0;

import "./IRobe.sol";
import "./IRobeSyntaxChecker.sol";

/**
  * @title General Purpose implementation of the Robe Interface
  * 
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
contract Robe is IRobe {

    address private _voidAddress = address(0);

    address private _myAddress;

    address private _syntaxCheckerAddress;
    IRobeSyntaxChecker private _syntaxChecker;

    //Registers the owner of each NFT
    mapping(uint256 => address) private _owner;

    //True if the given NFT id is owned by this address
    mapping(address => mapping(uint256 => bool)) private _index;

    //Registers the chain of composed NFT
    mapping(uint256 => uint256[]) private _chain;

    //Register the position of the NFT in its chain
    mapping(uint256 => uint256) private _positionInChain;

    //Registers the root NFT of each NFT
    mapping(uint256 => uint256) private _parent;

    //The content of each NFT
    bytes[] private _data;

    constructor(address syntaxCheckerAddress) public {
        _myAddress = address(this);
        if(syntaxCheckerAddress != _voidAddress) {
            _syntaxCheckerAddress = syntaxCheckerAddress;
            _syntaxChecker = IRobeSyntaxChecker(_syntaxCheckerAddress);
        }
    }

    /**
      * Creates a new ERC 721 NFT
      * @return a unique tokenId
      */
    function create(bytes memory payload) public returns(uint256) {
        return createAndOrAttach(_data.length, payload, msg.sender);
    }

    /**
      * Attaches a new ERC 721 NFT to an already-existing Token
      * to create a composed NFT
      * @return a unique tokenId
      */
    function attach(uint256 tokenId, bytes memory payload) public returns(uint256) {
        return createAndOrAttach(tokenId, payload, msg.sender);
    }

    function createAndOrAttach(uint256 tokenId, bytes memory payload, address owner) private returns(uint256) {
        uint256 newTokenId = _data.length;
        if(_syntaxCheckerAddress != _voidAddress) {
            require(_syntaxChecker.check(tokenId, newTokenId, owner, payload, _myAddress), "Invalid payload Syntax");
        }
        _data.push(payload);
        _owner[newTokenId] = owner;
        _index[owner][newTokenId] = true;
        _positionInChain[newTokenId] = _chain[tokenId].length;
        _chain[tokenId].push(newTokenId);
        _parent[newTokenId] = tokenId;
        return newTokenId;
    }

    /**
      * @return all the tokenIds that composes the givend NFT
      */
    function getChain(uint256 tokenId) public view returns(uint256[] memory) {
        return _chain[_parent[tokenId]];
    }

    /**
     * @return the owner's address of the given NFT
     */
    function getOwner(uint256 tokenId) public view returns(address) {
        return _owner[tokenId];
    }

    /**
     * @return the content of a NFT
     */
    function getContent(uint256 tokenId) public view returns(bytes memory) {
        return _data[tokenId];
    }

    /**
     * @return the position in the chain of this NFT
     */
    function getPositionOf(uint256 tokenId) public view returns(uint256) {
        return _positionInChain[tokenId];
    }

    /**
     * @return the tokenId of the passed NFT at the given position
     */
    function getTokenIdAt(uint256 tokenId, uint256 position) public view returns(uint256) {
        return _chain[tokenId][position];
    }

    /**
     * Syntactic sugar
     * @return the position in the chain, the owner's address and content of the given NFT
     */
    function getCompleteInfo(uint256 tokenId) public view returns(uint256, address, bytes memory) {
        return (_positionInChain[tokenId], _owner[tokenId], _data[tokenId]);
    }

    /**
     * @return all the owners' addresses of the given NFT
     */
    function getOwners(uint256 tokenId) public view returns(address[] memory) {
        address[] memory owners = new address[](_chain[tokenId].length);
        for(uint256 i = 0; i < _chain[tokenId].length; i++) {
            owners[i] = _owner[_chain[tokenId][i]];
        }
        return owners;
    }

    /**
     * @return true if the given NFT is owned by the given address. False otherwise
     */
    function isOwnedBy(uint256 tokenId, address owner) public view returns(bool) {
        return _index[owner][tokenId];
    }
}