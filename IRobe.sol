pragma solidity ^0.4.0;

/**
  * @title Robe
  * @dev An open standard based on Ethereum ERC 721 to build unique NFT with XML information
  * 
  * @dev This is the main Inteface that identifies a Robe NFT
  * 
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
interface IRobe {

    /**
      * Creates a new ERC 721 NFT
      * @return a unique tokenId
      */
    function mint(bytes payload) public returns(uint);

    /**
      * Attaches a new ERC 721 NFT to an already-existing Token
      * to create a composed NFT
      * @return a unique tokenId
      */
    function mint(uint previousTokenId, bytes payload) public returns(uint);

    /**
      * @return all the tokenIds that composes the givend NFT
      */
    function getChain(uint tokenId) public constant returns(uint[] memory);

    /**
      * @return the root NFT of this tokenId
      */
    function getRoot(uint tokenId) public constant returns(uint);

    /**
     * @return the content of a NFT
     */
    function getContent(uint tokenId) public constant returns(bytes memory);

    /**
     * @return the position in the chain of this NFT
     */
    function getPositionOf(uint tokenId) public constant returns(uint);

    /**
     * @return the tokenId of the passed NFT at the given position
     */
    function getTokenIdAt(uint tokenId, uint position) public constant returns(uint);

    /**
     * Syntactic sugar
     * @return the position in the chain, the owner's address and content of the given NFT
     */
    function getCompleteInfo(uint tokenId) public constant returns(uint, address, bytes memory);
}