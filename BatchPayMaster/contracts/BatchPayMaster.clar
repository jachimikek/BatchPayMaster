;; BatchPayMaster
;; Smart contract for processing multiple payments in one transaction
;; Handles validation, error checking, and secure batch transfers

(define-constant ERR-INSUFFICIENT-FUNDS (err u100))
(define-constant ERR-LISTS-LENGTH-MISMATCH (err u102))
(define-constant ERR-OVERFLOW (err u104))
(define-constant ERR-UNAUTHORIZED (err u105))

;; Data variables
(define-data-var contract-owner principal tx-sender)
(define-data-var transaction-limit uint u100)

;; Read-only functions
(define-read-only (get-owner)
    (var-get contract-owner)
)

(define-read-only (get-transaction-limit)
    (var-get transaction-limit)
)

;; Private functions
(define-private (transfer-amount (recipient principal) (amount uint))
    (stx-transfer? amount tx-sender recipient)
)

(define-private (check-lists-length (recipients (list 200 principal)) (amounts (list 200 uint)))
    (if (is-eq (len recipients) (len amounts))
        (ok true)
        ERR-LISTS-LENGTH-MISMATCH
    )
)

(define-private (calculate-total-amount (amounts (list 200 uint)))
    (fold + amounts u0)
)

;; Public functions
(define-public (batch-transfer (recipients (list 200 principal)) (amounts (list 200 uint)))
    (begin
        ;; Validate input lists
        (try! (check-lists-length recipients amounts))
        
        ;; Calculate total amount
        (let ((total-amount (calculate-total-amount amounts)))
            
            ;; Check for overflow
            (asserts! (<= total-amount (stx-get-balance tx-sender)) ERR-INSUFFICIENT-FUNDS)
            
            ;; Validate transaction limit
            (asserts! (<= (len recipients) (var-get transaction-limit)) ERR-OVERFLOW)
            
            ;; Process transfers
            (map transfer-amount recipients amounts)
            
            (ok true)
        )
    )
)

;; Admin functions
(define-public (set-transaction-limit (new-limit uint))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-UNAUTHORIZED)
        (ok (var-set transaction-limit new-limit))
    )
)

(define-public (transfer-ownership (new-owner principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-UNAUTHORIZED)
        (ok (var-set contract-owner new-owner))
    )
)