// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract crowdfunding{

    //variables
   address public creator;
   uint256 public goal;
   uint256 public deadline;
   mapping(address=>uint256) public contributions;
   uint256 public totalcontributions;
   bool public isfunded;
   bool public iscompleted;
   event Goalreached(uint256 totalcontributions);
   event fundtransfer(address backer, uint256 amount);
   event deadlinereached(uint256 totalcontributions);
  

  //initialization
  constructor(uint256 goalineth,uint256 durationinminutes){
    creator=msg.sender;
    goal=goalineth* 1 ether;
    deadline=block.timestamp+durationinminutes*1 minutes;
    isfunded=false;
    iscompleted=false;


  }

  modifier onlycreator(){
    require(msg.sender==creator,"owner");
    _;
  }

  function contribute() public payable{
    require(block.timestamp<deadline,"funding period is over");
    require(!iscompleted,"already completed");
    uint256 contribution= msg.value;
    contributions[msg.sender]+= contribution;
    totalcontributions+= contribution;

    if(totalcontributions>=goal){
        isfunded=true;
        emit Goalreached(totalcontributions);
    }
    emit fundtransfer(msg.sender,contribution);


  }

  function withdrawfunds() public onlycreator{
    require(isfunded,"goal has not been reached");
    require(!iscompleted,"crowdfunding is already completed");
    iscompleted=true;
    payable(creator).transfer(address(this).balance);
  }

  function getrefund() public{
    require(block.timestamp>= deadline,"funding period has not ended");
    require(contributions[msg.sender]>0,"no contribution to refuse");
    uint256 contribution=contributions[msg.sender];
    contributions[msg.sender]=0;
      totalcontributions-= contribution;
       payable(msg.sender).transfer(contribution);
       emit fundtransfer(msg.sender, contribution);
  }


  function getcurrentbalance()
 public view returns (uint256){
    return address(this).balance;
 }

 


}