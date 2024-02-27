// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Create {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    //candidate for voting
    struct Candidate {
        uint256 candidateId;
        string candidateName;
        uint256 candidateAge;
        string candidateImage;
        uint256 voteCount;
        address _address;
        string ipfs;
    }

    event CandidateCreate (
        uint256 indexed candidateId,
        string candidateName,
        uint256 candidateAge,
        string candidateImage,
        uint256 voteCount,
        address _address,
        string ipfs
    );

    address[] public candidateAddress;

    mapping(address => Candidate) public candidates;

    //voter data
    address[] public votedVoters;

    address[] public votersAddress;
    mapping(address => Voter) public voters;

    struct Voter {
        uint256 voter_id;
        string voter_name;
        string voter_image;
        address voter_address;
        uint256 voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
        string voter_ipfs;
    }

    event VoterCreated (uint256 indexed voter_id,
        string voter_name,
        string voter_image,
        address voter_address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string voter_ipfs);

    constructor (){
        votingOrganizer = msg.sender;
    }

    function setCandidate(address _address, string memory _candidateName, uint256 _candidateAge, string memory _candidateImage, string memory _ipfs) public {
        require(votingOrganizer == msg.sender, "You do not have permission to add candidate");
        _candidateId.increment();
        uint256 idNumber =_candidateId.current();
        Candidate storage candidate = candidates[_address];
        candidate.candidateId = idNumber;
        candidate._address = _address;
        candidate.candidateName = _candidateName;
        candidate.candidateAge = _candidateAge;
        candidate.candidateImage = _candidateImage;
        candidate.voteCount =0;
        candidate.ipfs = _ipfs;

        candidateAddress.push(_address);
        emit CandidateCreate(idNumber,
        _candidateName,
        _candidateAge,
        _candidateImage,
        candidate.voteCount,
        _address,
        _ipfs);
    }

    function getCandidate() public view returns (address[] memory) {
        return candidateAddress;
    }

    function getCandidateLength() public view returns (uint256) {
        return candidateAddress.length;
    }

    function getCandidateData(address _address) public view returns(uint256, string memory, uint256, string memory, uint256, address, string memory) {
        return (candidates[_address].candidateId,
            candidates[_address].candidateName,
            candidates[_address].candidateAge,
            candidates[_address].candidateImage,
            candidates[_address].voteCount,
            candidates[_address]._address,
            candidates[_address].ipfs);
    }

    function voterRight(address _address, string memory _name, uint256 _age, string memory _image, string memory _ipfs) public {
        require(votingOrganizer == msg.sender, "You do not have permission to add voter");
        _voterId.increment();
        uint256 idNumber =_voterId.current();
        Voter storage voter = voters[_address];
        require(voter.voter_allowed==0);
        voter.voter_allowed = 1;
        voter.voter_id = idNumber;
        voter.voter_name = _name;
        voter.voter_image = _image;
        voter.voter_address = _address;
        voter.voter_vote = 1000;
        voter.voter_voted = false;
        voter.voter_ipfs = _ipfs;

        votersAddress.push(_address);

        emit VoterCreated (idNumber,
        voter.voter_name,
        voter.voter_image,
        voter.voter_address,
        voter.voter_allowed,
        voter.voter_voted,
        voter.voter_vote,
        voter.voter_ipfs);
    }

    function vote(address _candidateAddress, uint256 _candidateVoteId) external {
        Voter storage voter = voters[msg.sender];
        require(!voter.voter_voted, "You have already voted");
        require(voter.voter_allowed != 0, "You have no right to vote");
        voter.voter_voted = true;
        voter.voter_vote = _candidateVoteId;
        votedVoters.push(msg.sender);
        candidates[_candidateAddress].voteCount += voter.voter_allowed;
    }

    function getVoterLength() public view returns (uint256){
        return votersAddress.length;
    }

    function getVoterData (address _address) public view returns (uint256, string memory, string memory, address, string memory, uint256, bool) {
        return (voters[_address].voter_id,
            voters[_address].voter_name,
            voters[_address].voter_image,
            voters[_address].voter_address,
            voters[_address].voter_ipfs,
            voters[_address].voter_allowed,
            voters[_address].voter_voted);
    }

    function getVotedVoterList() public view returns (address[] memory){
        return votedVoters;
    }

    function getVoterList() public view returns (address[] memory){
        return votersAddress;
    }
}