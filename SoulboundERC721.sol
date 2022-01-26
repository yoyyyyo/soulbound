pragma solidity >=0.8.0;

// SPDX-License-Identifier: AGPL-3.0-only

// SoulboundERC721: A modified version of @Rari-Capital/solmate's ERC721 implementation
// Original source code at: https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol

abstract contract SoulboundERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    string public name;
    string public symbol;

    function tokenURI(uint256 id) public view virtual returns (string memory);

    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) public ownerOf;

    function getApproved(uint256) pure public returns (address) {
        return address(0);
    }

    function isApprovedForAll(address, address) pure public returns (bool) {
        return false;
    }

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /*
        The following functions have been replaced with the fallback function below:
        function approve(address, uint256);
        function setApprovalForAll(address, bool);
        function transferFrom(address, address, uint256);
        function safeTransferFrom(address, address, uint256);
        function safeTransferFrom(address, address, uint256, bytes memory);
    */

    fallback() external {
        revert("Token is soulbound");
    }

    function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
        return interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    function _mint(address to, uint256 id) internal virtual {
        require(to != address(0), "INVALID_RECIPIENT");
        require(ownerOf[id] == address(0), "ALREADY_MINTED");

        // Counter overflow is incredibly unrealistic.
        unchecked {
            balanceOf[to]++;
        }

        ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function _burn(uint256 id) internal virtual {
        address owner = ownerOf[id];
        require(ownerOf[id] != address(0), "NOT_MINTED");

        // Ownership check above ensures no underflow.
        unchecked {
            balanceOf[owner]--;
        }

        delete ownerOf[id];
        emit Transfer(owner, address(0), id);
    }

    function _safeMint(address to, uint256 id) internal virtual {
        _mint(to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function _safeMint(
        address to,
        uint256 id,
        bytes memory data
    ) internal virtual {
        _mint(to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }
}

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
interface ERC721TokenReceiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external returns (bytes4);
}
