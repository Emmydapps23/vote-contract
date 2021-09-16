pragma solidity 0.5.16;

contract Voting {
// the struct allows us to group otherdata types together
//struct for candidate
    struct Candidate {
        string name;
        uint voteCount;
    }
// struct for voter to store if the voter has voted before and they have voted for
    struct Voter {
        bool voted;
        uint voteIndex;
        uint weight; // to specify the weight ofa  vote

    }
    //keeping track of the owner of  the contract
    address public owner;
    string public name;
    //keep amapping to store voting information as well as the dynamically-sized array of candidates 
    //that will be initialized on constructor
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    //using timestamp for when election ends
    uint public auctionEnd;
    
    event ElectionResult(string _name, uint voteCount);
    
    //initialize list of candidates in the  constructor
    function election(string memory _name, uint durationMinutes, string memory candidate1, string memory candidate2, string memory candidate3) public {
        owner = msg.sender;
        name = _name;
        auctionEnd = now + (durationMinutes * 1 minutes);
        
    
        candidates.push(Candidate(candidate1, 0)); // defining candidate objects
        candidates.push(Candidate(candidate2, 0));
        candidates.push(Candidate(candidate3, 0));
    }
    // a function that allows the owner of the contract to give voting rights to addresses
    function authorize(address voter) public {
        require(msg.sender == owner);
        require(!voters[voter].voted);

        voters[voter].weight = 1; // it will only count authoriized vote as 1
    }
    // a function that will allowany authorized voterto csubmit their vote
    function vote(uint voteIndex) public {
        require(now < auctionEnd); //check that time to vote hasn't ended
        require(!voters[msg.sender].voted);

        voters[msg.sender].voted = true; // marked as vote
        voters[msg.sender].voteIndex = voteIndex; //to increase the vote count for the specified candidate

        candidates[voteIndex].voteCount += voters[msg.sender].weight; //it allows anyone to vote but the vote won't count
    }
    function end() public {
        require(msg.sender == owner);
        require(now >= auctionEnd); //owner cannot end election before time

        for(uint i=0; i < candidates.length; i++) {
           emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        }

    }
}