# KYC
Know Your Customer project for banks


This project is implemented using truffle and geth
We need 2 terminals to implement the Truffle Deployment of the KYC Smart Contract. One to connect to truffle and another to implement the Blockchain in Local System.

Terminal 1:

	truffle init
	truffle compile

The below 2 commands need to be run to use the OpenZeppelin contracts in the KYC Contract
	npm init -y
	npm install –save-exact openzeppelin-solidity

The commands in terminal 2 should be run now

	truffle migrate –network geth
	truffle console –network geth
	To obtain a Smart contract instance 
let kyc = await KYC.deployed()
	All the functions in the Smart Contract can be run using this instance 
Eg: kyc.addRequest(‘Ramya’, ‘Coimbatore’)

Terminal 2:
I have a blockchain deployed in my ubuntu machine at the directory ethpvtnet
I implement the below commands to start mining in my Blockchain
	cd ethpvtnet
	geth –datadir ./datadir –networkid 2019 –http –http.port 30304 –allow-insecure-unlock console
	personal.newAccount(‘Ramya’) to create new Accounts on the Blockchain
	miner.setEtherbase(‘Account ID’)
	miner.start()
