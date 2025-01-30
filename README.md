# BatchPayMaster

## Overview
BatchPayMaster is a smart contract designed for processing multiple payments in a single transaction. It provides validation, error checking, and secure batch transfers, ensuring efficiency and security in handling bulk payments.

## Features
- **Batch Transfers**: Allows multiple payments to be processed in one transaction.
- **Validation and Error Handling**: Checks for list length mismatches, insufficient funds, and overflow issues.
- **Transaction Limit**: Restricts the number of transactions per batch.
- **Ownership Management**: Allows contract ownership transfer and transaction limit updates.

## Constants
- `ERR-INSUFFICIENT-FUNDS (err u100)`: Triggered when the sender has insufficient funds.
- `ERR-LISTS-LENGTH-MISMATCH (err u102)`: Triggered when the recipients and amounts lists do not match in length.
- `ERR-OVERFLOW (err u104)`: Triggered when the transaction limit is exceeded.
- `ERR-UNAUTHORIZED (err u105)`: Triggered when an unauthorized user attempts an admin function.

## Data Variables
- `contract-owner (principal)`: Stores the address of the contract owner.
- `transaction-limit (uint)`: Defines the maximum number of transactions per batch.

## Read-Only Functions
- `get-owner ()`: Returns the current contract owner.
- `get-transaction-limit ()`: Returns the current transaction limit.

## Private Functions
- `transfer-amount (recipient principal, amount uint)`: Transfers the specified amount to the recipient.
- `check-lists-length (recipients, amounts)`: Ensures the recipients and amounts lists have the same length.
- `calculate-total-amount (amounts)`: Computes the total amount to be transferred.

## Public Functions
### `batch-transfer (recipients, amounts)`
Processes a batch transfer by:
1. Validating input lists.
2. Checking if the sender has sufficient funds.
3. Ensuring the transaction limit is not exceeded.
4. Executing the transfers.

### `set-transaction-limit (new-limit)`
- Only the contract owner can call this function.
- Updates the maximum number of transactions per batch.

### `transfer-ownership (new-owner)`
- Only the contract owner can call this function.
- Transfers ownership to a new principal.

## Security Considerations
- Only the contract owner can modify the transaction limit and transfer ownership.
- The contract prevents overflow errors by enforcing a transaction limit.
- Insufficient funds checks ensure that batch transactions do not fail mid-process.

## Usage Example
1. **Owner sets transaction limit:**
   ```lisp
   (set-transaction-limit u50)
   ```
2. **User initiates a batch transfer:**
   ```lisp
   (batch-transfer (list SP123 SP456) (list u1000 u2000))
   ```
3. **Owner transfers contract ownership:**
   ```lisp
   (transfer-ownership SP789)
   ```

## License
This contract is open-source and available for use under the MIT License.

