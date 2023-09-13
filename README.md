# KYC
## Know Your Customer project for banks implemented using truffle and geth

### Smart Contract Flow

The bank collects the information for the KYC from the customer.

The information given by the customer includes username and customer data, which is the hash of the link for the customer data. This username is unique for each customer. 

A bank creates the request for submission, which is stored in the smart contract.

A bank then verifies the KYC data, which is then added to the customer list.

Other banks can get customer information from the customer list.

Other banks can also provide upvotes/downvotes on customer data to showcase the authenticity of the data. If the number of upvotes is greater than the number of downvotes, then the kycStatus of that customer is set to true. If a customer gets downvoted by one-third of the banks, then the kycStatus of the customer is changed to false even if the number of upvotes is more than that of downvotes. For such logic, there should be a minimum of 5 or 10 banks in the network. 

In short, there are two conditions to be checked: The number of upvotes and downvotes and whether the number of downvotes is greater than one-third of the total number of banks. 

Banks can also complain against other banks if they find the bank to be corrupt and if it is verifying false customers. Such corrupted banks will then be banned from upvoting/downvoting further. If more than one-third of the total banks in the network complain against a certain bank, then the bank will be banned (i.e., set isAllowedToVote to false of that corrupt bank.).

**Implementation Details**
We need 2 terminals to implement the Truffle Deployment of the KYC Smart Contract. One to connect to truffle and another to implement the Blockchain in Local System.

**Terminal 1:**

	truffle init
	truffle compile

The below 2 commands need to be run to use the OpenZeppelin contracts in the KYC Contract
	npm init -y
	npm install –save-exact openzeppelin-solidity

The commands in terminal 2 should be run now

	truffle migrate –network geth
	truffle console –network geth
To obtain a Smart contract instance 
	let kyc = await KYC.deployed()

All the functions in the Smart Contract can be run using this instance 
Eg: kyc.addRequest(‘Ramya’, ‘Coimbatore’)

**Terminal 2:**

I have a blockchain deployed in my ubuntu machine at the directory ethpvtnet
I implement the below commands to start mining in my Blockchain

	> cd ethpvtnet
	> geth –datadir ./datadir –networkid 2019 –http –http.port 30304 –allow-insecure-unlock console
	> personal.newAccount(‘Ramya’) to create new Accounts on the Blockchain
	> miner.setEtherbase(‘Account ID’)
	> miner.start()
