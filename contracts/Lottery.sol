pragma solidity ^0.5.0;

import "./Ownable.sol";

contract Lottery is Ownable {
    address[] public players;
    uint public previousDrawDate;
    address public previousWinner;
    
    constructor() public {
        previousDrawDate = block.timestamp;
    }

    function enterLottery() public payable {
        require(!isOwner(), "Owner can not take part");
        require(msg.value > 0.1 ether, "Insufficient Ether");
        players.push(msg.sender);
    }
    
    function pickWinner() public onlyOwner {
        previousDrawDate = now;
        require(players.length > 0, "No players took part!");
        uint winner = random() % players.length;
        address payable wallet = address(uint160(players[winner]));
        previousWinner = wallet;
        wallet.transfer(address(this).balance);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }
}