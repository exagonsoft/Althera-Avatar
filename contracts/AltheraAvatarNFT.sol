// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AltheraAvatarNFT is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping(uint256 => mapping(uint8 => uint256)) private _tokenItems;

    mapping(address => uint256) private _experience;

    mapping(uint256 => string) private _nicknames;

    mapping(uint256 => string) private _avatarFilenames;

    uint8 public constant SLOT_HEAD = 0;
    uint8 public constant SLOT_NECK = 1;
    uint8 public constant SLOT_SHOULDERS = 2;
    uint8 public constant SLOT_CHEST = 3;
    uint8 public constant SLOT_BRACERS = 4;
    uint8 public constant SLOT_HANDS = 5;
    uint8 public constant SLOT_RING_1 = 6;
    uint8 public constant SLOT_RING_2 = 7;
    uint8 public constant SLOT_RING_3 = 8;
    uint8 public constant SLOT_RING_4 = 9;
    uint8 public constant SLOT_BELT = 10;
    uint8 public constant SLOT_LOWER_ARMOR = 11;
    uint8 public constant SLOT_SHOES = 12;
    uint8 public constant SLOT_WEAPON_1 = 13;
    uint8 public constant SLOT_WEAPON_2 = 14;

    constructor() ERC721("AltheraAvatar", "AAT") {
        _avatarFilenames[0] = "baseAvatar";
    }

    function claim(
        string calldata nickname,
        string calldata avatarFilename
    ) external returns (uint256) {
        require(
            balanceOf(msg.sender) == 0,
            "Only one AltheraAvatarNFT token per owner"
        );

        uint256 tokenId = 0;

        if (!_exists(tokenId)) {
            _mint(msg.sender, tokenId);

            _setExperience(msg.sender, 0);

            _setAvatarFilename(tokenId, avatarFilename);
        }

        _setNickname(tokenId, nickname);

        return tokenId;
    }

    function attachItem(uint256 tokenId, uint8 slot, uint256 itemId) external {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the token owner can attach an item"
        );
        require(_exists(tokenId), "ERC721: token does not exist");
        require(slot <= SLOT_WEAPON_2, "Invalid slot");
        require(_tokenItems[tokenId][slot] == 0, "Slot already occupied");

        _tokenItems[tokenId][slot] = itemId;
    }

    function setExperience(address owner, uint256 experience) external {
        require(
            msg.sender == ownerOf(0),
            "Only the contract owner can set the experience"
        );

        _setExperience(owner, experience);
    }

    function _setExperience(address owner, uint256 experience) private {
        _experience[owner] = experience;
    }

    function getExperience(address owner) external view returns (uint256) {
        return _experience[owner];
    }

    function setNickname(uint256 tokenId, string calldata nickname) external {
        require(tokenId == 0, "Cannot set nickname for non-zero token ID");
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the token owner can set the nickname"
        );

        _setNickname(tokenId, nickname);
    }

    function _setNickname(uint256 tokenId, string calldata nickname) private {
        _nicknames[tokenId] = nickname;
    }

    function getNickname(
        uint256 tokenId
    ) external view returns (string memory) {
        require(tokenId == 0, "Cannot get nickname for non-zero token ID");

        return _nicknames[tokenId];
    }

    function _setAvatarFilename(
        uint256 tokenId,
        string calldata avatarFilename
    ) private {
        _avatarFilenames[tokenId] = avatarFilename;
    }

    function getAvatarFilename(
        uint256 tokenId
    ) external view returns (string memory) {
        require(
            tokenId == 0,
            "Cannot get avatar filename for non-zero token ID"
        );

        return _avatarFilenames[tokenId];
    }
}
