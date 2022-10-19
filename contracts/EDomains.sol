// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract EDomains is ERC721URIStorage {
      using Counters for Counters.Counter;
      Counters.Counter private _tokenIds;
      // A "mapping" data type to store their names linked to their address
      mapping(string=>address) public domains;

      mapping(string=>string) public records;
      string tld;


    constructor (string memory _tld) payable ERC721("Radicle Name Service","RAD"){
        tld = _tld;
        console.log("%s Name Service is deployed",_tld);

    }  

     // This function will give us the price of a domain based on length
     function price(string calldata name) public pure returns(uint){
        uint len = bytes(name).length;
        if (len == 3) {
            return 5 * 10**18;
        }else if (len==4) {
            return 3 * 10**18;
        }else{
            return 1 * 10**18;
        }
     }

    function register(string calldata name) public payable{ 
        //check that the domain is unregistered
        require(domains[name] == address(0));
        
        uint _price = price(name);
         // Check if enough Matic was paid in the transaction
        require(msg.value >= _price,"Not enough Matic paid");
        
         uint256 tokenId = _tokenIds.current();
         
         console.log("Registering %s.%s on the contract with tokenID %d", name, tld, tokenId);

         _safeMint(msg.sender, tokenId);

        domains[name] = msg.sender;
         _tokenIds.increment();

        console.log("%s, has registered a domain",msg.sender);
    }

    function getAddress(string calldata name) public view returns(address){
        return domains[name];

    } 

    function setRecord(string calldata name,string calldata record) public {
        // Check that the owner is the transaction sender
        require(domains[name] == msg.sender);
        records[name] = record;

    }

    function getRecord(string calldata name) public view returns(string memory){
        return records[name];

    }
}