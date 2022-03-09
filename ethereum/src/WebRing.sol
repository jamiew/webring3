// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract WebRing {

  struct Website {
    address webmaster;
    uint256 id;
    address contractAddr;
    uint256 tokenId; // optional
  }

  mapping (uint256 => Website) public websites;
  mapping (address => uint256) public owners;
  uint256 public websitesCount;

  event JoinWebRing (address indexed who, uint256 id, address contractAddr, uint256 tokenId);
  event LeaveWebRing (address indexed who);

  function join(address contractAddr, uint256 tokenId) public {
    require(indexOf(msg.sender) == 0, "you're already a member of the webring");
    require(contractAddr != address(0), "can't add null address");
    // fine if tokenId is blank

    uint256 nextId = websitesCount + 1;

    websites[nextId] = Website(
      msg.sender,
      nextId,
      contractAddr,
      tokenId
    );

    owners[msg.sender] = nextId;

    websitesCount++;

    emit JoinWebRing(
      websites[nextId].webmaster,
      websites[nextId].id,
      websites[nextId].contractAddr,
      websites[nextId].tokenId
    );
  }

  function leave() public {
    require(indexOf(msg.sender) != 0, "you are not a member of the webring");

    uint256 id = owners[msg.sender];
    delete websites[id];
    delete owners[msg.sender];
    websitesCount--;
    emit LeaveWebRing(msg.sender);
  }

  function indexOf(address who) public view returns (uint256) {
    return owners[who];
  }

  function myIndex() public view returns (uint256) {
    return owners[msg.sender];
  }

  function websiteInfo(address who) public returns (uint256, address, uint256) {
    Website memory website = websites[indexOf(who)];
    return (website.id, website.contractAddr, website.tokenId);
  }

  function myInfo() public returns (uint256, address, uint256) {
    return websiteInfo(msg.sender);
  }

  function contractAddressFor(address who) public view returns (address) {
    return websites[indexOf(who)].contractAddr;
  }

}
