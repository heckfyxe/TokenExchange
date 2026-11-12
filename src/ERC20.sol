// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

error NotEnoughBalance();
error NotEnoughAllowance();
error ZeroAddressNotAllowed();

abstract contract ERC20 {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        return _transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), ZeroAddressNotAllowed());
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        if (from != msg.sender) {
            require(allowance[from][msg.sender] >= value, NotEnoughAllowance());
            allowance[from][msg.sender] -= value;
        }
        return _transfer(from, to, value);
    }

    function _transfer(address from, address to, uint256 value) private returns (bool) {
        require(to != address(0), ZeroAddressNotAllowed());
        require(balanceOf[from] >= value, NotEnoughBalance());
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
