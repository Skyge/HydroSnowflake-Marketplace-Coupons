pragma solidity ^0.5.2;

import "./SnowflakeERC721.sol";
import "../../access/roles/MinterRole.sol";

/**
 * @title SnowflakeERC721Mintable
 * @dev Snowflake ERC721 minting logic
 */
contract SnowflakeERC721Mintable is SnowflakeERC721, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The EIN that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(uint256 to, uint256 tokenId) public onlyMinter returns (bool) {
        _mint(to, tokenId);
        return true;
    }
}