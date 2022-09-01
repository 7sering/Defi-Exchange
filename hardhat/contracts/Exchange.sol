// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {

address public cryptoDevTokenAddress;

constructor(address _CryptoDevtoken) ERC2("CryptoDev LP Token", "CDLP"){
    require(_CryptoDevtoken != address(0), "Token Address Passed is a null address ");
    cryptoDevTokenAddress = _CryptoDevtoken;
}

}