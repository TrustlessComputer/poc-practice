// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// contracts/system-contracts/contracts/interfaces/IAccountCodeStorage.sol

interface IAccountCodeStorage {
    function storeAccountConstructingCodeHash(address _address, bytes32 _hash) external;

    function storeAccountConstructedCodeHash(address _address, bytes32 _hash) external;

    function markAccountCodeHashAsConstructed(address _address) external;

    function getRawCodeHash(address _address) external view returns (bytes32 codeHash);

    function getCodeHash(uint256 _input) external view returns (bytes32 codeHash);

    function getCodeSize(uint256 _input) external view returns (uint256 codeSize);
}

// contracts/system-contracts/contracts/interfaces/IComplexUpgrader.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice The interface for the ComplexUpgrader contract.
 */
interface IComplexUpgrader {
    function upgrade(address _delegateTo, bytes calldata _calldata) external payable;
}

// contracts/system-contracts/contracts/interfaces/ICompressor.sol

// The bitmask by applying which to the compressed state diff metadata we retrieve its operation.
uint8 constant OPERATION_BITMASK = 7;
// The number of bits shifting the compressed state diff metadata by which we retrieve its length.
uint8 constant LENGTH_BITS_OFFSET = 3;
// The maximal length in bytes that an enumeration index can have.
uint8 constant MAX_ENUMERATION_INDEX_SIZE = 8;

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice The interface for the Compressor contract, responsible for verifying the correctness of
 * the compression of the state diffs and bytecodes.
 */
interface ICompressor {
    function publishCompressedBytecode(
        bytes calldata _bytecode,
        bytes calldata _rawCompressedData
    ) external payable returns (bytes32 bytecodeHash);

    function verifyCompressedStateDiffs(
        uint256 _numberOfStateDiffs,
        uint256 _enumerationIndexSize,
        bytes calldata _stateDiffs,
        bytes calldata _compressedStateDiffs
    ) external payable returns (bytes32 stateDiffHash);
}

// contracts/system-contracts/contracts/interfaces/IContractDeployer.sol

interface IContractDeployer {
    /// @notice Defines the version of the account abstraction protocol
    /// that a contract claims to follow.
    /// - `None` means that the account is just a contract and it should never be interacted
    /// with as a custom account
    /// - `Version1` means that the account follows the first version of the account abstraction protocol
    enum AccountAbstractionVersion {
        None,
        Version1
    }

    /// @notice Defines the nonce ordering used by the account
    /// - `Sequential` means that it is expected that the nonces are monotonic and increment by 1
    /// at a time (the same as EOAs).
    /// - `Arbitrary` means that the nonces for the accounts can be arbitrary. The operator
    /// should serve the transactions from such an account on a first-come-first-serve basis.
    /// @dev This ordering is more of a suggestion to the operator on how the AA expects its transactions
    /// to be processed and is not considered as a system invariant.
    enum AccountNonceOrdering {
        Sequential,
        Arbitrary
    }

    struct AccountInfo {
        AccountAbstractionVersion supportedAAVersion;
        AccountNonceOrdering nonceOrdering;
    }

    event ContractDeployed(
        address indexed deployerAddress,
        bytes32 indexed bytecodeHash,
        address indexed contractAddress
    );

    event AccountNonceOrderingUpdated(address indexed accountAddress, AccountNonceOrdering nonceOrdering);

    event AccountVersionUpdated(address indexed accountAddress, AccountAbstractionVersion aaVersion);

    function getNewAddressCreate2(
        address _sender,
        bytes32 _bytecodeHash,
        bytes32 _salt,
        bytes calldata _input
    ) external view returns (address newAddress);

    function getNewAddressCreate(address _sender, uint256 _senderNonce) external pure returns (address newAddress);

    function create2(
        bytes32 _salt,
        bytes32 _bytecodeHash,
        bytes calldata _input
    ) external payable returns (address newAddress);

    function create2Account(
        bytes32 _salt,
        bytes32 _bytecodeHash,
        bytes calldata _input,
        AccountAbstractionVersion _aaVersion
    ) external payable returns (address newAddress);

    /// @dev While the `_salt` parameter is not used anywhere here,
    /// it is still needed for consistency between `create` and
    /// `create2` functions (required by the compiler).
    function create(
        bytes32 _salt,
        bytes32 _bytecodeHash,
        bytes calldata _input
    ) external payable returns (address newAddress);

    /// @dev While `_salt` is never used here, we leave it here as a parameter
    /// for the consistency with the `create` function.
    function createAccount(
        bytes32 _salt,
        bytes32 _bytecodeHash,
        bytes calldata _input,
        AccountAbstractionVersion _aaVersion
    ) external payable returns (address newAddress);

    /// @notice Returns the information about a certain AA.
    function getAccountInfo(address _address) external view returns (AccountInfo memory info);

    /// @notice Can be called by an account to update its account version
    function updateAccountVersion(AccountAbstractionVersion _version) external;

    /// @notice Can be called by an account to update its nonce ordering
    function updateNonceOrdering(AccountNonceOrdering _nonceOrdering) external;
}

// contracts/system-contracts/contracts/interfaces/IEthToken.sol

interface IEthToken {
    function balanceOf(uint256) external view returns (uint256);

    function transferFromTo(address _from, address _to, uint256 _amount) external;

    function totalSupply() external view returns (uint256);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function mint(address _account, uint256 _amount) external;

    function withdraw(address _l1Receiver) external payable;

    function withdrawWithMessage(address _l1Receiver, bytes calldata _additionalData) external payable;

    event Mint(address indexed account, uint256 amount);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Withdrawal(address indexed _l2Sender, address indexed _l1Receiver, uint256 _amount);

    event WithdrawalWithMessage(
        address indexed _l2Sender,
        address indexed _l1Receiver,
        uint256 _amount,
        bytes _additionalData
    );
}

// contracts/system-contracts/contracts/interfaces/IImmutableSimulator.sol

    struct ImmutableData {
        uint256 index;
        bytes32 value;
    }

interface IImmutableSimulator {
    function getImmutable(address _dest, uint256 _index) external view returns (bytes32);

    function setImmutables(address _dest, ImmutableData[] calldata _immutables) external;
}

// contracts/system-contracts/contracts/interfaces/IKnownCodesStorage.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice The interface for the KnownCodesStorage contract, which is responsible
 * for storing the hashes of the bytecodes that have been published to the network.
 */
interface IKnownCodesStorage {
    event MarkedAsKnown(bytes32 indexed bytecodeHash, bool indexed sendBytecodeToL1);

    function markFactoryDeps(bool _shouldSendToL1, bytes32[] calldata _hashes) external;

    function markBytecodeAsPublished(bytes32 _bytecodeHash) external;

    function getMarker(bytes32 _hash) external view returns (uint256);
}

// contracts/system-contracts/contracts/interfaces/IL1Messenger.sol

/// @dev The log passed from L2
/// @param l2ShardId The shard identifier, 0 - rollup, 1 - porter. All other values are not used but are reserved for the future
/// @param isService A boolean flag that is part of the log along with `key`, `value`, and `sender` address.
/// This field is required formally but does not have any special meaning.
/// @param txNumberInBlock The L2 transaction number in a block, in which the log was sent
/// @param sender The L2 address which sent the log
/// @param key The 32 bytes of information that was sent in the log
/// @param value The 32 bytes of information that was sent in the log
// Both `key` and `value` are arbitrary 32-bytes selected by the log sender
    struct L2ToL1Log {
        uint8 l2ShardId;
        bool isService;
        uint16 txNumberInBlock;
        address sender;
        bytes32 key;
        bytes32 value;
    }

/// @dev Bytes in raw L2 to L1 log
/// @dev Equal to the bytes size of the tuple - (uint8 ShardId, bool isService, uint16 txNumberInBlock, address sender, bytes32 key, bytes32 value)
uint256 constant L2_TO_L1_LOG_SERIALIZE_SIZE = 88;

/// @dev The value of default leaf hash for L2 to L1 logs Merkle tree
/// @dev An incomplete fixed-size tree is filled with this value to be a full binary tree
/// @dev Actually equal to the `keccak256(new bytes(L2_TO_L1_LOG_SERIALIZE_SIZE))`
bytes32 constant L2_L1_LOGS_TREE_DEFAULT_LEAF_HASH = 0x72abee45b59e344af8a6e520241c4744aff26ed411f4c4b00f8af09adada43ba;

/// @dev The current version of state diff compression being used.
uint256 constant STATE_DIFF_COMPRESSION_VERSION_NUMBER = 1;

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice The interface of the L1 Messenger contract, responsible for sending messages to L1.
 */
interface IL1Messenger {
    // Possibly in the future we will be able to track the messages sent to L1 with
    // some hooks in the VM. For now, it is much easier to track them with L2 events.
    event L1MessageSent(address indexed _sender, bytes32 indexed _hash, bytes _message);

    event L2ToL1LogSent(L2ToL1Log _l2log);

    event BytecodeL1PublicationRequested(bytes32 _bytecodeHash);

    function sendToL1(bytes memory _message) external returns (bytes32);

    function sendL2ToL1Log(bool _isService, bytes32 _key, bytes32 _value) external returns (uint256 logIdInMerkleTree);

    // This function is expected to be called only by the KnownCodesStorage system contract
    function requestBytecodeL1Publication(bytes32 _bytecodeHash) external;
}

// contracts/system-contracts/contracts/interfaces/INonceHolder.sol

/**
 * @author Matter Labs
 * @dev Interface of the nonce holder contract -- a contract used by the system to ensure
 * that there is always a unique identifier for a transaction with a particular account (we call it nonce).
 * In other words, the pair of (address, nonce) should always be unique.
 * @dev Custom accounts should use methods of this contract to store nonces or other possible unique identifiers
 * for the transaction.
 */
interface INonceHolder {
    event ValueSetUnderNonce(address indexed accountAddress, uint256 indexed key, uint256 value);

    /// @dev Returns the current minimal nonce for account.
    function getMinNonce(address _address) external view returns (uint256);

    /// @dev Returns the raw version of the current minimal nonce
    /// (equal to minNonce + 2^128 * deployment nonce).
    function getRawNonce(address _address) external view returns (uint256);

    /// @dev Increases the minimal nonce for the msg.sender.
    function increaseMinNonce(uint256 _value) external returns (uint256);

    /// @dev Sets the nonce value `key` as used.
    function setValueUnderNonce(uint256 _key, uint256 _value) external;

    /// @dev Gets the value stored inside a custom nonce.
    function getValueUnderNonce(uint256 _key) external view returns (uint256);

    /// @dev A convenience method to increment the minimal nonce if it is equal
    /// to the `_expectedNonce`.
    function incrementMinNonceIfEquals(uint256 _expectedNonce) external;

    /// @dev Returns the deployment nonce for the accounts used for CREATE opcode.
    function getDeploymentNonce(address _address) external view returns (uint256);

    /// @dev Increments the deployment nonce for the account and returns the previous one.
    function incrementDeploymentNonce(address _address) external returns (uint256);

    /// @dev Determines whether a certain nonce has been already used for an account.
    function validateNonceUsage(address _address, uint256 _key, bool _shouldBeUsed) external view;

    /// @dev Returns whether a nonce has been used for an account.
    function isNonceUsed(address _address, uint256 _nonce) external view returns (bool);
}

// contracts/system-contracts/contracts/interfaces/IPaymasterFlow.sol

/**
 * @author Matter Labs
 * @dev The interface that is used for encoding/decoding of
 * different types of paymaster flows.
 * @notice This is NOT an interface to be implementated
 * by contracts. It is just used for encoding.
 */
interface IPaymasterFlow {
    function general(bytes calldata input) external;

    function approvalBased(address _token, uint256 _minAllowance, bytes calldata _innerInput) external;
}

// contracts/system-contracts/contracts/interfaces/IPubdataChunkPublisher.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice Interface for contract responsible chunking pubdata into the appropriate size for EIP-4844 blobs.
 */
interface IPubdataChunkPublisher {
    /// @notice Chunks pubdata into pieces that can fit into blobs.
    /// @param _pubdata The total l2 to l1 pubdata that will be sent via L1 blobs.
    function chunkAndPublishPubdata(bytes calldata _pubdata) external;
}

// contracts/system-contracts/contracts/interfaces/ISystemContext.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice Contract that stores some of the context variables, that may be either
 * block-scoped, tx-scoped or system-wide.
 */
interface ISystemContext {
    struct BlockInfo {
        uint128 timestamp;
        uint128 number;
    }

    /// @notice A structure representing the timeline for the upgrade from the batch numbers to the L2 block numbers.
    /// @dev It will used for the L1 batch -> L2 block migration in Q3 2023 only.
    struct VirtualBlockUpgradeInfo {
        /// @notice In order to maintain consistent results for `blockhash` requests, we'll
        /// have to remember the number of the batch when the upgrade to the virtual blocks has been done.
        /// The hashes for virtual blocks before the upgrade are identical to the hashes of the corresponding batches.
        uint128 virtualBlockStartBatch;
        /// @notice L2 block when the virtual blocks have caught up with the L2 blocks. Starting from this block,
        /// all the information returned to users for block.timestamp/number, etc should be the information about the L2 blocks and
        /// not virtual blocks.
        uint128 virtualBlockFinishL2Block;
    }

    function chainId() external view returns (uint256);

    function origin() external view returns (address);

    function gasPrice() external view returns (uint256);

    function blockGasLimit() external view returns (uint256);

    function coinbase() external view returns (address);

    function difficulty() external view returns (uint256);

    function baseFee() external view returns (uint256);

    function txNumberInBlock() external view returns (uint16);

    function getBlockHashEVM(uint256 _block) external view returns (bytes32);

    function getBatchHash(uint256 _batchNumber) external view returns (bytes32 hash);

    function getBlockNumber() external view returns (uint128);

    function getBlockTimestamp() external view returns (uint128);

    function getBatchNumberAndTimestamp() external view returns (uint128 blockNumber, uint128 blockTimestamp);

    function getL2BlockNumberAndTimestamp() external view returns (uint128 blockNumber, uint128 blockTimestamp);
}

// contracts/system-contracts/contracts/libraries/RLPEncoder.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice This library provides RLP encoding functionality.
 */
library RLPEncoder {
    function encodeAddress(address _val) internal pure returns (bytes memory encoded) {
        // The size is equal to 20 bytes of the address itself + 1 for encoding bytes length in RLP.
        encoded = new bytes(0x15);

        bytes20 shiftedVal = bytes20(_val);
        assembly {
        // In the first byte we write the encoded length as 0x80 + 0x14 == 0x94.
            mstore(add(encoded, 0x20), 0x9400000000000000000000000000000000000000000000000000000000000000)
        // Write address data without stripping zeros.
            mstore(add(encoded, 0x21), shiftedVal)
        }
    }

    function encodeUint256(uint256 _val) internal pure returns (bytes memory encoded) {
        unchecked {
            if (_val < 128) {
                encoded = new bytes(1);
                // Handle zero as a non-value, since stripping zeroes results in an empty byte array
                encoded[0] = (_val == 0) ? bytes1(uint8(128)) : bytes1(uint8(_val));
            } else {
                uint256 hbs = _highestByteSet(_val);

                encoded = new bytes(hbs + 2);
                encoded[0] = bytes1(uint8(hbs + 0x81));

                uint256 lbs = 31 - hbs;
                uint256 shiftedVal = _val << (lbs * 8);

                assembly {
                    mstore(add(encoded, 0x21), shiftedVal)
                }
            }
        }
    }

    /// @notice Encodes the size of bytes in RLP format.
    /// @param _len The length of the bytes to encode. It has a `uint64` type since as larger values are not supported.
    /// NOTE: panics if the length is 1 since the length encoding is ambiguous in this case.
    function encodeNonSingleBytesLen(uint64 _len) internal pure returns (bytes memory) {
        assert(_len != 1);
        return _encodeLength(_len, 0x80);
    }

    /// @notice Encodes the size of list items in RLP format.
    /// @param _len The length of the bytes to encode. It has a `uint64` type since as larger values are not supported.
    function encodeListLen(uint64 _len) internal pure returns (bytes memory) {
        return _encodeLength(_len, 0xc0);
    }

    function _encodeLength(uint64 _len, uint256 _offset) private pure returns (bytes memory encoded) {
        unchecked {
            if (_len < 56) {
                encoded = new bytes(1);
                encoded[0] = bytes1(uint8(_len + _offset));
            } else {
                uint256 hbs = _highestByteSet(uint256(_len));

                encoded = new bytes(hbs + 2);
                encoded[0] = bytes1(uint8(_offset + hbs + 56));

                uint256 lbs = 31 - hbs;
                uint256 shiftedVal = uint256(_len) << (lbs * 8);

                assembly {
                    mstore(add(encoded, 0x21), shiftedVal)
                }
            }
        }
    }

    /// @notice Computes the index of the highest byte set in number.
    /// @notice Uses little endian ordering (The least significant byte has index `0`).
    /// NOTE: returns `0` for `0`
    function _highestByteSet(uint256 _number) private pure returns (uint256 hbs) {
        unchecked {
            if (_number > type(uint128).max) {
                _number >>= 128;
                hbs += 16;
            }
            if (_number > type(uint64).max) {
                _number >>= 64;
                hbs += 8;
            }
            if (_number > type(uint32).max) {
                _number >>= 32;
                hbs += 4;
            }
            if (_number > type(uint16).max) {
                _number >>= 16;
                hbs += 2;
            }
            if (_number > type(uint8).max) {
                hbs += 1;
            }
        }
    }
}

// contracts/system-contracts/contracts/openzeppelin/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// contracts/system-contracts/contracts/openzeppelin/token/ERC20/extensions/IERC20Permit.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Permit.sol)

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// contracts/system-contracts/contracts/openzeppelin/utils/Address.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
    internal
    returns (bytes memory)
    {
        return
            functionCallWithValue(
            target,
            data,
            0,
            "Address: low-level call failed"
        );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
            target,
            data,
            value,
            "Address: low-level call with value failed"
        );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
    internal
    view
    returns (bytes memory)
    {
        return
            functionStaticCall(
            target,
            data,
            "Address: low-level static call failed"
        );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
    internal
    returns (bytes memory)
    {
        return
            functionDelegateCall(
            target,
            data,
            "Address: low-level delegate call failed"
        );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage)
    private
    pure
    {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// contracts/system-contracts/contracts/openzeppelin/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(
            nonceAfter == nonceBefore + 1,
            "SafeERC20: permit did not succeed"
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

// contracts/system-contracts/contracts/Constants.sol

/// @dev All the system contracts introduced by zkSync have their addresses
/// started from 2^15 in order to avoid collision with Ethereum precompiles.
uint160 constant SYSTEM_CONTRACTS_OFFSET = 2^15; // 2^15

/// @dev All the system contracts must be located in the kernel space,
/// i.e. their addresses must be below 2^16.
uint160 constant MAX_SYSTEM_CONTRACT_ADDRESS = 0xffff; // 2^16 - 1

address constant ECRECOVER_SYSTEM_CONTRACT = address(0x01);
address constant SHA256_SYSTEM_CONTRACT = address(0x02);
address constant ECADD_SYSTEM_CONTRACT = address(0x06);
address constant ECMUL_SYSTEM_CONTRACT = address(0x07);

/// @dev The maximal possible address of an L1-like precompie. These precompiles maintain the following properties:
/// - Their extcodehash is EMPTY_STRING_KECCAK
/// - Their extcodesize is 0 despite having a bytecode formally deployed there.
uint256 constant CURRENT_MAX_PRECOMPILE_ADDRESS = 0xff;

address payable constant BOOTLOADER_FORMAL_ADDRESS = payable(address(SYSTEM_CONTRACTS_OFFSET + 0x01));
IAccountCodeStorage constant ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT = IAccountCodeStorage(
address(SYSTEM_CONTRACTS_OFFSET + 0x02)
);
INonceHolder constant NONCE_HOLDER_SYSTEM_CONTRACT = INonceHolder(address(SYSTEM_CONTRACTS_OFFSET + 0x03));
IKnownCodesStorage constant KNOWN_CODE_STORAGE_CONTRACT = IKnownCodesStorage(address(SYSTEM_CONTRACTS_OFFSET + 0x04));
IImmutableSimulator constant IMMUTABLE_SIMULATOR_SYSTEM_CONTRACT = IImmutableSimulator(
address(SYSTEM_CONTRACTS_OFFSET + 0x05)
);
IContractDeployer constant DEPLOYER_SYSTEM_CONTRACT = IContractDeployer(address(SYSTEM_CONTRACTS_OFFSET + 0x06));

// A contract that is allowed to deploy any codehash
// on any address. To be used only during an upgrade.
address constant FORCE_DEPLOYER = address(SYSTEM_CONTRACTS_OFFSET + 0x07);
IL1Messenger constant L1_MESSENGER_CONTRACT = IL1Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));
address constant MSG_VALUE_SYSTEM_CONTRACT = address(SYSTEM_CONTRACTS_OFFSET + 0x09);

IEthToken constant ETH_TOKEN_SYSTEM_CONTRACT = IEthToken(address(SYSTEM_CONTRACTS_OFFSET + 0x0a));

// Hardcoded because even for tests we should keep the address. (Instead `SYSTEM_CONTRACTS_OFFSET + 0x10`)
// Precompile call depends on it.
// And we don't want to mock this contract.
address constant KECCAK256_SYSTEM_CONTRACT = address(0x8010);

ISystemContext constant SYSTEM_CONTEXT_CONTRACT = ISystemContext(payable(address(SYSTEM_CONTRACTS_OFFSET + 0x0b)));

IBootloaderUtilities constant BOOTLOADER_UTILITIES = IBootloaderUtilities(address(SYSTEM_CONTRACTS_OFFSET + 0x0c));

// It will be a different value for tests, while shouldn't. But for now, this constant is not used by other contracts, so that's fine.
address constant EVENT_WRITER_CONTRACT = address(SYSTEM_CONTRACTS_OFFSET + 0x0d);

ICompressor constant COMPRESSOR_CONTRACT = ICompressor(address(SYSTEM_CONTRACTS_OFFSET + 0x0e));

IComplexUpgrader constant COMPLEX_UPGRADER_CONTRACT = IComplexUpgrader(address(SYSTEM_CONTRACTS_OFFSET + 0x0f));

IPubdataChunkPublisher constant PUBDATA_CHUNK_PUBLISHER = IPubdataChunkPublisher(
address(SYSTEM_CONTRACTS_OFFSET + 0x11)
);

/// @dev If the bitwise AND of the extraAbi[2] param when calling the MSG_VALUE_SIMULATOR
/// is non-zero, the call will be assumed to be a system one.
uint256 constant MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT = 1;

/// @dev The maximal msg.value that context can have
uint256 constant MAX_MSG_VALUE = 2 ** 128 - 1;

/// @dev Prefix used during derivation of account addresses using CREATE2
/// @dev keccak256("zksyncCreate2")
bytes32 constant CREATE2_PREFIX = 0x2020dba91b30cc0006188af794c2fb30dd8520db7e2c088b7fc7c103c00ca494;
/// @dev Prefix used during derivation of account addresses using CREATE
/// @dev keccak256("zksyncCreate")
bytes32 constant CREATE_PREFIX = 0x63bae3a9951d38e8a3fbb7b70909afc1200610fc5bc55ade242f815974674f23;

/// @dev Each state diff consists of 156 bytes of actual data and 116 bytes of unused padding, needed for circuit efficiency.
uint256 constant STATE_DIFF_ENTRY_SIZE = 272;

/// @dev While the "real" amount of pubdata that can be sent rarely exceeds the BLOB_SIZE_BYTES * MAX_NUMBER_OF_BLOBS, it is better to
/// allow the operator to provide any reasonably large value in order to avoid unneeded constraints on the operator.
uint256 constant MAX_ALLOWED_PUBDATA_PER_BATCH = 520000;

enum SystemLogKey {
L2_TO_L1_LOGS_TREE_ROOT_KEY,
TOTAL_L2_TO_L1_PUBDATA_KEY,
STATE_DIFF_HASH_KEY,
PACKED_BATCH_AND_L2_BLOCK_TIMESTAMP_KEY,
PREV_BATCH_HASH_KEY,
CHAINED_PRIORITY_TXN_HASH_KEY,
NUMBER_OF_LAYER_1_TXS_KEY,
BLOB_ONE_HASH_KEY,
BLOB_TWO_HASH_KEY,
EXPECTED_SYSTEM_CONTRACT_UPGRADE_TX_HASH_KEY
}

/// @dev The number of leaves in the L2->L1 log Merkle tree.
/// While formally a tree of any length is acceptable, the node supports only a constant length of 4096 leaves.
uint256 constant L2_TO_L1_LOGS_MERKLE_TREE_LEAVES = 4096;

/// @dev The length of the derived key in bytes inside compressed state diffs.
uint256 constant DERIVED_KEY_LENGTH = 32;
/// @dev The length of the enum index in bytes inside compressed state diffs.
uint256 constant ENUM_INDEX_LENGTH = 8;
/// @dev The length of value in bytes inside compressed state diffs.
uint256 constant VALUE_LENGTH = 32;

/// @dev The length of the compressed initial storage write in bytes.
uint256 constant COMPRESSED_INITIAL_WRITE_SIZE = DERIVED_KEY_LENGTH + VALUE_LENGTH;
/// @dev The length of the compressed repeated storage write in bytes.
uint256 constant COMPRESSED_REPEATED_WRITE_SIZE = ENUM_INDEX_LENGTH + VALUE_LENGTH;

/// @dev The position from which the initial writes start in the compressed state diffs.
uint256 constant INITIAL_WRITE_STARTING_POSITION = 4;

/// @dev Each storage diffs consists of the following elements:
/// [20bytes address][32bytes key][32bytes derived key][8bytes enum index][32bytes initial value][32bytes final value]
/// @dev The offset of the deriived key in a storage diff.
uint256 constant STATE_DIFF_DERIVED_KEY_OFFSET = 52;
/// @dev The offset of the enum index in a storage diff.
uint256 constant STATE_DIFF_ENUM_INDEX_OFFSET = 84;
/// @dev The offset of the final value in a storage diff.
uint256 constant STATE_DIFF_FINAL_VALUE_OFFSET = 124;

/// @dev Total number of bytes in a blob. Blob = 4096 field elements * 31 bytes per field element
/// @dev EIP-4844 defines it as 131_072 but we use 4096 * 31 within our circuits to always fit within a field element
/// @dev Our circuits will prove that a EIP-4844 blob and our internal blob are the same.
uint256 constant BLOB_SIZE_BYTES = 126_976;

/// @dev Max number of blobs currently supported
uint256 constant MAX_NUMBER_OF_BLOBS = 2;

// contracts/system-contracts/contracts/interfaces/IBootloaderUtilities.sol

interface IBootloaderUtilities {
function getTransactionHashes(
Transaction calldata _transaction
) external view returns (bytes32 txHash, bytes32 signedTxHash);
}

// contracts/system-contracts/contracts/libraries/EfficientCall.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice This library is used to perform ultra-efficient calls using zkEVM-specific features.
 * @dev EVM calls always accept a memory slice as input and return a memory slice as output.
 * Therefore, even if the user has a ready-made calldata slice, they still need to copy it to memory
 * before calling. This is especially inefficient for large inputs (proxies, multi-calls, etc.).
 * In turn, zkEVM operates over a fat pointer, which is a set of (memory page, offset, start, length) in the memory/calldata/returndata.
 * This allows forwarding the calldata slice as is, without copying it to memory.
 * @dev Fat pointer is not just an integer, it is an extended data type supported on the VM level.
 * zkEVM creates the wellformed fat pointers for all the calldata/returndata regions, later
 * the contract may manipulate the already created fat pointers to forward a slice of the data, but not
 * to create new fat pointers!
 * @dev The allowed operation on fat pointers are:
 * 1. `ptr.add` - Transforms `ptr.offset` into `ptr.offset + u32(_value)`. If overflow happens then it panics.
 * 2. `ptr.sub` - Transforms `ptr.offset` into `ptr.offset - u32(_value)`. If underflow happens then it panics.
 * 3. `ptr.pack` - Do the concatenation between the lowest 128 bits of the pointer itself and the highest 128 bits of `_value`. It is typically used to prepare the ABI for external calls.
 * 4. `ptr.shrink` - Transforms `ptr.length` into `ptr.length - u32(_shrink)`. If underflow happens then it panics.
 * @dev The call opcodes accept the fat pointer and change it to its canonical form before passing it to the child call
 * 1. `ptr.start` is transformed into `ptr.offset + ptr.start`
 * 2. `ptr.length` is transformed into `ptr.length - ptr.offset`
 * 3. `ptr.offset` is transformed into `0`
 */
library EfficientCall {
/// @notice Call the `keccak256` without copying calldata to memory.
/// @param _data The preimage data.
/// @return The `keccak256` hash.
function keccak(bytes calldata _data) internal view returns (bytes32) {
bytes memory returnData = staticCall(gasleft(), KECCAK256_SYSTEM_CONTRACT, _data);
require(returnData.length == 32, "keccak256 returned invalid data");
return bytes32(returnData);
}

/// @notice Call the `sha256` precompile without copying calldata to memory.
/// @param _data The preimage data.
/// @return The `sha256` hash.
function sha(bytes calldata _data) internal view returns (bytes32) {
bytes memory returnData = staticCall(gasleft(), SHA256_SYSTEM_CONTRACT, _data);
require(returnData.length == 32, "sha returned invalid data");
return bytes32(returnData);
}

/// @notice Perform a `call` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _value The `msg.value` to send.
/// @param _data The calldata to use for the call.
/// @param _isSystem Whether the call should contain the `isSystem` flag.
/// @return returnData The copied to memory return data.
function call(
uint256 _gas,
address _address,
uint256 _value,
bytes calldata _data,
bool _isSystem
) internal returns (bytes memory returnData) {
bool success = rawCall(_gas, _address, _value, _data, _isSystem);
returnData = _verifyCallResult(success);
}

/// @notice Perform a `staticCall` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @return returnData The copied to memory return data.
function staticCall(
uint256 _gas,
address _address,
bytes calldata _data
) internal view returns (bytes memory returnData) {
bool success = rawStaticCall(_gas, _address, _data);
returnData = _verifyCallResult(success);
}

/// @notice Perform a `delegateCall` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @return returnData The copied to memory return data.
function delegateCall(
uint256 _gas,
address _address,
bytes calldata _data
) internal returns (bytes memory returnData) {
bool success = rawDelegateCall(_gas, _address, _data);
returnData = _verifyCallResult(success);
}

/// @notice Perform a `mimicCall` (a call with custom msg.sender) without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @param _whoToMimic The `msg.sender` for the next call.
/// @param _isConstructor Whether the call should contain the `isConstructor` flag.
/// @param _isSystem Whether the call should contain the `isSystem` flag.
/// @return returnData The copied to memory return data.
function mimicCall(
uint256 _gas,
address _address,
bytes calldata _data,
address _whoToMimic,
bool _isConstructor,
bool _isSystem
) internal returns (bytes memory returnData) {
bool success = rawMimicCall(_gas, _address, _data, _whoToMimic, _isConstructor, _isSystem);
returnData = _verifyCallResult(success);
}

/// @notice Perform a `call` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _value The `msg.value` to send.
/// @param _data The calldata to use for the call.
/// @param _isSystem Whether the call should contain the `isSystem` flag.
/// @return success whether the call was successful.
function rawCall(
uint256 _gas,
address _address,
uint256 _value,
bytes calldata _data,
bool _isSystem
) internal returns (bool success) {
if (_value == 0) {
_loadFarCallABIIntoActivePtr(_gas, _data, false, _isSystem);

address callAddr = RAW_FAR_CALL_BY_REF_CALL_ADDRESS;
assembly {
success := call(_address, callAddr, 0, 0, 0xFFFF, 0, 0)
}
} else {
_loadFarCallABIIntoActivePtr(_gas, _data, false, true);

// If there is provided `msg.value` call the `MsgValueSimulator` to forward ether.
address msgValueSimulator = MSG_VALUE_SYSTEM_CONTRACT;
address callAddr = SYSTEM_CALL_BY_REF_CALL_ADDRESS;
// We need to supply the mask to the MsgValueSimulator to denote
// that the call should be a system one.
uint256 forwardMask = _isSystem ? MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT : 0;

assembly {
success := call(msgValueSimulator, callAddr, _value, _address, 0xFFFF, forwardMask, 0)
}
}
}

/// @notice Perform a `staticCall` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @return success whether the call was successful.
function rawStaticCall(uint256 _gas, address _address, bytes calldata _data) internal view returns (bool success) {
_loadFarCallABIIntoActivePtr(_gas, _data, false, false);

address callAddr = RAW_FAR_CALL_BY_REF_CALL_ADDRESS;
assembly {
success := staticcall(_address, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Perform a `delegatecall` without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @return success whether the call was successful.
function rawDelegateCall(uint256 _gas, address _address, bytes calldata _data) internal returns (bool success) {
_loadFarCallABIIntoActivePtr(_gas, _data, false, false);

address callAddr = RAW_FAR_CALL_BY_REF_CALL_ADDRESS;
assembly {
success := delegatecall(_address, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Perform a `mimicCall` (call with custom msg.sender) without copying calldata to memory.
/// @param _gas The gas to use for the call.
/// @param _address The address to call.
/// @param _data The calldata to use for the call.
/// @param _whoToMimic The `msg.sender` for the next call.
/// @param _isConstructor Whether the call should contain the `isConstructor` flag.
/// @param _isSystem Whether the call should contain the `isSystem` flag.
/// @return success whether the call was successful.
/// @dev If called not in kernel mode, it will result in a revert (enforced by the VM)
function rawMimicCall(
uint256 _gas,
address _address,
bytes calldata _data,
address _whoToMimic,
bool _isConstructor,
bool _isSystem
) internal returns (bool success) {
_loadFarCallABIIntoActivePtr(_gas, _data, _isConstructor, _isSystem);

address callAddr = MIMIC_CALL_BY_REF_CALL_ADDRESS;
uint256 cleanupMask = ADDRESS_MASK;
assembly {
// Clearing values before usage in assembly, since Solidity
// doesn't do it by default
_whoToMimic := and(_whoToMimic, cleanupMask)

success := call(_address, callAddr, 0, 0, _whoToMimic, 0, 0)
}
}

/// @dev Verify that a low-level call was successful, and revert if it wasn't, by bubbling the revert reason.
/// @param _success Whether the call was successful.
/// @return returnData The copied to memory return data.
function _verifyCallResult(bool _success) private pure returns (bytes memory returnData) {
if (_success) {
uint256 size;
assembly {
size := returndatasize()
}

returnData = new bytes(size);
assembly {
returndatacopy(add(returnData, 0x20), 0, size)
}
} else {
propagateRevert();
}
}

/// @dev Propagate the revert reason from the current call to the caller.
function propagateRevert() internal pure {
assembly {
let size := returndatasize()
returndatacopy(0, 0, size)
revert(0, size)
}
}

/// @dev Load the far call ABI into active ptr, that will be used for the next call by reference.
/// @param _gas The gas to be passed to the call.
/// @param _data The calldata to be passed to the call.
/// @param _isConstructor Whether the call is a constructor call.
/// @param _isSystem Whether the call is a system call.
function _loadFarCallABIIntoActivePtr(
uint256 _gas,
bytes calldata _data,
bool _isConstructor,
bool _isSystem
) private view {
SystemContractHelper.loadCalldataIntoActivePtr();

uint256 dataOffset;
assembly {
dataOffset := _data.offset
}

// Safe to cast, offset is never bigger than `type(uint32).max`
SystemContractHelper.ptrAddIntoActive(uint32(dataOffset));
// Safe to cast, `data.length` is never bigger than `type(uint32).max`
uint32 shrinkTo = uint32(msg.data.length - (_data.length + dataOffset));
SystemContractHelper.ptrShrinkIntoActive(shrinkTo);

uint32 gas = Utils.safeCastToU32(_gas);
uint256 farCallAbi = SystemContractsCaller.getFarCallABIWithEmptyFatPointer(
gas,
// Only rollup is supported for now
0,
CalldataForwardingMode.ForwardFatPointer,
_isConstructor,
_isSystem
);
SystemContractHelper.ptrPackIntoActivePtr(farCallAbi);
}
}

// contracts/system-contracts/contracts/libraries/SystemContractHelper.sol

uint256 constant UINT32_MASK = 0xffffffff;
uint256 constant UINT128_MASK = 0xffffffffffffffffffffffffffffffff;
/// @dev The mask that is used to convert any uint256 to a proper address.
/// It needs to be padded with `00` to be treated as uint256 by Solidity
uint256 constant ADDRESS_MASK = 0x00ffffffffffffffffffffffffffffffffffffffff;

struct ZkSyncMeta {
uint32 gasPerPubdataByte;
uint32 heapSize;
uint32 auxHeapSize;
uint8 shardId;
uint8 callerShardId;
uint8 codeShardId;
}

enum Global {
CalldataPtr,
CallFlags,
ExtraABIData1,
ExtraABIData2,
ReturndataPtr
}

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice Library used for accessing zkEVM-specific opcodes, needed for the development
 * of system contracts.
 * @dev While this library will be eventually available to public, some of the provided
 * methods won't work for non-system contracts. We will not recommend this library
 * for external use.
 */
library SystemContractHelper {
/// @notice Send an L2Log to L1.
/// @param _isService The `isService` flag.
/// @param _key The `key` part of the L2Log.
/// @param _value The `value` part of the L2Log.
/// @dev The meaning of all these parameters is context-dependent, but they
/// have no intrinsic meaning per se.
function toL1(bool _isService, bytes32 _key, bytes32 _value) internal {
address callAddr = TO_L1_CALL_ADDRESS;
assembly {
// Ensuring that the type is bool
_isService := and(_isService, 1)
// This `success` is always 0, but the method always succeeds
// (except for the cases when there is not enough gas)
let success := call(_isService, callAddr, _key, _value, 0xFFFF, 0, 0)
}
}

/// @notice Get address of the currently executed code.
/// @dev This allows differentiating between `call` and `delegatecall`.
/// During the former `this` and `codeAddress` are the same, while
/// during the latter they are not.
function getCodeAddress() internal view returns (address addr) {
address callAddr = CODE_ADDRESS_CALL_ADDRESS;
assembly {
addr := staticcall(0, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Provide a compiler hint, by placing calldata fat pointer into virtual `ACTIVE_PTR`,
/// that can be manipulated by `ptr.add`/`ptr.sub`/`ptr.pack`/`ptr.shrink` later.
/// @dev This allows making a call by forwarding calldata pointer to the child call.
/// It is a much more efficient way to forward calldata, than standard EVM bytes copying.
function loadCalldataIntoActivePtr() internal view {
address callAddr = LOAD_CALLDATA_INTO_ACTIVE_PTR_CALL_ADDRESS;
assembly {
pop(staticcall(0, callAddr, 0, 0xFFFF, 0, 0))
}
}

/// @notice Compiler simulation of the `ptr.pack` opcode for the virtual `ACTIVE_PTR` pointer.
/// @dev Do the concatenation between lowest part of `ACTIVE_PTR` and highest part of `_farCallAbi`
/// forming packed fat pointer for a far call or ret ABI when necessary.
/// Note: Panics if the lowest 128 bits of `_farCallAbi` are not zeroes.
function ptrPackIntoActivePtr(uint256 _farCallAbi) internal view {
address callAddr = PTR_PACK_INTO_ACTIVE_CALL_ADDRESS;
assembly {
pop(staticcall(_farCallAbi, callAddr, 0, 0xFFFF, 0, 0))
}
}

/// @notice Compiler simulation of the `ptr.add` opcode for the virtual `ACTIVE_PTR` pointer.
/// @dev Transforms `ACTIVE_PTR.offset` into `ACTIVE_PTR.offset + u32(_value)`. If overflow happens then it panics.
function ptrAddIntoActive(uint32 _value) internal view {
address callAddr = PTR_ADD_INTO_ACTIVE_CALL_ADDRESS;
uint256 cleanupMask = UINT32_MASK;
assembly {
// Clearing input params as they are not cleaned by Solidity by default
_value := and(_value, cleanupMask)
pop(staticcall(_value, callAddr, 0, 0xFFFF, 0, 0))
}
}

/// @notice Compiler simulation of the `ptr.shrink` opcode for the virtual `ACTIVE_PTR` pointer.
/// @dev Transforms `ACTIVE_PTR.length` into `ACTIVE_PTR.length - u32(_shrink)`. If underflow happens then it panics.
function ptrShrinkIntoActive(uint32 _shrink) internal view {
address callAddr = PTR_SHRINK_INTO_ACTIVE_CALL_ADDRESS;
uint256 cleanupMask = UINT32_MASK;
assembly {
// Clearing input params as they are not cleaned by Solidity by default
_shrink := and(_shrink, cleanupMask)
pop(staticcall(_shrink, callAddr, 0, 0xFFFF, 0, 0))
}
}

/// @notice packs precompile parameters into one word
/// @param _inputMemoryOffset The memory offset in 32-byte words for the input data for calling the precompile.
/// @param _inputMemoryLength The length of the input data in words.
/// @param _outputMemoryOffset The memory offset in 32-byte words for the output data.
/// @param _outputMemoryLength The length of the output data in words.
/// @param _perPrecompileInterpreted The constant, the meaning of which is defined separately for
/// each precompile. For information, please read the documentation of the precompilecall log in
/// the VM.
function packPrecompileParams(
uint32 _inputMemoryOffset,
uint32 _inputMemoryLength,
uint32 _outputMemoryOffset,
uint32 _outputMemoryLength,
uint64 _perPrecompileInterpreted
) internal pure returns (uint256 rawParams) {
rawParams = _inputMemoryOffset;
rawParams |= uint256(_inputMemoryLength) << 32;
rawParams |= uint256(_outputMemoryOffset) << 64;
rawParams |= uint256(_outputMemoryLength) << 96;
rawParams |= uint256(_perPrecompileInterpreted) << 192;
}

/// @notice Call precompile with given parameters.
/// @param _rawParams The packed precompile params. They can be retrieved by
/// the `packPrecompileParams` method.
/// @param _gasToBurn The number of gas to burn during this call.
/// @return success Whether the call was successful.
/// @dev The list of currently available precompiles sha256, keccak256, ecrecover.
/// NOTE: The precompile type depends on `this` which calls precompile, which means that only
/// system contracts corresponding to the list of precompiles above can do `precompileCall`.
/// @dev If used not in the `sha256`, `keccak256` or `ecrecover` contracts, it will just burn the gas provided.
/// @dev This method is `unsafe` because it does not check whether there is enough gas to burn.
function unsafePrecompileCall(uint256 _rawParams, uint32 _gasToBurn) internal view returns (bool success) {
address callAddr = PRECOMPILE_CALL_ADDRESS;

uint256 cleanupMask = UINT32_MASK;
assembly {
// Clearing input params as they are not cleaned by Solidity by default
_gasToBurn := and(_gasToBurn, cleanupMask)
success := staticcall(_rawParams, callAddr, _gasToBurn, 0xFFFF, 0, 0)
}
}

/// @notice Set `msg.value` to next far call.
/// @param _value The msg.value that will be used for the *next* call.
/// @dev If called not in kernel mode, it will result in a revert (enforced by the VM)
function setValueForNextFarCall(uint128 _value) internal returns (bool success) {
uint256 cleanupMask = UINT128_MASK;
address callAddr = SET_CONTEXT_VALUE_CALL_ADDRESS;
assembly {
// Clearing input params as they are not cleaned by Solidity by default
_value := and(_value, cleanupMask)
success := call(0, callAddr, _value, 0, 0xFFFF, 0, 0)
}
}

/// @notice Initialize a new event.
/// @param initializer The event initializing value.
/// @param value1 The first topic or data chunk.
function eventInitialize(uint256 initializer, uint256 value1) internal {
address callAddr = EVENT_INITIALIZE_ADDRESS;
assembly {
pop(call(initializer, callAddr, value1, 0, 0xFFFF, 0, 0))
}
}

/// @notice Continue writing the previously initialized event.
/// @param value1 The first topic or data chunk.
/// @param value2 The second topic or data chunk.
function eventWrite(uint256 value1, uint256 value2) internal {
address callAddr = EVENT_WRITE_ADDRESS;
assembly {
pop(call(value1, callAddr, value2, 0, 0xFFFF, 0, 0))
}
}

/// @notice Get the packed representation of the `ZkSyncMeta` from the current context.
/// @return meta The packed representation of the ZkSyncMeta.
/// @dev The fields in ZkSyncMeta are NOT tightly packed, i.e. there is a special rule on how
/// they are packed. For more information, please read the documentation on ZkSyncMeta.
function getZkSyncMetaBytes() internal view returns (uint256 meta) {
address callAddr = META_CALL_ADDRESS;
assembly {
meta := staticcall(0, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Returns the bits [offset..offset+size-1] of the meta.
/// @param meta Packed representation of the ZkSyncMeta.
/// @param offset The offset of the bits.
/// @param size The size of the extracted number in bits.
/// @return result The extracted number.
function extractNumberFromMeta(uint256 meta, uint256 offset, uint256 size) internal pure returns (uint256 result) {
// Firstly, we delete all the bits after the field
uint256 shifted = (meta << (256 - size - offset));
// Then we shift everything back
result = (shifted >> (256 - size));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the number of gas
/// that a single byte sent to L1 as pubdata costs.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return gasPerPubdataByte The current price in gas per pubdata byte.
function getGasPerPubdataByteFromMeta(uint256 meta) internal pure returns (uint32 gasPerPubdataByte) {
gasPerPubdataByte = uint32(extractNumberFromMeta(meta, META_GAS_PER_PUBDATA_BYTE_OFFSET, 32));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the number of the current size
/// of the heap in bytes.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return heapSize The size of the memory in bytes byte.
/// @dev The following expression: getHeapSizeFromMeta(getZkSyncMetaBytes()) is
/// equivalent to the MSIZE in Solidity.
function getHeapSizeFromMeta(uint256 meta) internal pure returns (uint32 heapSize) {
heapSize = uint32(extractNumberFromMeta(meta, META_HEAP_SIZE_OFFSET, 32));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the number of the current size
/// of the auxilary heap in bytes.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return auxHeapSize The size of the auxilary memory in bytes byte.
/// @dev You can read more on auxilary memory in the VM1.2 documentation.
function getAuxHeapSizeFromMeta(uint256 meta) internal pure returns (uint32 auxHeapSize) {
auxHeapSize = uint32(extractNumberFromMeta(meta, META_AUX_HEAP_SIZE_OFFSET, 32));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the shardId of `this`.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return shardId The shardId of `this`.
/// @dev Currently only shard 0 (zkRollup) is supported.
function getShardIdFromMeta(uint256 meta) internal pure returns (uint8 shardId) {
shardId = uint8(extractNumberFromMeta(meta, META_SHARD_ID_OFFSET, 8));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the shardId of
/// the msg.sender.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return callerShardId The shardId of the msg.sender.
/// @dev Currently only shard 0 (zkRollup) is supported.
function getCallerShardIdFromMeta(uint256 meta) internal pure returns (uint8 callerShardId) {
callerShardId = uint8(extractNumberFromMeta(meta, META_CALLER_SHARD_ID_OFFSET, 8));
}

/// @notice Given the packed representation of `ZkSyncMeta`, retrieves the shardId of
/// the currently executed code.
/// @param meta Packed representation of the ZkSyncMeta.
/// @return codeShardId The shardId of the currently executed code.
/// @dev Currently only shard 0 (zkRollup) is supported.
function getCodeShardIdFromMeta(uint256 meta) internal pure returns (uint8 codeShardId) {
codeShardId = uint8(extractNumberFromMeta(meta, META_CODE_SHARD_ID_OFFSET, 8));
}

/// @notice Retrieves the ZkSyncMeta structure.
/// @return meta The ZkSyncMeta execution context parameters.
function getZkSyncMeta() internal view returns (ZkSyncMeta memory meta) {
uint256 metaPacked = getZkSyncMetaBytes();
meta.gasPerPubdataByte = getGasPerPubdataByteFromMeta(metaPacked);
meta.heapSize = getHeapSizeFromMeta(metaPacked);
meta.auxHeapSize = getAuxHeapSizeFromMeta(metaPacked);
meta.shardId = getShardIdFromMeta(metaPacked);
meta.callerShardId = getCallerShardIdFromMeta(metaPacked);
meta.codeShardId = getCodeShardIdFromMeta(metaPacked);
}

/// @notice Returns the call flags for the current call.
/// @return callFlags The bitmask of the callflags.
/// @dev Call flags is the value of the first register
/// at the start of the call.
/// @dev The zero bit of the callFlags indicates whether the call is
/// a constructor call. The first bit of the callFlags indicates whether
/// the call is a system one.
function getCallFlags() internal view returns (uint256 callFlags) {
address callAddr = CALLFLAGS_CALL_ADDRESS;
assembly {
callFlags := staticcall(0, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Returns the current calldata pointer.
/// @return ptr The current calldata pointer.
/// @dev NOTE: This file is just an integer and it cannot be used
/// to forward the calldata to the next calls in any way.
function getCalldataPtr() internal view returns (uint256 ptr) {
address callAddr = PTR_CALLDATA_CALL_ADDRESS;
assembly {
ptr := staticcall(0, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Returns the N-th extraAbiParam for the current call.
/// @return extraAbiData The value of the N-th extraAbiParam for this call.
/// @dev It is equal to the value of the (N+2)-th register
/// at the start of the call.
function getExtraAbiData(uint256 index) internal view returns (uint256 extraAbiData) {
require(index < 10, "There are only 10 accessible registers");

address callAddr = GET_EXTRA_ABI_DATA_ADDRESS;
assembly {
extraAbiData := staticcall(index, callAddr, 0, 0xFFFF, 0, 0)
}
}

/// @notice Retuns whether the current call is a system call.
/// @return `true` or `false` based on whether the current call is a system call.
function isSystemCall() internal view returns (bool) {
uint256 callFlags = getCallFlags();
// When the system call is passed, the 2-bit it set to 1
return (callFlags & 2) != 0;
}

/// @notice Returns whether the address is a system contract.
/// @param _address The address to test
/// @return `true` or `false` based on whether the `_address` is a system contract.
function isSystemContract(address _address) internal pure returns (bool) {
return uint160(_address) <= uint160(MAX_SYSTEM_CONTRACT_ADDRESS);
}

/// @notice Method used for burning a certain amount of gas.
/// @param _gasToPay The number of gas to burn.
function burnGas(uint32 _gasToPay) internal view {
bool precompileCallSuccess = unsafePrecompileCall(
0, // The precompile parameters are formal ones. We only need the precompile call to burn gas.
_gasToPay
);
require(precompileCallSuccess, "Failed to charge gas");
}
}

// contracts/system-contracts/contracts/libraries/SystemContractsCaller.sol

// Addresses used for the compiler to be replaced with the
// zkSync-specific opcodes during the compilation.
// IMPORTANT: these are just compile-time constants and are used
// only if used in-place by Yul optimizer.
address constant TO_L1_CALL_ADDRESS = address((1 << 16) - 1);
address constant CODE_ADDRESS_CALL_ADDRESS = address((1 << 16) - 2);
address constant PRECOMPILE_CALL_ADDRESS = address((1 << 16) - 3);
address constant META_CALL_ADDRESS = address((1 << 16) - 4);
address constant MIMIC_CALL_CALL_ADDRESS = address((1 << 16) - 5);
address constant SYSTEM_MIMIC_CALL_CALL_ADDRESS = address((1 << 16) - 6);
address constant MIMIC_CALL_BY_REF_CALL_ADDRESS = address((1 << 16) - 7);
address constant SYSTEM_MIMIC_CALL_BY_REF_CALL_ADDRESS = address((1 << 16) - 8);
address constant RAW_FAR_CALL_CALL_ADDRESS = address((1 << 16) - 9);
address constant RAW_FAR_CALL_BY_REF_CALL_ADDRESS = address((1 << 16) - 10);
address constant SYSTEM_CALL_CALL_ADDRESS = address((1 << 16) - 11);
address constant SYSTEM_CALL_BY_REF_CALL_ADDRESS = address((1 << 16) - 12);
address constant SET_CONTEXT_VALUE_CALL_ADDRESS = address((1 << 16) - 13);
address constant SET_PUBDATA_PRICE_CALL_ADDRESS = address((1 << 16) - 14);
address constant INCREMENT_TX_COUNTER_CALL_ADDRESS = address((1 << 16) - 15);
address constant PTR_CALLDATA_CALL_ADDRESS = address((1 << 16) - 16);
address constant CALLFLAGS_CALL_ADDRESS = address((1 << 16) - 17);
address constant PTR_RETURNDATA_CALL_ADDRESS = address((1 << 16) - 18);
address constant EVENT_INITIALIZE_ADDRESS = address((1 << 16) - 19);
address constant EVENT_WRITE_ADDRESS = address((1 << 16) - 20);
address constant LOAD_CALLDATA_INTO_ACTIVE_PTR_CALL_ADDRESS = address((1 << 16) - 21);
address constant LOAD_LATEST_RETURNDATA_INTO_ACTIVE_PTR_CALL_ADDRESS = address((1 << 16) - 22);
address constant PTR_ADD_INTO_ACTIVE_CALL_ADDRESS = address((1 << 16) - 23);
address constant PTR_SHRINK_INTO_ACTIVE_CALL_ADDRESS = address((1 << 16) - 24);
address constant PTR_PACK_INTO_ACTIVE_CALL_ADDRESS = address((1 << 16) - 25);
address constant MULTIPLICATION_HIGH_ADDRESS = address((1 << 16) - 26);
address constant GET_EXTRA_ABI_DATA_ADDRESS = address((1 << 16) - 27);

// All the offsets are in bits
uint256 constant META_GAS_PER_PUBDATA_BYTE_OFFSET = 0 * 8;
uint256 constant META_HEAP_SIZE_OFFSET = 8 * 8;
uint256 constant META_AUX_HEAP_SIZE_OFFSET = 12 * 8;
uint256 constant META_SHARD_ID_OFFSET = 28 * 8;
uint256 constant META_CALLER_SHARD_ID_OFFSET = 29 * 8;
uint256 constant META_CODE_SHARD_ID_OFFSET = 30 * 8;

/// @notice The way to forward the calldata:
/// - Use the current heap (i.e. the same as on EVM).
/// - Use the auxiliary heap.
/// - Forward via a pointer
/// @dev Note, that currently, users do not have access to the auxiliary
/// heap and so the only type of forwarding that will be used by the users
/// are UseHeap and ForwardFatPointer for forwarding a slice of the current calldata
/// to the next call.
enum CalldataForwardingMode {
UseHeap,
ForwardFatPointer,
UseAuxHeap
}

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice A library that allows calling contracts with the `isSystem` flag.
 * @dev It is needed to call ContractDeployer and NonceHolder.
 */
library SystemContractsCaller {
/// @notice Makes a call with the `isSystem` flag.
/// @param gasLimit The gas limit for the call.
/// @param to The address to call.
/// @param value The value to pass with the transaction.
/// @param data The calldata.
/// @return success Whether the transaction has been successful.
/// @dev Note, that the `isSystem` flag can only be set when calling system contracts.
function systemCall(uint32 gasLimit, address to, uint256 value, bytes memory data) internal returns (bool success) {
address callAddr = SYSTEM_CALL_CALL_ADDRESS;

uint32 dataStart;
assembly {
dataStart := add(data, 0x20)
}
uint32 dataLength = uint32(Utils.safeCastToU32(data.length));

uint256 farCallAbi = SystemContractsCaller.getFarCallABI(
0,
0,
dataStart,
dataLength,
gasLimit,
// Only rollup is supported for now
0,
CalldataForwardingMode.UseHeap,
false,
true
);

if (value == 0) {
// Doing the system call directly
assembly {
success := call(to, callAddr, 0, 0, farCallAbi, 0, 0)
}
} else {
address msgValueSimulator = MSG_VALUE_SYSTEM_CONTRACT;
// We need to supply the mask to the MsgValueSimulator to denote
// that the call should be a system one.
uint256 forwardMask = MSG_VALUE_SIMULATOR_IS_SYSTEM_BIT;

assembly {
success := call(msgValueSimulator, callAddr, value, to, farCallAbi, forwardMask, 0)
}
}
}

/// @notice Makes a call with the `isSystem` flag.
/// @param gasLimit The gas limit for the call.
/// @param to The address to call.
/// @param value The value to pass with the transaction.
/// @param data The calldata.
/// @return success Whether the transaction has been successful.
/// @return returnData The returndata of the transaction (revert reason in case the transaction has failed).
/// @dev Note, that the `isSystem` flag can only be set when calling system contracts.
function systemCallWithReturndata(
uint32 gasLimit,
address to,
uint128 value,
bytes memory data
) internal returns (bool success, bytes memory returnData) {
success = systemCall(gasLimit, to, value, data);

uint256 size;
assembly {
size := returndatasize()
}

returnData = new bytes(size);
assembly {
returndatacopy(add(returnData, 0x20), 0, size)
}
}

/// @notice Makes a call with the `isSystem` flag.
/// @param gasLimit The gas limit for the call.
/// @param to The address to call.
/// @param value The value to pass with the transaction.
/// @param data The calldata.
/// @return returnData The returndata of the transaction. In case the transaction reverts, the error
/// bubbles up to the parent frame.
/// @dev Note, that the `isSystem` flag can only be set when calling system contracts.
function systemCallWithPropagatedRevert(
uint32 gasLimit,
address to,
uint128 value,
bytes memory data
) internal returns (bytes memory returnData) {
bool success;
(success, returnData) = systemCallWithReturndata(gasLimit, to, value, data);

if (!success) {
assembly {
let size := mload(returnData)
revert(add(returnData, 0x20), size)
}
}
}

/// @notice Calculates the packed representation of the FarCallABI.
/// @param dataOffset Calldata offset in memory. Provide 0 unless using custom pointer.
/// @param memoryPage Memory page to use. Provide 0 unless using custom pointer.
/// @param dataStart The start of the calldata slice. Provide the offset in memory
/// if not using custom pointer.
/// @param dataLength The calldata length. Provide the length of the calldata in bytes
/// unless using custom pointer.
/// @param gasPassed The gas to pass with the call.
/// @param shardId Of the account to call. Currently only 0 is supported.
/// @param forwardingMode The forwarding mode to use:
/// - provide CalldataForwardingMode.UseHeap when using your current memory
/// - provide CalldataForwardingMode.ForwardFatPointer when using custom pointer.
/// @param isConstructorCall Whether the call will be a call to the constructor
/// (ignored when the caller is not a system contract).
/// @param isSystemCall Whether the call will have the `isSystem` flag.
/// @return farCallAbi The far call ABI.
/// @dev The `FarCallABI` has the following structure:
/// pub struct FarCallABI {
///     pub memory_quasi_fat_pointer: FatPointer,
///     pub gas_passed: u32,
///     pub shard_id: u8,
///     pub forwarding_mode: FarCallForwardPageType,
///     pub constructor_call: bool,
///     pub to_system: bool,
/// }
///
/// The FatPointer struct:
///
/// pub struct FatPointer {
///     pub offset: u32, // offset relative to `start`
///     pub memory_page: u32, // memory page where slice is located
///     pub start: u32, // absolute start of the slice
///     pub length: u32, // length of the slice
/// }
///
/// @dev Note, that the actual layout is the following:
///
/// [0..32) bits -- the calldata offset
/// [32..64) bits -- the memory page to use. Can be left blank in most of the cases.
/// [64..96) bits -- the absolute start of the slice
/// [96..128) bits -- the length of the slice.
/// [128..192) bits -- empty bits.
/// [192..224) bits -- gasPassed.
/// [224..232) bits -- forwarding_mode
/// [232..240) bits -- shard id.
/// [240..248) bits -- constructor call flag
/// [248..256] bits -- system call flag
function getFarCallABI(
uint32 dataOffset,
uint32 memoryPage,
uint32 dataStart,
uint32 dataLength,
uint32 gasPassed,
uint8 shardId,
CalldataForwardingMode forwardingMode,
bool isConstructorCall,
bool isSystemCall
) internal pure returns (uint256 farCallAbi) {
// Fill in the call parameter fields
farCallAbi = getFarCallABIWithEmptyFatPointer(
gasPassed,
shardId,
forwardingMode,
isConstructorCall,
isSystemCall
);
// Fill in the fat pointer fields
farCallAbi |= dataOffset;
farCallAbi |= (uint256(memoryPage) << 32);
farCallAbi |= (uint256(dataStart) << 64);
farCallAbi |= (uint256(dataLength) << 96);
}

/// @notice Calculates the packed representation of the FarCallABI with zero fat pointer fields.
/// @param gasPassed The gas to pass with the call.
/// @param shardId Of the account to call. Currently only 0 is supported.
/// @param forwardingMode The forwarding mode to use:
/// - provide CalldataForwardingMode.UseHeap when using your current memory
/// - provide CalldataForwardingMode.ForwardFatPointer when using custom pointer.
/// @param isConstructorCall Whether the call will be a call to the constructor
/// (ignored when the caller is not a system contract).
/// @param isSystemCall Whether the call will have the `isSystem` flag.
/// @return farCallAbiWithEmptyFatPtr The far call ABI with zero fat pointer fields.
function getFarCallABIWithEmptyFatPointer(
uint32 gasPassed,
uint8 shardId,
CalldataForwardingMode forwardingMode,
bool isConstructorCall,
bool isSystemCall
) internal pure returns (uint256 farCallAbiWithEmptyFatPtr) {
farCallAbiWithEmptyFatPtr |= (uint256(gasPassed) << 192);
farCallAbiWithEmptyFatPtr |= (uint256(forwardingMode) << 224);
farCallAbiWithEmptyFatPtr |= (uint256(shardId) << 232);
if (isConstructorCall) {
farCallAbiWithEmptyFatPtr |= (1 << 240);
}
if (isSystemCall) {
farCallAbiWithEmptyFatPtr |= (1 << 248);
}
}
}

// contracts/system-contracts/contracts/libraries/TransactionHelper.sol

/// @dev The type id of zkSync's EIP-712-signed transaction.
uint8 constant EIP_712_TX_TYPE = 0x71;

/// @dev The type id of legacy transactions.
uint8 constant LEGACY_TX_TYPE = 0x0;
/// @dev The type id of legacy transactions.
uint8 constant EIP_2930_TX_TYPE = 0x01;
/// @dev The type id of EIP1559 transactions.
uint8 constant EIP_1559_TX_TYPE = 0x02;

/// @notice Structure used to represent a zkSync transaction.
struct Transaction {
// The type of the transaction.
uint256 txType;
// The caller.
uint256 from;
// The callee.
uint256 to;
// The gasLimit to pass with the transaction.
// It has the same meaning as Ethereum's gasLimit.
uint256 gasLimit;
// The maximum amount of gas the user is willing to pay for a byte of pubdata.
uint256 gasPerPubdataByteLimit;
// The maximum fee per gas that the user is willing to pay.
// It is akin to EIP1559's maxFeePerGas.
uint256 maxFeePerGas;
// The maximum priority fee per gas that the user is willing to pay.
// It is akin to EIP1559's maxPriorityFeePerGas.
uint256 maxPriorityFeePerGas;
// The transaction's paymaster. If there is no paymaster, it is equal to 0.
uint256 paymaster;
// The nonce of the transaction.
uint256 nonce;
// The value to pass with the transaction.
uint256 value;
// In the future, we might want to add some
// new fields to the struct. The `txData` struct
// is to be passed to account and any changes to its structure
// would mean a breaking change to these accounts. In order to prevent this,
// we should keep some fields as "reserved".
// It is also recommended that their length is fixed, since
// it would allow easier proof integration (in case we will need
// some special circuit for preprocessing transactions).
uint256[4] reserved;
// The transaction's calldata.
bytes data;
// The signature of the transaction.
bytes signature;
// The properly formatted hashes of bytecodes that must be published on L1
// with the inclusion of this transaction. Note, that a bytecode has been published
// before, the user won't pay fees for its republishing.
bytes32[] factoryDeps;
// The input to the paymaster.
bytes paymasterInput;
// Reserved dynamic type for the future use-case. Using it should be avoided,
// But it is still here, just in case we want to enable some additional functionality.
bytes reservedDynamic;
}

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice Library is used to help custom accounts to work with common methods for the Transaction type.
 */
library TransactionHelper {
using SafeERC20 for IERC20;

/// @notice The EIP-712 typehash for the contract's domain
bytes32 constant EIP712_DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId)");

bytes32 constant EIP712_TRANSACTION_TYPE_HASH =
keccak256(
"Transaction(uint256 txType,uint256 from,uint256 to,uint256 gasLimit,uint256 gasPerPubdataByteLimit,uint256 maxFeePerGas,uint256 maxPriorityFeePerGas,uint256 paymaster,uint256 nonce,uint256 value,bytes data,bytes32[] factoryDeps,bytes paymasterInput)"
);

/// @notice Whether the token is Ethereum.
/// @param _addr The address of the token
/// @return `true` or `false` based on whether the token is Ether.
/// @dev This method assumes that address is Ether either if the address is 0 (for convenience)
/// or if the address is the address of the L2EthToken system contract.
function isEthToken(uint256 _addr) internal pure returns (bool) {
return _addr == uint256(uint160(address(ETH_TOKEN_SYSTEM_CONTRACT))) || _addr == 0;
}

/// @notice Calculate the suggested signed hash of the transaction,
/// i.e. the hash that is signed by EOAs and is recommended to be signed by other accounts.
function encodeHash(Transaction calldata _transaction) internal view returns (bytes32 resultHash) {
if (_transaction.txType == LEGACY_TX_TYPE) {
resultHash = _encodeHashLegacyTransaction(_transaction);
} else if (_transaction.txType == EIP_712_TX_TYPE) {
resultHash = _encodeHashEIP712Transaction(_transaction);
} else if (_transaction.txType == EIP_1559_TX_TYPE) {
resultHash = _encodeHashEIP1559Transaction(_transaction);
} else if (_transaction.txType == EIP_2930_TX_TYPE) {
resultHash = _encodeHashEIP2930Transaction(_transaction);
} else {
// Currently no other transaction types are supported.
// Any new transaction types will be processed in a similar manner.
revert("Encoding unsupported tx");
}
}

/// @notice Encode hash of the zkSync native transaction type.
/// @return keccak256 hash of the EIP-712 encoded representation of transaction
function _encodeHashEIP712Transaction(Transaction calldata _transaction) private view returns (bytes32) {
bytes32 structHash = keccak256(
abi.encode(
EIP712_TRANSACTION_TYPE_HASH,
_transaction.txType,
_transaction.from,
_transaction.to,
_transaction.gasLimit,
_transaction.gasPerPubdataByteLimit,
_transaction.maxFeePerGas,
_transaction.maxPriorityFeePerGas,
_transaction.paymaster,
_transaction.nonce,
_transaction.value,
EfficientCall.keccak(_transaction.data),
keccak256(abi.encodePacked(_transaction.factoryDeps)),
EfficientCall.keccak(_transaction.paymasterInput)
)
);

bytes32 domainSeparator = keccak256(
abi.encode(EIP712_DOMAIN_TYPEHASH, keccak256("zkSync"), keccak256("2"), block.chainid)
);

return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
}

/// @notice Encode hash of the legacy transaction type.
/// @return keccak256 of the serialized RLP encoded representation of transaction
function _encodeHashLegacyTransaction(Transaction calldata _transaction) private view returns (bytes32) {
// Hash of legacy transactions are encoded as one of the:
// - RLP(nonce, gasPrice, gasLimit, to, value, data, chainId, 0, 0)
// - RLP(nonce, gasPrice, gasLimit, to, value, data)
//
// In this RLP encoding, only the first one above list appears, so we encode each element
// inside list and then concatenate the length of all elements with them.

bytes memory encodedNonce = RLPEncoder.encodeUint256(_transaction.nonce);
// Encode `gasPrice` and `gasLimit` together to prevent "stack too deep error".
bytes memory encodedGasParam;
{
bytes memory encodedGasPrice = RLPEncoder.encodeUint256(_transaction.maxFeePerGas);
bytes memory encodedGasLimit = RLPEncoder.encodeUint256(_transaction.gasLimit);
encodedGasParam = bytes.concat(encodedGasPrice, encodedGasLimit);
}

bytes memory encodedTo = RLPEncoder.encodeAddress(address(uint160(_transaction.to)));
bytes memory encodedValue = RLPEncoder.encodeUint256(_transaction.value);
// Encode only the length of the transaction data, and not the data itself,
// so as not to copy to memory a potentially huge transaction data twice.
bytes memory encodedDataLength;
{
// Safe cast, because the length of the transaction data can't be so large.
uint64 txDataLen = uint64(_transaction.data.length);
if (txDataLen != 1) {
// If the length is not equal to one, then only using the length can it be encoded definitely.
encodedDataLength = RLPEncoder.encodeNonSingleBytesLen(txDataLen);
} else if (_transaction.data[0] >= 0x80) {
// If input is a byte in [0x80, 0xff] range, RLP encoding will concatenates 0x81 with the byte.
encodedDataLength = hex"81";
}
// Otherwise the length is not encoded at all.
}

// Encode `chainId` according to EIP-155, but only if the `chainId` is specified in the transaction.
bytes memory encodedChainId;
if (_transaction.reserved[0] != 0) {
encodedChainId = bytes.concat(RLPEncoder.encodeUint256(block.chainid), hex"80_80");
}

bytes memory encodedListLength;
unchecked {
uint256 listLength = encodedNonce.length +
encodedGasParam.length +
encodedTo.length +
encodedValue.length +
encodedDataLength.length +
_transaction.data.length +
encodedChainId.length;

// Safe cast, because the length of the list can't be so large.
encodedListLength = RLPEncoder.encodeListLen(uint64(listLength));
}

return
keccak256(
bytes.concat(
encodedListLength,
encodedNonce,
encodedGasParam,
encodedTo,
encodedValue,
encodedDataLength,
_transaction.data,
encodedChainId
)
);
}

/// @notice Encode hash of the EIP2930 transaction type.
/// @return keccak256 of the serialized RLP encoded representation of transaction
function _encodeHashEIP2930Transaction(Transaction calldata _transaction) private view returns (bytes32) {
// Hash of EIP2930 transactions is encoded the following way:
// H(0x01 || RLP(chain_id, nonce, gas_price, gas_limit, destination, amount, data, access_list))
//
// Note, that on zkSync access lists are not supported and should always be empty.

// Encode all fixed-length params to avoid "stack too deep error"
bytes memory encodedFixedLengthParams;
{
bytes memory encodedChainId = RLPEncoder.encodeUint256(block.chainid);
bytes memory encodedNonce = RLPEncoder.encodeUint256(_transaction.nonce);
bytes memory encodedGasPrice = RLPEncoder.encodeUint256(_transaction.maxFeePerGas);
bytes memory encodedGasLimit = RLPEncoder.encodeUint256(_transaction.gasLimit);
bytes memory encodedTo = RLPEncoder.encodeAddress(address(uint160(_transaction.to)));
bytes memory encodedValue = RLPEncoder.encodeUint256(_transaction.value);
encodedFixedLengthParams = bytes.concat(
encodedChainId,
encodedNonce,
encodedGasPrice,
encodedGasLimit,
encodedTo,
encodedValue
);
}

// Encode only the length of the transaction data, and not the data itself,
// so as not to copy to memory a potentially huge transaction data twice.
bytes memory encodedDataLength;
{
// Safe cast, because the length of the transaction data can't be so large.
uint64 txDataLen = uint64(_transaction.data.length);
if (txDataLen != 1) {
// If the length is not equal to one, then only using the length can it be encoded definitely.
encodedDataLength = RLPEncoder.encodeNonSingleBytesLen(txDataLen);
} else if (_transaction.data[0] >= 0x80) {
// If input is a byte in [0x80, 0xff] range, RLP encoding will concatenates 0x81 with the byte.
encodedDataLength = hex"81";
}
// Otherwise the length is not encoded at all.
}

// On zkSync, access lists are always zero length (at least for now).
bytes memory encodedAccessListLength = RLPEncoder.encodeListLen(0);

bytes memory encodedListLength;
unchecked {
uint256 listLength = encodedFixedLengthParams.length +
encodedDataLength.length +
_transaction.data.length +
encodedAccessListLength.length;

// Safe cast, because the length of the list can't be so large.
encodedListLength = RLPEncoder.encodeListLen(uint64(listLength));
}

return
keccak256(
bytes.concat(
"\x01",
encodedListLength,
encodedFixedLengthParams,
encodedDataLength,
_transaction.data,
encodedAccessListLength
)
);
}

/// @notice Encode hash of the EIP1559 transaction type.
/// @return keccak256 of the serialized RLP encoded representation of transaction
function _encodeHashEIP1559Transaction(Transaction calldata _transaction) private view returns (bytes32) {
// Hash of EIP1559 transactions is encoded the following way:
// H(0x02 || RLP(chain_id, nonce, max_priority_fee_per_gas, max_fee_per_gas, gas_limit, destination, amount, data, access_list))
//
// Note, that on zkSync access lists are not supported and should always be empty.

// Encode all fixed-length params to avoid "stack too deep error"
bytes memory encodedFixedLengthParams;
{
bytes memory encodedChainId = RLPEncoder.encodeUint256(block.chainid);
bytes memory encodedNonce = RLPEncoder.encodeUint256(_transaction.nonce);
bytes memory encodedMaxPriorityFeePerGas = RLPEncoder.encodeUint256(_transaction.maxPriorityFeePerGas);
bytes memory encodedMaxFeePerGas = RLPEncoder.encodeUint256(_transaction.maxFeePerGas);
bytes memory encodedGasLimit = RLPEncoder.encodeUint256(_transaction.gasLimit);
bytes memory encodedTo = RLPEncoder.encodeAddress(address(uint160(_transaction.to)));
bytes memory encodedValue = RLPEncoder.encodeUint256(_transaction.value);
encodedFixedLengthParams = bytes.concat(
encodedChainId,
encodedNonce,
encodedMaxPriorityFeePerGas,
encodedMaxFeePerGas,
encodedGasLimit,
encodedTo,
encodedValue
);
}

// Encode only the length of the transaction data, and not the data itself,
// so as not to copy to memory a potentially huge transaction data twice.
bytes memory encodedDataLength;
{
// Safe cast, because the length of the transaction data can't be so large.
uint64 txDataLen = uint64(_transaction.data.length);
if (txDataLen != 1) {
// If the length is not equal to one, then only using the length can it be encoded definitely.
encodedDataLength = RLPEncoder.encodeNonSingleBytesLen(txDataLen);
} else if (_transaction.data[0] >= 0x80) {
// If input is a byte in [0x80, 0xff] range, RLP encoding will concatenates 0x81 with the byte.
encodedDataLength = hex"81";
}
// Otherwise the length is not encoded at all.
}

// On zkSync, access lists are always zero length (at least for now).
bytes memory encodedAccessListLength = RLPEncoder.encodeListLen(0);

bytes memory encodedListLength;
unchecked {
uint256 listLength = encodedFixedLengthParams.length +
encodedDataLength.length +
_transaction.data.length +
encodedAccessListLength.length;

// Safe cast, because the length of the list can't be so large.
encodedListLength = RLPEncoder.encodeListLen(uint64(listLength));
}

return
keccak256(
bytes.concat(
"\x02",
encodedListLength,
encodedFixedLengthParams,
encodedDataLength,
_transaction.data,
encodedAccessListLength
)
);
}

/// @notice Processes the common paymaster flows, e.g. setting proper allowance
/// for tokens, etc. For more information on the expected behavior, check out
/// the "Paymaster flows" section in the documentation.
function processPaymasterInput(Transaction calldata _transaction) internal {
require(_transaction.paymasterInput.length >= 4, "The standard paymaster input must be at least 4 bytes long");

bytes4 paymasterInputSelector = bytes4(_transaction.paymasterInput[0:4]);
if (paymasterInputSelector == IPaymasterFlow.approvalBased.selector) {
require(
_transaction.paymasterInput.length >= 68,
"The approvalBased paymaster input must be at least 68 bytes long"
);

// While the actual data consists of address, uint256 and bytes data,
// the data is needed only for the paymaster, so we ignore it here for the sake of optimization
(address token, uint256 minAllowance) = abi.decode(_transaction.paymasterInput[4:68], (address, uint256));
address paymaster = address(uint160(_transaction.paymaster));

uint256 currentAllowance = IERC20(token).allowance(address(this), paymaster);
if (currentAllowance < minAllowance) {
// Some tokens, e.g. USDT require that the allowance is firsty set to zero
// and only then updated to the new value.

IERC20(token).safeApprove(paymaster, 0);
IERC20(token).safeApprove(paymaster, minAllowance);
}
} else if (paymasterInputSelector == IPaymasterFlow.general.selector) {
// Do nothing. general(bytes) paymaster flow means that the paymaster must interpret these bytes on his own.
} else {
revert("Unsupported paymaster flow");
}
}

/// @notice Pays the required fee for the transaction to the bootloader.
/// @dev Currently it pays the maximum amount "_transaction.maxFeePerGas * _transaction.gasLimit",
/// it will change in the future.
function payToTheBootloader(Transaction calldata _transaction) internal returns (bool success) {
address bootloaderAddr = BOOTLOADER_FORMAL_ADDRESS;
uint256 amount = _transaction.maxFeePerGas * _transaction.gasLimit;

assembly {
success := call(gas(), bootloaderAddr, amount, 0, 0, 0, 0)
}
}

// Returns the balance required to process the transaction.
function totalRequiredBalance(Transaction calldata _transaction) internal pure returns (uint256 requiredBalance) {
if (address(uint160(_transaction.paymaster)) != address(0)) {
// Paymaster pays for the fee
requiredBalance = _transaction.value;
} else {
// The user should have enough balance for both the fee and the value of the transaction
requiredBalance = _transaction.maxFeePerGas * _transaction.gasLimit + _transaction.value;
}
}
}

// contracts/system-contracts/contracts/libraries/Utils.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @dev Common utilities used in zkSync system contracts
 */
library Utils {
/// @dev Bit mask of bytecode hash "isConstructor" marker
bytes32 constant IS_CONSTRUCTOR_BYTECODE_HASH_BIT_MASK =
0x00ff000000000000000000000000000000000000000000000000000000000000;

/// @dev Bit mask to set the "isConstructor" marker in the bytecode hash
bytes32 constant SET_IS_CONSTRUCTOR_MARKER_BIT_MASK =
0x0001000000000000000000000000000000000000000000000000000000000000;

function safeCastToU128(uint256 _x) internal pure returns (uint128) {
require(_x <= type(uint128).max, "Overflow");

return uint128(_x);
}

function safeCastToU32(uint256 _x) internal pure returns (uint32) {
require(_x <= type(uint32).max, "Overflow");

return uint32(_x);
}

function safeCastToU24(uint256 _x) internal pure returns (uint24) {
require(_x <= type(uint24).max, "Overflow");

return uint24(_x);
}

/// @return codeLength The bytecode length in bytes
function bytecodeLenInBytes(bytes32 _bytecodeHash) internal pure returns (uint256 codeLength) {
codeLength = bytecodeLenInWords(_bytecodeHash) << 5; // _bytecodeHash * 32
}

/// @return codeLengthInWords The bytecode length in machine words
function bytecodeLenInWords(bytes32 _bytecodeHash) internal pure returns (uint256 codeLengthInWords) {
unchecked {
codeLengthInWords = uint256(uint8(_bytecodeHash[2])) * 256 + uint256(uint8(_bytecodeHash[3]));
}
}

/// @notice Denotes whether bytecode hash corresponds to a contract that already constructed
function isContractConstructed(bytes32 _bytecodeHash) internal pure returns (bool) {
return _bytecodeHash[1] == 0x00;
}

/// @notice Denotes whether bytecode hash corresponds to a contract that is on constructor or has already been constructed
function isContractConstructing(bytes32 _bytecodeHash) internal pure returns (bool) {
return _bytecodeHash[1] == 0x01;
}

/// @notice Sets "isConstructor" flag to TRUE for the bytecode hash
/// @param _bytecodeHash The bytecode hash for which it is needed to set the constructing flag
/// @return The bytecode hash with "isConstructor" flag set to TRUE
function constructingBytecodeHash(bytes32 _bytecodeHash) internal pure returns (bytes32) {
// Clear the "isConstructor" marker and set it to 0x01.
return constructedBytecodeHash(_bytecodeHash) | SET_IS_CONSTRUCTOR_MARKER_BIT_MASK;
}

/// @notice Sets "isConstructor" flag to FALSE for the bytecode hash
/// @param _bytecodeHash The bytecode hash for which it is needed to set the constructing flag
/// @return The bytecode hash with "isConstructor" flag set to FALSE
function constructedBytecodeHash(bytes32 _bytecodeHash) internal pure returns (bytes32) {
return _bytecodeHash & ~IS_CONSTRUCTOR_BYTECODE_HASH_BIT_MASK;
}

/// @notice Validate the bytecode format and calculate its hash.
/// @param _bytecode The bytecode to hash.
/// @return hashedBytecode The 32-byte hash of the bytecode.
/// Note: The function reverts the execution if the bytecode has non expected format:
/// - Bytecode bytes length is not a multiple of 32
/// - Bytecode bytes length is not less than 2^21 bytes (2^16 words)
/// - Bytecode words length is not odd
function hashL2Bytecode(bytes calldata _bytecode) internal view returns (bytes32 hashedBytecode) {
// Note that the length of the bytecode must be provided in 32-byte words.
require(_bytecode.length % 32 == 0, "po");

uint256 lengthInWords = _bytecode.length / 32;
require(lengthInWords < 2 ** 16, "pp"); // bytecode length must be less than 2^16 words
require(lengthInWords % 2 == 1, "pr"); // bytecode length in words must be odd
hashedBytecode =
EfficientCall.sha(_bytecode) &
0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
// Setting the version of the hash
hashedBytecode = (hashedBytecode | bytes32(uint256(1 << 248)));
// Setting the length
hashedBytecode = hashedBytecode | bytes32(lengthInWords << 224);
}
}

// contracts/system-contracts/contracts/interfaces/ISystemContract.sol

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice An abstract contract that is used to reuse modifiers across the system contracts.
 * @dev Solidity does not allow exporting modifiers via libraries, so
 * the only way to do reuse modifiers is to have a base contract
 * @dev Never add storage variables into this contract as some
 * system contracts rely on this abstract contract as on interface!
 */
abstract contract ISystemContract {
/// @notice Modifier that makes sure that the method
/// can only be called via a system call.
modifier onlySystemCall() {
require(
SystemContractHelper.isSystemCall() || SystemContractHelper.isSystemContract(msg.sender),
"This method require system call flag"
);
_;
}

/// @notice Modifier that makes sure that the method
/// can only be called from a system contract.
modifier onlyCallFromSystemContract() {
require(
SystemContractHelper.isSystemContract(msg.sender),
"This method require the caller to be system contract"
);
_;
}

/// @notice Modifier that makes sure that the method
/// can only be called from a special given address.
modifier onlyCallFrom(address caller) {
require(msg.sender == caller, "Inappropriate caller");
_;
}

/// @notice Modifier that makes sure that the method
/// can only be called from the bootloader.
modifier onlyCallFromBootloader() {
require(msg.sender == BOOTLOADER_FORMAL_ADDRESS, "Callable only by the bootloader");
_;
}
}

// contracts/system-contracts/contracts/ContractDeployer.sol

// where

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice System smart contract that is responsible for deploying other smart contracts on zkSync.
 * @dev The contract is responsible for generating the address of the deployed smart contract,
 * incrementing the deployment nonce and making sure that the constructor is never called twice in a contract.
 * Note, contracts with bytecode that have already been published to L1 once
 * do not need to be published anymore.
 */
contract ContractDeployer is IContractDeployer, ISystemContract {
/// @notice Information about an account contract.
/// @dev For EOA and simple contracts (i.e. not accounts) this value is 0.
mapping(address => AccountInfo) internal accountInfo;

modifier onlySelf() {
require(msg.sender == address(this), "Callable only by self");
_;
}

/// @notice Returns information about a certain account.
function getAccountInfo(address _address) external view returns (AccountInfo memory info) {
return accountInfo[_address];
}

/// @notice Returns the account abstraction version if `_address` is a deployed contract.
/// Returns the latest supported account abstraction version if `_address` is an EOA.
function extendedAccountVersion(address _address) public view returns (AccountAbstractionVersion) {
AccountInfo memory info = accountInfo[_address];
if (info.supportedAAVersion != AccountAbstractionVersion.None) {
return info.supportedAAVersion;
}

// It is an EOA, it is still an account.
if (
_address > address(MAX_SYSTEM_CONTRACT_ADDRESS) &&
ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT.getRawCodeHash(_address) == 0
) {
return AccountAbstractionVersion.Version1;
}

return AccountAbstractionVersion.None;
}

/// @notice Stores the new account information
function _storeAccountInfo(address _address, AccountInfo memory _newInfo) internal {
accountInfo[_address] = _newInfo;
}

/// @notice Update the used version of the account.
/// @param _version The new version of the AA protocol to use.
/// @dev Note that it allows changes from account to non-account and vice versa.
function updateAccountVersion(AccountAbstractionVersion _version) external onlySystemCall {
accountInfo[msg.sender].supportedAAVersion = _version;

emit AccountVersionUpdated(msg.sender, _version);
}

/// @notice Updates the nonce ordering of the account. Currently,
/// it only allows changes from sequential to arbitrary ordering.
/// @param _nonceOrdering The new nonce ordering to use.
function updateNonceOrdering(AccountNonceOrdering _nonceOrdering) external onlySystemCall {
AccountInfo memory currentInfo = accountInfo[msg.sender];

require(
_nonceOrdering == AccountNonceOrdering.Arbitrary &&
currentInfo.nonceOrdering == AccountNonceOrdering.Sequential,
"It is only possible to change from sequential to arbitrary ordering"
);

currentInfo.nonceOrdering = _nonceOrdering;
_storeAccountInfo(msg.sender, currentInfo);

emit AccountNonceOrderingUpdated(msg.sender, _nonceOrdering);
}

/// @notice Calculates the address of a deployed contract via create2
/// @param _sender The account that deploys the contract.
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _salt The create2 salt.
/// @param _input The constructor data.
/// @return newAddress The derived address of the account.
function getNewAddressCreate2(
address _sender,
bytes32 _bytecodeHash,
bytes32 _salt,
bytes calldata _input
) public view override returns (address newAddress) {
// No collision is possible with the Ethereum's CREATE2, since
// the prefix begins with 0x20....
bytes32 constructorInputHash = EfficientCall.keccak(_input);

bytes32 hash = keccak256(
bytes.concat(CREATE2_PREFIX, bytes32(uint256(uint160(_sender))), _salt, _bytecodeHash, constructorInputHash)
);

newAddress = address(uint160(uint256(hash)));
}

/// @notice Calculates the address of a deployed contract via create
/// @param _sender The account that deploys the contract.
/// @param _senderNonce The deploy nonce of the sender's account.
function getNewAddressCreate(
address _sender,
uint256 _senderNonce
) public pure override returns (address newAddress) {
// No collision is possible with the Ethereum's CREATE, since
// the prefix begins with 0x63....
bytes32 hash = keccak256(
bytes.concat(CREATE_PREFIX, bytes32(uint256(uint160(_sender))), bytes32(_senderNonce))
);

newAddress = address(uint160(uint256(hash)));
}

/// @notice Deploys a contract with similar address derivation rules to the EVM's `CREATE2` opcode.
/// @param _salt The CREATE2 salt
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _input The constructor calldata
/// @dev In case of a revert, the zero address should be returned.
function create2(
bytes32 _salt,
bytes32 _bytecodeHash,
bytes calldata _input
) external payable override returns (address) {
return create2Account(_salt, _bytecodeHash, _input, AccountAbstractionVersion.None);
}

/// @notice Deploys a contract with similar address derivation rules to the EVM's `CREATE` opcode.
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _input The constructor calldata
/// @dev This method also accepts nonce as one of its parameters.
/// It is not used anywhere and it needed simply for the consistency for the compiler
/// @dev In case of a revert, the zero address should be returned.
/// Note: this method may be callable only in system mode,
/// that is checked in the `createAccount` by `onlySystemCall` modifier.
function create(
bytes32 _salt,
bytes32 _bytecodeHash,
bytes calldata _input
) external payable override returns (address) {
return createAccount(_salt, _bytecodeHash, _input, AccountAbstractionVersion.None);
}

/// @notice Deploys a contract account with similar address derivation rules to the EVM's `CREATE2` opcode.
/// @param _salt The CREATE2 salt
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _input The constructor calldata.
/// @param _aaVersion The account abstraction version to use.
/// @dev In case of a revert, the zero address should be returned.
/// Note: this method may be callable only in system mode,
/// that is checked in the `createAccount` by `onlySystemCall` modifier.
function create2Account(
bytes32 _salt,
bytes32 _bytecodeHash,
bytes calldata _input,
AccountAbstractionVersion _aaVersion
) public payable override onlySystemCall returns (address) {
NONCE_HOLDER_SYSTEM_CONTRACT.incrementDeploymentNonce(msg.sender);
address newAddress = getNewAddressCreate2(msg.sender, _bytecodeHash, _salt, _input);

_nonSystemDeployOnAddress(_bytecodeHash, newAddress, _aaVersion, _input);

return newAddress;
}

/// @notice Deploys a contract account with similar address derivation rules to the EVM's `CREATE` opcode.
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _input The constructor calldata.
/// @param _aaVersion The account abstraction version to use.
/// @dev This method also accepts salt as one of its parameters.
/// It is not used anywhere and it needed simply for the consistency for the compiler
/// @dev In case of a revert, the zero address should be returned.
function createAccount(
bytes32, // salt
bytes32 _bytecodeHash,
bytes calldata _input,
AccountAbstractionVersion _aaVersion
) public payable override onlySystemCall returns (address) {
uint256 senderNonce = NONCE_HOLDER_SYSTEM_CONTRACT.incrementDeploymentNonce(msg.sender);
address newAddress = getNewAddressCreate(msg.sender, senderNonce);

_nonSystemDeployOnAddress(_bytecodeHash, newAddress, _aaVersion, _input);

return newAddress;
}

/// @notice A struct that describes a forced deployment on an address
struct ForceDeployment {
// The bytecode hash to put on an address
bytes32 bytecodeHash;
// The address on which to deploy the bytecodehash to
address newAddress;
// Whether to run the constructor on the force deployment
bool callConstructor;
// The value with which to initialize a contract
uint256 value;
// The constructor calldata
bytes input;
}

/// @notice The method that can be used to forcefully deploy a contract.
/// @param _deployment Information about the forced deployment.
/// @param _sender The `msg.sender` inside the constructor call.
function forceDeployOnAddress(ForceDeployment calldata _deployment, address _sender) external payable onlySelf {
_ensureBytecodeIsKnown(_deployment.bytecodeHash);

// Since the `forceDeployOnAddress` function is called only during upgrades, the Governance is trusted to correctly select
// the addresses to deploy the new bytecodes to and to assess whether overriding the AccountInfo for the "force-deployed"
// contract is acceptable.
AccountInfo memory newAccountInfo;
newAccountInfo.supportedAAVersion = AccountAbstractionVersion.None;
// Accounts have sequential nonces by default.
newAccountInfo.nonceOrdering = AccountNonceOrdering.Sequential;
_storeAccountInfo(_deployment.newAddress, newAccountInfo);

_constructContract(
_sender,
_deployment.newAddress,
_deployment.bytecodeHash,
_deployment.input,
false,
_deployment.callConstructor
);
}

/// @notice The method that is temporarily needed to upgrade the Keccak256 precompile. This function and `Bootloader:upgradeKeccakIfNeeded`
/// are to be removed once the upgrade is complete. Unlike a normal forced deployment, it does not update account information as it requires
/// updating a mapping, and so requires Keccak256 precompile to work already.
/// @dev This method expects the sender (FORCE_DEPLOYER) to provide the correct bytecode hash for the Keccak256
/// precompile.
function forceDeployKeccak256(bytes32 _keccak256BytecodeHash) external payable onlyCallFrom(FORCE_DEPLOYER) {
_ensureBytecodeIsKnown(_keccak256BytecodeHash);

_constructContract(
msg.sender,
address(KECCAK256_SYSTEM_CONTRACT),
_keccak256BytecodeHash,
msg.data[0:0],
false,
false
);
}

/// @notice This method is to be used only during an upgrade to set bytecodes on specific addresses.
/// @dev We do not require `onlySystemCall` here, since the method is accessible only
/// by `FORCE_DEPLOYER`.
function forceDeployOnAddresses(ForceDeployment[] calldata _deployments) external payable {
require(
msg.sender == FORCE_DEPLOYER || msg.sender == address(COMPLEX_UPGRADER_CONTRACT),
"Can only be called by FORCE_DEPLOYER or COMPLEX_UPGRADER_CONTRACT"
);

uint256 deploymentsLength = _deployments.length;
// We need to ensure that the `value` provided by the call is enough to provide `value`
// for all of the deployments
uint256 sumOfValues = 0;
for (uint256 i = 0; i < deploymentsLength; ++i) {
sumOfValues += _deployments[i].value;
}
require(msg.value == sumOfValues, "`value` provided is not equal to the combined `value`s of deployments");

for (uint256 i = 0; i < deploymentsLength; ++i) {
this.forceDeployOnAddress{value: _deployments[i].value}(_deployments[i], msg.sender);
}
}

function _nonSystemDeployOnAddress(
bytes32 _bytecodeHash,
address _newAddress,
AccountAbstractionVersion _aaVersion,
bytes calldata _input
) internal {
require(_bytecodeHash != bytes32(0x0), "BytecodeHash cannot be zero");
require(uint160(_newAddress) > MAX_SYSTEM_CONTRACT_ADDRESS, "Can not deploy contracts in kernel space");

// We do not allow deploying twice on the same address.
require(
ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT.getCodeHash(uint256(uint160(_newAddress))) == 0x0,
"Code hash is non-zero"
);
// Do not allow deploying contracts to default accounts that have already executed transactions.
require(NONCE_HOLDER_SYSTEM_CONTRACT.getRawNonce(_newAddress) == 0x00, "Account is occupied");

_performDeployOnAddress(_bytecodeHash, _newAddress, _aaVersion, _input);
}

/// @notice Deploy a certain bytecode on the address.
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
/// @param _newAddress The address of the contract to be deployed.
/// @param _aaVersion The version of the account abstraction protocol to use.
/// @param _input The constructor calldata.
function _performDeployOnAddress(
bytes32 _bytecodeHash,
address _newAddress,
AccountAbstractionVersion _aaVersion,
bytes calldata _input
) internal {
_ensureBytecodeIsKnown(_bytecodeHash);

AccountInfo memory newAccountInfo;
newAccountInfo.supportedAAVersion = _aaVersion;
// Accounts have sequential nonces by default.
newAccountInfo.nonceOrdering = AccountNonceOrdering.Sequential;
_storeAccountInfo(_newAddress, newAccountInfo);

_constructContract(msg.sender, _newAddress, _bytecodeHash, _input, false, true);
}

/// @notice Check that bytecode hash is marked as known on the `KnownCodeStorage` system contracts
function _ensureBytecodeIsKnown(bytes32 _bytecodeHash) internal view {
uint256 knownCodeMarker = KNOWN_CODE_STORAGE_CONTRACT.getMarker(_bytecodeHash);
require(knownCodeMarker > 0, "The code hash is not known");
}

/// @notice Ensures that the _newAddress and assigns a new contract hash to it
/// @param _newAddress The address of the deployed contract
/// @param _bytecodeHash The correctly formatted hash of the bytecode.
function _storeConstructingByteCodeHashOnAddress(address _newAddress, bytes32 _bytecodeHash) internal {
// Set the "isConstructor" flag to the bytecode hash
bytes32 constructingBytecodeHash = Utils.constructingBytecodeHash(_bytecodeHash);
ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT.storeAccountConstructingCodeHash(_newAddress, constructingBytecodeHash);
}

/// @notice Transfers the `msg.value` ETH to the deployed account & invokes its constructor.
/// This function must revert in case the deployment fails.
/// @param _sender The msg.sender to be used in the constructor
/// @param _newAddress The address of the deployed contract
/// @param _input The constructor calldata
/// @param _isSystem Whether the call should be a system call (could be possibly required in the future).
function _constructContract(
address _sender,
address _newAddress,
bytes32 _bytecodeHash,
bytes calldata _input,
bool _isSystem,
bool _callConstructor
) internal {
uint256 value = msg.value;
if (_callConstructor) {
// 1. Transfer the balance to the new address on the constructor call.
if (value > 0) {
ETH_TOKEN_SYSTEM_CONTRACT.transferFromTo(address(this), _newAddress, value);
}
// 2. Set the constructed code hash on the account
_storeConstructingByteCodeHashOnAddress(_newAddress, _bytecodeHash);

// 3. Call the constructor on behalf of the account
if (value > 0) {
// Safe to cast value, because `msg.value` <= `uint128.max` due to `MessageValueSimulator` invariant
SystemContractHelper.setValueForNextFarCall(uint128(value));
}
bytes memory returnData = EfficientCall.mimicCall(gasleft(), _newAddress, _input, _sender, true, _isSystem);
// 4. Mark bytecode hash as constructed
ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT.markAccountCodeHashAsConstructed(_newAddress);
// 5. Set the contract immutables
ImmutableData[] memory immutables = abi.decode(returnData, (ImmutableData[]));
IMMUTABLE_SIMULATOR_SYSTEM_CONTRACT.setImmutables(_newAddress, immutables);
} else {
require(value == 0, "The value must be zero if we do not call the constructor");
// If we do not call the constructor, we need to set the constructed code hash.
ACCOUNT_CODE_STORAGE_SYSTEM_CONTRACT.storeAccountConstructedCodeHash(_newAddress, _bytecodeHash);
}

emit ContractDeployed(_sender, _bytecodeHash, _newAddress);
}
}
