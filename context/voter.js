import React, {useEffect, useState} from 'react';
import {useRouter} from 'next/router';
import axios from 'axios';
import Web3Modal from 'web3modal';
import {ethers} from 'ethers';
import {create as ipfsHttpClient} from 'ipfs-http-client';
import { VotingAddress, VotingAddressABI} from './constants';

const client = ipfsHttpClient("https://ipfs.infura.io:5001/api/v0");

const fetchContract = (signerOrProvider) => {
  new ethers.Contract(VotingAddress, VotingAddressABI, signerOrProvider);
};

export const VotingContext = React.createContext();

export const VotingProvider = ({children}) => {
  const votingTitle = "Test title";
  const router = useRouter();
  const [currentAccount, setCurrentAccount] = useState('');
  const [candidateLength, setCandidateLength] = useState('');
  const pushCandidate = [];
  const candidateIndex = [];
  const [candidateArray, setCandidateArray] = useState(pushCandidate);

  const [error, setError] = useState('');
  const highestVote = [];

  const pushVoter = [];
  const [voterArray, setVoterArray] = useState(pushVoter);
  const [voterLength, setVoterLength] = useState('');
  const [voterAddress, setVoterAddress] = useState([]);

  //connecting metamask wallet
  const checkIfWalletIsConnected = async () => {
    if(!window.ethereum){
      return setError("Please Install Metamask");
    };
    const account = await window.ethereum.request({method: "eth_accounts"});
    if(account.length){
      setCurrentAccount(account[0]);
    }else{
      setError("Please Install Metamask, Connect and Reload");
    }
  };

  const connectWallet = async () => {
    if(!window.ethereum){
      return setError("Please Install Metamask");
    };
    const account = await window.ethereum.request({method: "eth_requestAccounts"});
    setCurrentAccount(account[0]);
  };

  const uploadToIPFS = async (file) => {
    try{
      const added = await client.add({content: file});
      const url = `https://ipfs.infura.io/ipfs/${added.path}`
      return url;
    }catch(error){
      setError("Error uploading to IPFS");
    }
  };

  return (
  <VotingContext.Provider value={{votingTitle}}>
    {children}
  </VotingContext.Provider>
  )
};


const voter = () => {
  return (
    <div>
      
    </div>
  )
}

export default voter
