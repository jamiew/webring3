// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

contract WebRing {

  struct Member {
    address creator;
    uint256 id;
    address contractAddr;
    uint256 tokenId; // optional
  }

  mapping (uint256 => Member) public members;
  mapping (address => uint256) public owners;
  uint256 public membersCount;

  event JoinWebRing (address who, uint256 id, address contractAddr, uint256 tokenId);
  event LeaveWebRing (address who);

  function join(address contractAddr, uint256 tokenId) public {
    uint256 nextId = membersCount + 1;

    members[nextId] = Member(
      msg.sender,
      nextId,
      contractAddr,
      tokenId
    );

    owners[msg.sender] = nextId;

    membersCount++;

    emit JoinWebRing(
      members[nextId].creator,
      members[nextId].id,
      members[nextId].contractAddr,
      members[nextId].tokenId
    );
  }

  function leave() public {
    uint256 id = owners[msg.sender];
    delete members[id];
    delete owners[msg.sender];
    emit LeaveWebRing(msg.sender);
  }

  function idFor(address who) public view returns (uint256) {
    require(who != address(0));
    return owners[who];
  }

  // function siteFor(address who) public returns (address, uint256) {
  function siteFor(address who) public view returns (address) {
    Member memory member = members[idFor(who)];
    return member.contractAddr;
  }

}