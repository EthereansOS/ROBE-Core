pragma solidity ^0.4.0;

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721 {

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) public constant returns (uint balance);
    function ownerOf(uint tokenId) public constant returns (address owner);

    function approve(address to, uint tokenId) public;
    function getApproved(uint tokenId) public constant returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public constant returns (bool);

    function transferFrom(address from, address to, uint tokenId) public;
    function safeTransferFrom(address from, address to, uint tokenId) public;

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) public;
}