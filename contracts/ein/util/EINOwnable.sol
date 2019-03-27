pragma solidity ^0.5.0;

/**
 * @title EINOwnable
 * @dev The EINOwnable contract has an owner EIN, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract EINOwnable {
    uint256 private _ownerEIN;
    mapping(address => uint256) usersEIN;
    mapping(uint256 => address) identifyUsers;

    event OwnershipTransferred(
        uint indexed previousOwner,
        uint indexed newOwner
    );

    /**
     * @dev The SnowflakeEINOwnable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor(address ownerAddress, uint256 ein) public {
        _constructEINOwnable(ownerAddress, ein);
    }

    function _constructEINOwnable(address ownerAddress, uint256 ein) internal {
        _ownerEIN = ein;
        usersEIN[ownerAddress] = ein;
        identifyUsers[ein] = ownerAddress;
        // Since 0 likely represents someone's EIN, it can be confusing to specify 0, so commenting this out in
        // the meantime.
        // CORRECTION: 0 is actually guaranteed to be no one's EIN, so this is ok! :D And even better, we can use
        // this fact to use EIN 0 as a null/empty/burner EIN.
        emit OwnershipTransferred(0, ein);
    }

    /**
     * @return the EIN of the owner.
     */
    function ownerEIN() public view returns (uint256) {
        return _ownerEIN;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyEINOwner() {
        require(isEINOwner(usersEIN[msg.sender]));
        _;
    }

    /**
     * @return true if address resolves to owner of the contract.
     */
    function isEINOwner(uint256 accountEIN) public view returns (bool) {
        return accountEIN == _ownerEIN;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyEINOwner {
        emit OwnershipTransferred(_ownerEIN, 0);
        _ownerEIN = 0;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(uint256 newOwner) public onlyEINOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(uint256 newOwner) internal {
        require(identifyUsers[newOwner] != address(0));
        emit OwnershipTransferred(_ownerEIN, newOwner);
        _ownerEIN = newOwner;
    }
}
