pragma solidity ^0.4.0;

import "./IRobe.sol";
import "./IERC721.sol";
import "./IRobeSyntaxChecker.sol";
import "./IERC721Receiver.sol";

/**
  * @title General Purpose implementation of the Robe Interface
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
  * @author The OpenZeppelin ERC721 Implementation for the safeTransferFrom method. Thank you guys!
*/
contract Robe is IRobe, IERC721 {

    address internal _voidAddress = address(0);

    address internal _myAddress;

    address internal _syntaxCheckerAddress;
    IRobeSyntaxChecker internal _syntaxChecker;

    //Registers the owner of each NFT
    mapping(uint => address) private _owner;

    //Registers the balance for each owner
    mapping(address => uint) private _balance;

    //Registers the approved operators that can transfer the ownership of a specific NFT
    mapping(uint => address) private _tokenOperator;

    //Registers the approved operators that can transfer the ownership of all the NFTs of a specific owner
    mapping(address => address) private _ownerOperator;

    //Registers the chain of composed NFT
    mapping(uint => uint[]) private _chain;

    //Registers the position of the NFT in its chain
    mapping(uint => uint) private _positionInChain;

    //Registers the root NFT of each NFT
    mapping(uint => uint) private _root;

    //The content of each NFT
    bytes[] private _data;

    function Robe(address syntaxCheckerAddress) public {
        _myAddress = address(this);
        if(syntaxCheckerAddress != _voidAddress) {
            _syntaxCheckerAddress = syntaxCheckerAddress;
            _syntaxChecker = IRobeSyntaxChecker(_syntaxCheckerAddress);
        }
    }

    function() public payable {
        revert();
    }

    /**
      * Creates a new ERC 721 NFT
      * @return a unique tokenId
      */
    function mint(bytes memory payload) public returns(uint) {
        return _mintAndOrAttach(_data.length, payload, msg.sender);
    }

    /**
      * Attaches a new ERC 721 NFT to an already-existing Token
      * to create a composed NFT
      * @return a unique tokenId
      */
    function mint(uint rootTokenId, bytes memory payload) public returns(uint) {
        return _mintAndOrAttach(rootTokenId, payload, msg.sender);
    }

    function _mintAndOrAttach(uint rootTokenId, bytes memory payload, address owner) private returns(uint) {
        uint newTokenId = _data.length;
        if(rootTokenId != newTokenId) {
            require(_owner[rootTokenId] == owner);
        }
        if(_syntaxCheckerAddress != _voidAddress) {
            require(_syntaxChecker.check(rootTokenId, newTokenId, owner, payload, _myAddress));
        }
        _data.push(payload);
        if(rootTokenId == newTokenId) {
            _owner[rootTokenId] = owner;
        }
        _balance[owner] = _balance[owner] + 1;
        _root[newTokenId] = rootTokenId;
        _positionInChain[newTokenId] = _chain[rootTokenId].length;
        _chain[rootTokenId].push(newTokenId);
        return newTokenId;
    }

    /**
      * @return all the tokenIds that composes the givend NFT
      */
    function getChain(uint tokenId) public constant returns(uint[] memory) {
        return _chain[_root[tokenId]];
    }

    /**
      * @return the root NFT of this tokenId
      */
    function getRoot(uint tokenId) public constant returns(uint) {
        return _root[tokenId];
    }

    /**
     * @return the content of a NFT
     */
    function getContent(uint tokenId) public constant returns(bytes memory) {
        return _data[tokenId];
    }

    /**
     * @return the position in the chain of this NFT
     */
    function getPositionOf(uint tokenId) public constant returns(uint) {
        return _positionInChain[tokenId];
    }

    /**
     * @return the tokenId of the passed NFT at the given position
     */
    function getTokenIdAt(uint tokenId, uint position) public constant returns(uint) {
        return _chain[tokenId][position];
    }

    /**
     * Syntactic sugar
     * @return the position in the chain, the owner's address and content of the given NFT
     */
    function getCompleteInfo(uint tokenId) public constant returns(uint, address, bytes memory) {
        return (_positionInChain[tokenId], _owner[_root[tokenId]], _data[tokenId]);
    }

    function balanceOf(address owner) public constant returns (uint balance) {
        return _balance[owner];
    }

    function ownerOf(uint tokenId) public constant returns (address owner) {
        return _owner[_root[tokenId]];
    }

    function approve(address to, uint tokenId) public {
        require(_root[tokenId] == tokenId);
        require(msg.sender == _owner[tokenId]);
        _tokenOperator[tokenId] = to;
        Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint tokenId) public constant returns (address operator) {
        require(_root[tokenId] == tokenId);
        operator = _tokenOperator[tokenId];
        if(operator == _voidAddress) {
            operator = _ownerOperator[_owner[tokenId]];
        }
    }

    function setApprovalForAll(address operator, bool _approved) public {
        if(!_approved && operator == _ownerOperator[msg.sender]) {
            _ownerOperator[msg.sender] = _voidAddress;
        }
        if(_approved) {
            _ownerOperator[msg.sender] = operator;
        }
        ApprovalForAll(msg.sender, operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) public constant returns (bool) {
        return _ownerOperator[owner] == operator;
    }

    function transferFrom(address from, address to, uint tokenId) public {
        _transferFrom(msg.sender, from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint tokenId) public {
        _safeTransferFrom(msg.sender, from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) public {
        _safeTransferFrom(msg.sender, from, to, tokenId, data);
    }

    function _transferFrom(address sender, address from, address to, uint tokenId) private {
        require(_root[tokenId] == tokenId);
        require(_owner[tokenId] == from);
        require(from == sender || getApproved(tokenId) == sender);
        _owner[tokenId] = to;
        _balance[from] = _balance[from] - 1;
        _balance[to] = _balance[to] + 1;
        _tokenOperator[tokenId] = _voidAddress;
        Transfer(from, to, tokenId);
    }

    function _safeTransferFrom(address sender, address from, address to, uint tokenId, bytes memory data) public {
        _transferFrom(sender, from, to, tokenId);
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data);
        require(retval == 0x150b7a02);
    }
}

/**
  * @title A simple HTML syntax checker
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
contract RobeHTMLSyntaxChecker is IRobeSyntaxChecker {

    function check(uint rootTokenId, uint newTokenId, address owner, bytes memory payload, address robeAddress) public constant returns(bool) {
       //Extremely trivial and simplistic control coded in less than 30 seconds. We will make a more accurate one later
        require(payload[0] == "<");
        require(payload[1] == "h");
        require(payload[2] == "t");
        require(payload[3] == "m");
        require(payload[4] == "l");
        require(payload[5] == ">");
        return true;
    }
}