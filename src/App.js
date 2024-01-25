import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import logo from './logo.svg';
import './App.css';

function App() {
  const [isConnected, setIsConnected] = useState(false);
  const [userAddress, setUserAddress] = useState(null);

  // Connect to MetaMask
  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        setUserAddress(accounts[0]);
        setIsConnected(true);
      } catch (error) {
        console.error("Error connecting to MetaMask", error);
      }
    } else {
      console.log("MetaMask not available");
    }
  };

  useEffect(() => {
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts) => {
        setUserAddress(accounts[0] || null);
        setIsConnected(!!accounts.length);
      });
    }
  }, []);

  // Add more functions here for contract interactions

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>Hello Ethereum World!</p>
        {isConnected ? (
          <p>Connected: {userAddress}</p>
        ) : (
          <button onClick={connectWallet}>Connect Wallet</button>
        )}
        {/* Add more interactive elements here for contract interactions */}
      </header>
    </div>
  );
}

export default App;
