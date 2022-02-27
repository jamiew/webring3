// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../WebRing.sol";

contract WebRingTest is DSTest {

    WebRing webring;

    function setUp() public {
        webring = new WebRing();
    }

    function testWebRing() public {
        // assertTrue(true);
        assertEq(webring.membersCount(), 0);
        webring.join(
            address(0),
            0
        );
        assertEq(webring.membersCount(), 1);
    }
}
