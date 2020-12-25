pragma solidity =0.5.16;

import '../KwikswapV1ERC20.sol';

contract ERC20 is KwikswapV1ERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
