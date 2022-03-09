// SPDX-License-Identifier: MIT
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

  event JoinWebRing (address indexed who, uint256 id, address contractAddr, uint256 tokenId);
  event LeaveWebRing (address indexed who);

  function join(address contractAddr, uint256 tokenId) public {
    require(contractAddr != address(0), "can't add null address");
    // tokenId sometimes 0 because blank, sometimes because programmers
    require(indexOf(msg.sender) == 0, "you're already a member of the webring");

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
    require(indexOf(msg.sender) != 0, "you are not a member of the webring");

    uint256 id = owners[msg.sender];
    delete members[id];
    delete owners[msg.sender];
    membersCount--;
    emit LeaveWebRing(msg.sender);
  }

  function indexOf(address who) public view returns (uint256) {
    return owners[who];
  }

  function myIndex() public view returns (uint256) {
    return owners[msg.sender];
  }

  function memberInfo(address who) public returns (uint256, address, uint256) {
    Member memory member = members[indexOf(who)];
    return (member.id, member.contractAddr, member.tokenId);
  }

  function myInfo() public returns (uint256, address, uint256) {
    return memberInfo(msg.sender);
  }

  function contractAddressFor(address who) public view returns (address) {
    return members[indexOf(who)].contractAddr;
  }

}
