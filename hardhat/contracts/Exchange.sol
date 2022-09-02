// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {

address public cryptoDevTokenAddress;

constructor(address _CryptoDevtoken) ERC2("CryptoDev LP Token", "CDLP"){
    require(_CryptoDevtoken != address(0), "Token Address Passed is a null address ");
    cryptoDevTokenAddress = _CryptoDevtoken;
}

// Get Reserve Balance of Contract
function getReserve() public view returns (uint) {
    return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
}

// Adds Liquidity  to the exchange.
function addLiquidity(uint _amount) public payable returns(uint){
    uint liquidity;
    uint ethBalance = address(this).balance;
    uint cryptoDevTokenReserve = getReserve();
    ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        if(cryptoDevTokenReserve == 0) {
        cryptoDevToken.transferFrom(msg.sender, address(this), _amount);

        liquidity = ethBalance;
        _mint(msg.sender, liquidity);
    } else {

        uint ethReserve =  ethBalance - msg.value;
     
        uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve)/(ethReserve);
        require(_amount >= cryptoDevTokenAmount, "Amount of tokens sent is less than the minimum tokens required");
  
        cryptoDevToken.transferFrom(msg.sender, address(this), cryptoDevTokenAmount);
   
        liquidity = (totalSupply() * msg.value)/ ethReserve;
        _mint(msg.sender, liquidity);
    }
     return liquidity;
}


// Remove Liquidity

function removeLiquidity(uint _amount) public returns (uint , uint) {
    require(_amount > 0, "_amount should be greater than zero");
    uint ethReserve = address(this).balance; 
    uint _totalSupply = totalSupply();

    uint ethAmount = (ethReserve * _amount)/ _totalSupply;
    uint cryptoDevTokenAmount = (getReserve() * _amount)/ _totalSupply;

    _burn(msg.sender, _amount);
     payable(msg.sender).transfer(ethAmount);

    // Transfer Token from user wallet back to Contract 
    ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
    return (ethAmount, cryptoDevTokenAmount);
    
}


//? Get Amount of Token
function getAmountOfTokens(uint256 inputAmount,uint256 inputReserve,uint256 outputReserve
)public pure returns (uint256) {
    require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
    // We are charging a fee of `1%`
    // Input amount with fee = (input amount - (1*(input amount)/100)) = ((input amount)*99)/100
    uint256 inputAmountWithFee = inputAmount * 99;

    uint256 numerator = inputAmountWithFee * outputReserve;
    uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
    return numerator / denominator;
}

}
