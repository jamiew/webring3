// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../WebRing.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol"; // FIXME this is in forge-std too
import {Vm} from "forge-std/Vm.sol";


contract WebRingTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    // CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    WebRing webring;

    address validMemberAddress = 0x3769c5700Da07Fe5b8eee86be97e061F961Ae340; // gawds
    uint256 validMemberTokenId = 4569; // dark lord of the wood gang

    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    function setUp() public {
        webring = new WebRing();
    }

    // helpers
    function validMemberJoin() private {
        webring.join(validMemberAddress, validMemberTokenId);
    }

    // tests
    function testConsoleLog() public {
      console.log("console.log() works in tests");
    }

    function testJoinAndLeave() public {
        assertEq(webring.membersCount(), 0);

        validMemberJoin();
        assertEq(webring.membersCount(), 1);

        webring.leave();
        assertEq(webring.membersCount(), 0);
    }

    function testJoinEmitsEvent() public {
      // FIXME not quite working
      // vm.expectEmit(true, false, false, true);
      // emit WebRing.JoinWebRing(validMemberAddress);
      // validMemberJoin();
    }

    function testLeaveEmitsEvent() public {
      // TODO
    }

    function testFailNullCannotJoin() public {
      webring.join(address(0), 0);
    }

    function testNullTokenIdIsOK() public {
      webring.join(validMemberAddress, 0);
      assertEq(webring.membersCount(), 1);
    }

    function testIndexOf() public {
      validMemberJoin();
      assertEq(
        webring.indexOf(forgeDeployer),
        1 
      );

      assertEq(
        webring.myIndex(),
        1
      );
    }

    function testMemberInfo() public {
      validMemberJoin();
      (uint256 id, address addr, uint256 tokenId) = webring.memberInfo(forgeDeployer);
      assertEq(id, 1);
      assertEq(addr, validMemberAddress);
      assertEq(tokenId, validMemberTokenId);
    }

    function contractAddressFor() public {
      validMemberJoin();
      assertEq(
        webring.contractAddressFor(forgeDeployer),
        validMemberAddress
      );
    }

}
