pragma solidity ^0.5.0;

/**
  * An open standard based on Ethereum ERC 721 to build unique NFT with XML informations
  * @author Marco Vasapollo <ceo@metaring.com>
  * @author Alessandro Mario Lagana Toschi <alet@risepic.com>
*/
interface IRobeToken {
    
    /**
      * Creates a new ERC 721 NFT
      * @returns a unique tokenId
      */
    function create(string calldata xml) external returns(uint256);
    
    /**
      * Attaches a new ERC 721 NFT to an already-existing Token
      * to create a composed NFT
      * @returns a unique tokenId
      */
    function attach(uint256 tokenId, string calldata xml) external returns(uint256);
    
    /**
      * @returns all the tokenIds that composes the givend NFT
      */
    function getChain(uint256 tokenId) external view returns(uint256[] memory);
    
    /**
     * @returns the owner's address of the given NFT
     */
    function getOwner(uint256 tokenId) external view returns(address);
    
    /**
     * @returns the XML content of a NFT
     */
    function getContent(uint256 tokenId) external view returns(string memory);
    
    /**
     * @returns the position in the chain of this NFT
     */
    function getPositionOf(uint256 tokenId) external view returns(uint256);
    
    /**
     * @returns the tokenId of the passed NFT at the given position
     */
    function getTokenIdAt(uint256 tokenId, uint256 position) external view returns(uint256);
    
    /**
     * Syntactic sugar
     * @returns the position in the chain, the owner's address and content of the given NFT
     */
    function getCompleteInfo(uint256 tokenId) external view returns(uint256, address, string memory);
    
    /**
     * @returns all the owners' addresses of the given NFT
     */
    function getOwners(uint256 tokenId) external view returns(address[] memory);
}
