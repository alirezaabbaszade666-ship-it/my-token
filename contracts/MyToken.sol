// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/**
 * @title USDToken
 * @dev Production-ready ERC20 USDT token contract
 * Features:
 * - Burnable: Allows token holders to burn their tokens
 * - Pausable: Allows owner to pause all transfers in case of emergency
 * - Capped: Maximum supply is limited to prevent inflation
 * - Permit: ERC2612 permit functionality for gasless approvals
 * - Ownable: Owner-based access control
 */
contract USDToken is ERC20, ERC20Burnable, ERC20Pausable, ERC20Capped, ERC20Permit, Ownable {
    /// @dev Initial token supply (300,000 USDT with 6 decimals like real USDT)
    uint256 public constant INITIAL_SUPPLY = 300000 * 10 ** 6;
    
    /// @dev Maximum cap for token supply
    uint256 public constant MAX_CAP = 1000000000 * 10 ** 6; // 1 billion USDT

    /**
     * @dev Constructor that initializes the token and mints initial supply
     */
    constructor() 
        ERC20("USD Token", "USDT") 
        ERC20Capped(MAX_CAP)
        ERC20Permit("USD Token")
        Ownable(msg.sender)
    {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev Pauses all token transfers
     * @notice Only the owner can call this function
     * Can be used in case of emergency or security issue
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers
     * @notice Only the owner can call this function
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Mint new tokens (only owner can mint)
     * @param to Address to receive the minted tokens
     * @param amount Amount of tokens to mint
     * @notice Cannot exceed the token cap (MAX_CAP)
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Override decimals to return 6 (like real USDT)
     */
    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /**
     * @dev Override required by Solidity - handles token transfers
     * Applies pause check and cap limit
     */
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable, ERC20Capped) whenNotPaused {
        super._update(from, to, amount);
    }

    /**
     * @dev Override required by Solidity - nonce tracking for permit
     */
    function nonces(address owner)
        public
        view
        override(ERC20Permit)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
