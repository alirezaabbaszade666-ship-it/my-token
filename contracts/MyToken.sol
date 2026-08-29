// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @dev Production-ready ERC20 token contract with enhanced features
 * - Burnable: Allows token holders to burn their tokens
 * - Pausable: Allows the owner to pause all transfers
 * - Ownable: Owner-based access control
 */
contract MyToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    /// @dev Initial token supply (300,000 tokens with 18 decimals)
    uint256 public constant INITIAL_SUPPLY = 300000 * 10 ** 18;

    /**
     * @dev Constructor that mints initial supply to the deployer
     */
    constructor() ERC20("USD Token", "USDT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev Pauses all token transfers
     * @notice Only the owner can call this function
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
     * @dev Override required by Solidity - handles token transfers with pause check
     */
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) whenNotPaused {
        super._update(from, to, amount);
    }
}
