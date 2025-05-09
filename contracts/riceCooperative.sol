// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RiceCooperative {
    struct Farmer {
        address wallet;
        string name;
        uint256 balance;
        bool registered;
    }

    struct ServiceRequest {
        uint256 id;
        address farmer;
        string serviceType;
        bool fulfilled;
    }

    mapping(address => Farmer) public farmers;
    mapping(uint256 => ServiceRequest) public serviceRequests;
    uint256 public requestCount;

    event FarmerRegistered(address indexed farmer, string name);
    event ServiceRequested(uint256 indexed requestId, address indexed farmer, string serviceType);
    event ServiceFulfilled(uint256 indexed requestId);
    event PaymentMade(address indexed farmer, uint256 amount);

    modifier onlyRegistered() {
        require(farmers[msg.sender].registered, "Not a registered farmer");
        _;
    }

    function registerFarmer(string memory name) public {
        require(!farmers[msg.sender].registered, "Farmer already registered");
        farmers[msg.sender] = Farmer(msg.sender, name, 0, true);
        emit FarmerRegistered(msg.sender, name);
    }

    function requestService(string memory serviceType) public onlyRegistered {
        requestCount++;
        serviceRequests[requestCount] = ServiceRequest(requestCount, msg.sender, serviceType, false);
        emit ServiceRequested(requestCount, msg.sender, serviceType);
    }

    function fulfillService(uint256 requestId) public {
        require(requestId > 0 && requestId <= requestCount, "Invalid request ID");
        serviceRequests[requestId].fulfilled = true;
        emit ServiceFulfilled(requestId);
    }

    function recordSale(address farmer, uint256 amount) public {
        farmers[farmer].balance += amount;
    }

    function deductServiceCost(uint256 requestId, uint256 cost) public {
        require(serviceRequests[requestId].fulfilled, "Service not fulfilled");
        farmers[serviceRequests[requestId].farmer].balance -= cost;
    }

    function makePayment(address farmer) public {
        uint256 payment = farmers[farmer].balance;
        farmers[farmer].balance = 0;
        payable(farmer).transfer(payment);
        emit PaymentMade(farmer, payment);
    }

    receive() external payable {}
}