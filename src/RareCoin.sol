// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import {ERC20} from "./ERC20.sol";

error SourceIsNotContract();

contract RareCoin is ERC20("RareCoin", "RARE") {
    address private immutable source;

    constructor(address _source) {
        require(_source.code.length > 0, SourceIsNotContract());
        source = _source;
    }

    function trade(uint256 amount) public {
        (bool success, bytes memory data) = source.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount)
        );
        require(success);
        require(abi.decode(data, (bool)));
        totalSupply += amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}
