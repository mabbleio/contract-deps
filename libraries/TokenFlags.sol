// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./interfaces/IMintableERC20.sol";

library TokenFlags {
    // Bitmask flags for token properties (1 byte = 8 bits)
    // Bit 0: isPaused
    // Bit 1: isMintable
    // Bits 2-7: Reserved for future use
    uint8 private constant FLAG_PAUSED   = 0x01;  // Binary: 00000001
    uint8 private constant FLAG_MINTABLE = 0x02;  // Binary: 00000010

    // --- Getters ---
    function isPaused(mapping(address => uint8) storage flags, address token)
        internal
        view
        returns (bool)
    {
        return (flags[token] & FLAG_PAUSED) != 0;
    }

    function isMintable(mapping(address => uint8) storage flags, address token)
        internal
        view
        returns (bool)
    {
        return (flags[token] & FLAG_MINTABLE) != 0;
    }

    // --- Setters ---
    function setPaused(mapping(address => uint8) storage flags, address token, bool paused)
        internal
    {
        if (paused) {
            flags[token] |= FLAG_PAUSED;
        } else {
            flags[token] &= ~FLAG_PAUSED;
        }
    }

    function setMintable(
        mapping(address => uint8) storage flags,
        address token,
        bool mintable
    ) internal {
        if (mintable) {
            require(
                IMintableERC20(token).supportsInterface(type(IMintableERC20).interfaceId),
                "Token does not support IMintableERC20"
            );
            flags[token] |= FLAG_MINTABLE;
        } else {
            flags[token] &= ~FLAG_MINTABLE;
        }
    }
}