pragma solidity ^0.5.0;

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
    function create(bytes calldata payload) external returns(uint256);

    /**
      * Attaches a new ERC 721 NFT to an already-existing Token
      * to create a composed NFT
      * @return a unique tokenId
      */
    function attach(uint256 tokenId, bytes calldata payload) external returns(uint256);

    /**
      * @return all the tokenIds that composes the givend NFT
      */
    function getChain(uint256 tokenId) external view returns(uint256[] memory);

    /**
     * @return the owner's address of the given NFT
     */
    function getOwner(uint256 tokenId) external view returns(address);

    /**
     * @return the content of a NFT
     */
    function getContent(uint256 tokenId) external view returns(bytes memory);

    /**
     * @return the position in the chain of this NFT
     */
    function getPositionOf(uint256 tokenId) external view returns(uint256);

    /**
     * @return the tokenId of the passed NFT at the given position
     */
    function getTokenIdAt(uint256 tokenId, uint256 position) external view returns(uint256);

    /**
     * Syntactic sugar
     * @return the position in the chain, the owner's address and content of the given NFT
     */
    function getCompleteInfo(uint256 tokenId) external view returns(uint256, address, bytes memory);

    /**
     * @return all the owners' addresses of the given NFT
     */
    function getOwners(uint256 tokenId) external view returns(address[] memory);

    /**
     * @return true if the given NFT is owned by the given address. False otherwise
     */
    function isOwnedBy(uint256 tokenId, address owner) external view returns(bool);
}