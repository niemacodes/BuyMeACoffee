//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Deployed to Goerli at this address: 0xe87EF0841002C44FF61278E5bDc2a63D0882e0D4
contract BuyMeACoffee {

    // Define a new event to emit when a memo is created:
    event NewMemo(

        // When we're issuing a new memo we 
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Create a memo struct: contains address of the person submitting 
    // a memo. 
    struct Memo {
        address from;
        uint256 timestamp; 
        string name;
        string message; 
    }

    // Address of contract deployer:
    // A state variable we want to make sure our address has: 
    address payable owner;

    // List of all memos received from friends:
    Memo[] memos;

    // Constructor: 
    // Logic is run only once when contract is deployed:
    constructor(){

        // Define who this is by checking who's deployed this contract. 
        owner = payable(msg.sender);
    }

   /**
     * @dev retrieves all the memos receievd and stored on the blockchain
     */
     function getMemos() public view returns(Memo[] memory) {
         return memos;
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message from the coffee buyer
     */
     function buyCoffee(string memory _name, string memory _message) public payable{

         // first check that the amount that was paid should be greater than 0:
         require(msg.value > 0, "Can't buy me a cup of coffee with 0 ETH.");

         // Create a new memo & add it to internal storage:
         memos.push(Memo(
             msg.sender, 
             block.timestamp,
             _name,
             _message
         ));

        // Emit a new log event when a memo is created: 
        emit NewMemo(
            msg.sender, 
            block.timestamp, 
            _name, 
            _message
        );
     }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
     function withdrawTips() public {
         
         // this will send money to the original owner balance: 
         require(owner.send(address(this).balance));
     }
}
