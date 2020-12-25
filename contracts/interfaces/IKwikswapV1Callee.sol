pragma solidity >=0.5.0;

interface IKwikswapV1Callee {
    function kwikswapV1Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
