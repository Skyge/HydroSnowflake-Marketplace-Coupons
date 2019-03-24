pragma solidity ^0.5.0;


contract ReturnPolicies {


    //ID    
    uint public nextReturnPoliciesID;

    //Struct
    mapping(uint => ReturnPolicy) public returnPolicies;

    
    constructor() public {
        nextReturnPoliciesID = 1;
    }


    struct ReturnPolicy {
        bool returnsAccepted;
        uint timeLimit;
    }

/*
==============================
ReturnPolicy add/update/delete
==============================
*/

    function addReturnPolicy(bool returnsAccepted, uint timeLimit) public onlyEINOwner returns (bool) {
        //Add to returnPolicies
        returnPolicies[nextReturnPoliciesID] = ReturnPolicy(returnsAccepted, timeLimit);
        //Advance return policy ID by one
        nextReturnPoliciesID++;

        return true;
    }

    function updateReturnPolicy(uint id, bool returnsAccepted, uint timeLimit) public onlyEINOwner returns (bool) {
        //Update returnPolicies by ID
        returnPolicies[id] = ReturnPolicy(returnsAccepted, timeLimit);
        return true;
    }

    function deleteReturnPolicy(uint id) public onlyEINOwner returns (bool) {
        //Delete Return Policy identified by ID
        delete returnPolicies[id];
        return true;
    }


}
