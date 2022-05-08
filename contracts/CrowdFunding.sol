//SPDX-License-Identifier: Unlicense
// 创建不同的募资活动, 用来募集以太坊
// 记录响应活动下的墨子总体信息(参与人数, 募集的以太坊数量), 以及记录参与的用户地址以及投入的数量
// 业务逻辑 (用户参与, 添加新的募集活动, 活动结束后进行资金领取)
pragma solidity ^0.8.13;

contract CrowdFunding {
  address immutable owner;

  constructor() {
    owner = msg.sender;
  }

  struct Campaign {
    address payable receiver;
    uint256 numFunders;
    uint256 fundingGoal;
    uint256 totalAmount;
  }

  struct Funder {
    address addr;
    uint256 amount;
  }

  uint256 public numCampaigns;
  mapping(uint256 => Campaign) campaigns;
  mapping(uint256 => Funder[]) funders;
  mapping(uint256 => mapping(address => bool)) public isParticipate;

  modifier judgeParticipate(uint256 campaignID) {
    require(!isParticipate[campaignID][msg.sender]);
    _;
  }

  modifier isOwner() {
    require(msg.sender == owner);
    _;
  }

  function newCampaign(address payable receiver, uint256 goal)
    external
    isOwner
    returns (uint256 campaignID)
  {
    campaignID = numCampaigns++;
    Campaign storage c = campaigns[campaignID];
    c.receiver = receiver;
    c.fundingGoal = goal;
  }

  function bid(uint256 campaignID)
    external
    payable
    judgeParticipate(campaignID)
  {
    Campaign storage c = campaigns[campaignID];

    c.totalAmount += msg.value;
    c.numFunders += 1;

    funders[campaignID].push(Funder({addr: msg.sender, amount: msg.value}));

    isParticipate[campaignID][msg.sender] = true;
  }

  function withdraw(uint256 campaignID) external returns (bool reached) {
    Campaign storage c = campaigns[campaignID];
    if (c.totalAmount < c.fundingGoal) {
      return false;
    }
    uint256 amount = c.totalAmount;
    c.totalAmount = 0;
    c.receiver.transfer(amount);
    return true;
  }
}
