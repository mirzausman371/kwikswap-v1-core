pragma solidity =0.5.16;

import './interfaces/IKwikswapV1Factory.sol';
import './KwikswapV1Pair.sol';

contract KwikswapV1Factory is IKwikswapV1Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        require(_feeToSetter != address(0));
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'KwikswapV1: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'KwikswapV1: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'KwikswapV1: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(KwikswapV1Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IKwikswapV1Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'KwikswapV1: FORBIDDEN');
        require(_feeTo != address(0), 'Address is Zero');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'KwikswapV1: FORBIDDEN');
        require(_feeToSetter != address(0), 'Address is Zero');
        feeToSetter = _feeToSetter;
    }
}
