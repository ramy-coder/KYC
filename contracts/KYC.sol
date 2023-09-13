    //SPDX-License-Identifier: MIT
    pragma solidity ^0.8.9;

    import 'openzeppelin-solidity/contracts/access/Ownable.sol';

    contract KYC is Ownable {
    struct Bank {
        string name;
        address ethAddress;
        string regNumber;
        uint complaintsRep;
        uint kycCount;
        bool isAllowedtoVote;
    }

     struct kycRequest{
        string userName;
        string data;
        address bank;
     }

     struct Customer {
        string userName;
        string data;
        address bank;
        bool kycStatus;
        uint downVotes;
        uint upVotes;
    }


        mapping(string => Customer) customers;
        mapping(string => kycRequest) kycRequests;
        mapping(address => Bank) banks;

        uint numCustomers;
        uint numBanks;
        address admin;

    constructor() {
        numCustomers = 0;
        numBanks = 0;
        admin = msg.sender;
    }

    //Modifier to check if the customer is already present
    modifier isaCustomer(string memory _userName){
        string memory temp = customers[_userName].userName;
        if(keccak256(abi.encodePacked(temp)) == keccak256(abi.encodePacked("")))
        {            assert(true);        }
        else
        {            assert(false);        }
        _;
    }

    //Modifier to check if the Bank is Allowed to vote for customers
    modifier isAllowedtoVoteMod(address _bankAddress)
    {
        require(banks[_bankAddress].isAllowedtoVote == true, "Bank is not allowed to vote");
        _;
    }

    //Adding the request for new customer to the system
    function addRequest(string memory _userName,string memory _data) public isaCustomer(_userName)
    {
        kycRequests[_userName].userName = _userName;
        kycRequests[_userName].data = _data;
    }

    //Removes the Request for the customer from the system
    function removeRequest(string memory _userName) public
    {
        delete kycRequests[_userName];
    }

    //view the details of an existing bank in the system
    function viewBankDetails(address _bankAddress) public view returns (string memory, address, string memory,uint,uint,bool)
    {
        return (banks[_bankAddress].name, banks[_bankAddress].ethAddress, banks[_bankAddress].regNumber,
                banks[_bankAddress].complaintsRep,banks[_bankAddress].kycCount,banks[_bankAddress].isAllowedtoVote);

    }

    //adding the details of a new Bank to the system by the admin
    function addBank(string memory _bankName, address _bankAddress, string memory _bankRegn) public onlyOwner
    {
        banks[_bankAddress].name = _bankName;
        banks[_bankAddress].ethAddress = _bankAddress;
        banks[_bankAddress].regNumber = _bankRegn;
        banks[_bankAddress].isAllowedtoVote = true;
        banks[_bankAddress].kycCount = 0;
        banks[_bankAddress].complaintsRep = 0;
        numBanks += 1;
    }

    //modify the voting status of an existing Bank if done by Admin
    function modifyBank(address _bankAddress, bool _currentVotingStatus) public onlyOwner {
        banks[_bankAddress].isAllowedtoVote = _currentVotingStatus;
    }

    //Remove an existing bank from the list of banks if done by Admin
    function removeBank(address _bankAddress) public onlyOwner {
        delete banks[_bankAddress];
    }

    //Get the number of complaints reported on a bank
    function getBankComplaints(address _bankAddress) public view returns (uint){
        return (banks[_bankAddress].complaintsRep);
    }

    //changes bank's isAllowedtoVote to false if the number of complaints is greater than one-third of the total banks
    function reportBank(address _bankAddress) public {
        banks[_bankAddress].complaintsRep +=1;
        uint minBanks = (numBanks/3);
        if(getBankComplaints(_bankAddress) > minBanks)
        {
            banks[_bankAddress].isAllowedtoVote = false;
        }
    }

    //Valid Requests are added as Customers by the Bank
    function addCustomer(string memory _userName, string memory _customerData) isAllowedtoVoteMod(msg.sender) public {
        require(customers[_userName].bank == address(0), "Customer is already present, please call modifyCustomer to edit the customer data");
        customers[_userName].userName = _userName;
        customers[_userName].data = _customerData;
        customers[_userName].bank = msg.sender;
        customers[_userName].kycStatus = true;
        customers[_userName].upVotes = 0;
        customers[_userName].downVotes = 0;
        numCustomers +=1;
    }

    //View existing customers
    function viewCustomer(string memory _userName) public view returns (string memory, string memory, address,bool,uint,uint) {
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        return (customers[_userName].userName,  customers[_userName].data,     customers[_userName].bank
                 ,customers[_userName].kycStatus, customers[_userName].downVotes, customers[_userName].upVotes);
    }

    //update customer details
    function modifyCustomer(string memory _userName, string memory _newcustomerData) isAllowedtoVoteMod(msg.sender) public {
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        customers[_userName].data = _newcustomerData;
    }

    //Upvote the credibility of a customer by upvoting and check the KYC status of the customer
    function upVoteCustomer(string memory _userName,address _bankAddress) isAllowedtoVoteMod(_bankAddress) public {
        customers[_userName].upVotes += 1;
        checkCustomerStatus(_userName);
    }

    //Downvote the credibility of a customer by upvoting and check the KYC status of the customer
    function downVoteCustomer(string memory _userName,address _bankAddress) isAllowedtoVoteMod(_bankAddress) public {
        customers[_userName].downVotes += 1;
        checkCustomerStatus(_userName);
    }


    // checks the current KYC status of the Customer
    function checkCustomerStatus(string memory _userName) private {
        uint numVotes;
        numVotes = customers[_userName].upVotes + customers[_userName].downVotes;
        /* The KYC status of a customer is set to false if number of downvotes > one-third of total number of banks.
        A minimum of 5 votes by banks(upvotes + downvotes) are needed to perform this change of KYC status
        */
        if(numVotes >= 5)
        {
            uint minVotes = numBanks/3;
            if (customers[_userName].downVotes > minVotes)
            {
                customers[_userName].kycStatus = false;
            }
        }

    }


}
