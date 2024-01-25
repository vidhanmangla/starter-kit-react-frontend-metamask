// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

abstract contract OracleInterface {
  function getLatestOffChainData() public virtual returns (uint256);
}