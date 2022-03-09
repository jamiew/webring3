// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../WebRing.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol"; // FIXME i think this is in forge-std too
import {Vm} from "forge-std/Vm.sol";


contract WebRingTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    // CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    WebRing webring;

    address validWebsiteAddress = 0x3769c5700Da07Fe5b8eee86be97e061F961Ae340; // gawds
    uint256 validWebsiteTokenId = 4569; // dark lord of the wood gang

    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    function setUp() public {
        webring = new WebRing();
    }

    // helpers
    function joinWebring() private {
        webring.join(validWebsiteAddress, validWebsiteTokenId);
    }

    // tests
    function testConsoleLog() public {
      console.log("console.log() works in tests");
    }

    function testJoinAndLeave() public {
        assertEq(webring.websitesCount(), 0);

        joinWebring();
        assertEq(webring.websitesCount(), 1);

        webring.leave();
        assertEq(webring.websitesCount(), 0);
    }

    function testJoinEmitsEvent() public {
      // FIXME not quite working
      // vm.expectEmit(true, false, false, true);
      // emit WebRing.JoinWebRing(validWebsiteAddress);
      // joinWebring();
    }

    function testLeaveEmitsEvent() public {
      // TODO
    }

    function testFailNullCannotJoin() public {
      webring.join(address(0), 0);
    }

    function testFailCannotJoinTwice() public {
      joinWebring();
      joinWebring();
    }

    function testNullTokenIdIsOK() public {
      webring.join(validWebsiteAddress, 0);
      assertEq(webring.websitesCount(), 1);
    }

    function testIndexOf() public {
      joinWebring();
      assertEq(
        webring.indexOf(forgeDeployer),
        1
      );

      assertEq(
        webring.myIndex(),
        1
      );
    }

    function testWebsiteInfo() public {
      joinWebring();
      (uint256 id, address addr, uint256 tokenId) = webring.websiteInfo(forgeDeployer);
      assertEq(id, 1);
      assertEq(addr, validWebsiteAddress);
      assertEq(tokenId, validWebsiteTokenId);
    }

    function contractAddressFor() public {
      joinWebring();
      assertEq(
        webring.contractAddressFor(forgeDeployer),
        validWebsiteAddress
      );
    }

}
