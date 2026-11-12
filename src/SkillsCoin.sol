// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import {ERC20} from "./ERC20.sol";

contract SkillsCoin is ERC20("SkillsCoin", "SKL") {
    function mint(uint256 amount) public {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}
