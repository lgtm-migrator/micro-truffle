//SPDX-License-Identifier: Unlicense
// 通过合约的 owner, 去 mint 新的 NFT, 可以指定 NFT 的接收者地址, 以及设置 NFT 对应的 tokenID 和 uri.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.13;

contract MintableERC721 is ERC721URIStorage, Ownable {
  uint256 public _CUR_TOKENID_;

  constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol)
  {}

  function mint(address[] calldata receivers, string[] calldata uris)
    external
    onlyOwner
  {
    require(receivers.length == uris.length, "PARAMS NOT MATCH");
    for (uint256 i = 0; i < receivers.length; i++) {
      _safeMint(receivers[i], _CUR_TOKENID_);
      _setTokenURI(_CUR_TOKENID_, uris[i]);
      _CUR_TOKENID_++;
    }
  }
}
