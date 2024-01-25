// SPDX-License-Identifier: MIT


/// @dev it is recommended that Solidity contracts are fully annotated using NatSpec for all public interfaces (everything in the ABI)
/// @dev documentation is inserted above each contract, interface, library, function, and event using NatSpec notation format
/// @dev a public state variable is equivalent to a function for the purposes of NatSpec


pragma solidity 0.8.19;


import "./Interfaces/OracleInterface.sol";
import "./Interfaces/Ownable.sol";


/* ERRORS */

error Client__NotInMempool();
error Client__NotAuthorized();


/// @title client contract
/// @author vidhan.mangla@mqube.com
/// @notice this contract uses the oracle interface to interact and pull decentralized data from the oracle
/// @dev will add later if necessary
contract Client is Ownable {


  /* STATE VARIABLES */

  uint256 private offChainData;
  OracleInterface private oracleInstance;
  address private oracleAddress;


  /* MAPPINGS */

  mapping(uint256=>bool) myRequests;


  /* EVENTS */

  event newOracleAddressEvent(address oracleAddress);
  event ReceivedNewRequestIdEvent(uint256 id);
  event OffChainDataUpdatedEvent(uint256 offChainData, uint256 id);
  event EtherReceivedEvent(address sender, uint256 amount);


  /* MODIFIERS */

  modifier onlyOracle() {
    if (msg.sender != oracleAddress) {
      revert Client__NotAuthorized();
    }
    _;
  }


  /* FUNCTIONS */

  /// @notice set the address of an oracle instance
  function setOracleInstanceAddress (address _oracleInstanceAddress) public onlyOwner {
    oracleAddress = _oracleInstanceAddress;
    oracleInstance = OracleInterface(oracleAddress);
    emit newOracleAddressEvent(oracleAddress);
  }

  /// @notice receives the request id from the oracle
  function updateOffChainData() public {
    uint256 id = oracleInstance.getLatestOffChainData();
    myRequests[id] = true;
    emit ReceivedNewRequestIdEvent(id);
  }

  /// @notice updates the offChainData received
  function callback(uint256 _offChainData, uint256 _id) public onlyOracle {
    // require(myRequests[_id], "This request is not in my mempool.");
    if (!myRequests[_id]) {
      revert Client__NotInMempool();
    }
    offChainData = _offChainData;
    delete myRequests[_id];
    emit OffChainDataUpdatedEvent(_offChainData, _id);
  }


  /* RECEIVE & FALLBACK FUNCTIONS */

  /// @dev allows the contract to directly receive ether
  receive() external payable {
      emit EtherReceivedEvent(msg.sender, msg.value);
  }

  /// @dev a catch-all for any ether sent to the contract in cases not covered by the receive function
  fallback() external payable {
      emit EtherReceivedEvent(msg.sender, msg.value);
  }


}