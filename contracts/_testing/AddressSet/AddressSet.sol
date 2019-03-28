pragma solidity ^0.5.0;

/**
 * @title An implementation of the set data structure for addresses.
 * @author Noah Zinsmeister, Skyge.
 * @dev O(1) insertion, removal, contains, and length functions.
 */
library AddressSet {
    struct Set {
        address[] members;
        mapping(address => uint256) memberIndices;
    }

    /**
     * @dev Inserts an element into a set. If the element already exists in the set, the function is a no-op.
     * @param self The set to insert into.
     * @param candidateAddress The element to insert.
     */
    function insert(Set storage self, address candidateAddress) public {
        if (!contains(self, candidateAddress)) {
            self.memberIndices[candidateAddress] = self.members.push(candidateAddress);
        }
    }

    /**
     * @dev Removes an element from a set. If the element does not exist in the set, the function is a no-op.
     * @param self The set to remove from.
     * @param invalidAddress The element to remove.
     */
    function remove(Set storage self, address invalidAddress) public {
        if (contains(self, invalidAddress)) {
            // replace other with the last element
            self.members[self.memberIndices[invalidAddress] - 1] = self.members[length(self) - 1];
            // reflect this change in the indices
            self.memberIndices[self.members[self.memberIndices[invalidAddress] - 1]] = 
            self.memberIndices[invalidAddress];
            delete self.memberIndices[invalidAddress];
            // remove the last element
            self.members.pop();
        }
    }

    /**
     * @dev Checks set membership.
     * @param self The set to check membership in.
     * @param queryAddress The element to check membership of.
     * @return true if the element is in the set, false otherwise.
     */
    function contains(Set storage self, address queryAddress) public view returns (bool) {
        return (
            self.memberIndices[queryAddress] > 0 && 
            self.members.length >= self.memberIndices[queryAddress] && 
            self.members[self.memberIndices[queryAddress] - 1] == queryAddress
        );
    }

    /**
     * @dev Returns the number of elements in a set.
     * @param self The set to check the length of.
     * @return The length of the set.
     */
    function length(Set storage self) public view returns (uint256) {
        return self.members.length;
    }
}
