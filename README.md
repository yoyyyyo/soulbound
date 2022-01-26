# soulbound
a simpler, "soulbound" version of ERC721/ERC1155 token implementations

## example
```solidity
pragma solidity >=0.8.0;

// SPDX-License-Identifier: CC0-1.0

import "@yoyyyyo/soulbound/SoulboundERC721.sol";

contract S721 is SoulboundERC721 {
    constructor() SoulboundERC721("Soul721", "S") {}
    
    function tokenURI(uint256 id) public view override returns (string memory) {
        return "https://...";
    }

    function mint(uint id) external {
        _mint(msg.sender, id);
    }
}

import "@yoyyyyo/soulbound/SoulboundERC1155.sol";

contract S1155 is SoulboundERC1155 {
    constructor() SoulboundERC1155() {}
    
    function uri(uint256 id) public view override returns (string memory) {
        return "https://...";
    }

    function mint(uint id) external {
        _mint(msg.sender, id, 1, "");
    }
}

```
