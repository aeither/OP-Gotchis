// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface ITokenERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );
    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );
    event PlatformFeeInfoUpdated(
        address indexed platformFeeRecipient,
        uint256 platformFeeBps
    );
    event PrimarySaleRecipientUpdated(address indexed recipient);
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event TokensMinted(address indexed mintedTo, uint256 quantityMinted);
    event TokensMintedWithSignature(
        address indexed signer,
        address indexed mintedTo,
        MintRequest mintRequest
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    struct Checkpoint {
        uint32 fromBlock;
        uint224 votes;
    }

    struct MintRequest {
        address to;
        address primarySaleRecipient;
        uint256 quantity;
        uint256 price;
        address currency;
        uint128 validityStartTimestamp;
        uint128 validityEndTimestamp;
        bytes32 uid;
    }

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

    function checkpoints(address account, uint32 pos)
        external
        view
        returns (Checkpoint memory);

    function contractType() external pure returns (bytes32);

    function contractURI() external view returns (string memory);

    function contractVersion() external pure returns (uint8);

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function delegate(address delegatee) external;

    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function delegates(address account) external view returns (address);

    function getPastTotalSupply(uint256 blockNumber)
        external
        view
        returns (uint256);

    function getPastVotes(address account, uint256 blockNumber)
        external
        view
        returns (uint256);

    function getPlatformFeeInfo() external view returns (address, uint16);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function getRoleMember(bytes32 role, uint256 index)
        external
        view
        returns (address);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function getVotes(address account) external view returns (uint256);

    function grantRole(bytes32 role, address account) external;

    function hasRole(bytes32 role, address account)
        external
        view
        returns (bool);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function initialize(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        string memory _contractURI,
        address[] memory _trustedForwarders,
        address _primarySaleRecipient,
        address _platformFeeRecipient,
        uint256 _platformFeeBps
    ) external;

    function isTrustedForwarder(address forwarder) external view returns (bool);

    function mintTo(address to, uint256 amount) external;

    function mintWithSignature(MintRequest memory _req, bytes memory _signature)
        external
        payable;

    function multicall(bytes[] memory data)
        external
        returns (bytes[] memory results);

    function name() external view returns (string memory);

    function nonces(address owner) external view returns (uint256);

    function numCheckpoints(address account) external view returns (uint32);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function primarySaleRecipient() external view returns (address);

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function setContractURI(string memory _uri) external;

    function setPlatformFeeInfo(
        address _platformFeeRecipient,
        uint256 _platformFeeBps
    ) external;

    function setPrimarySaleRecipient(address _saleRecipient) external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function verify(MintRequest memory _req, bytes memory _signature)
        external
        view
        returns (bool, address);
}
