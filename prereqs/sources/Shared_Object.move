module examples:: digital_bookstore {
    use sui::transfer;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
//error code that indicated insufficent funds
    const ENotEnough: u64 = 0;

    struct BookstoreOwnerCap has key { id: UID }
    struct DigitalBooks has key { id: UID, title: String, price: u64 }
    struct DigitalBookStore has key { id: UID, balance: Balance<SUI> }
  
  fun init_bookstore(ctx: &mut TxContext) {
        transfer::share_object(DigitalBookstore {
            id: object::new(ctx),
            balance: balance::zero()
        });
    }
}