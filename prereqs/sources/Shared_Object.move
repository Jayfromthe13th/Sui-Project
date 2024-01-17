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

   /// Add a book to the bookstore.
    public fun add_book(ctx: &mut TxContext, title: String, price: u64) -> DigitalBook {
        DigitalBook {
            id: object::new(ctx),
            title,
            price
        }
    }

    /// Buy a digital book.
    public fun buy_book(book: &mut DigitalBook, payment: &mut Coin<SUI>, ctx: &mut TxContext) {
        assert!(coin::value(payment) >= book.price, ENotEnough);
        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, book.price);
        balance::join(&mut book.balance, paid);

        transfer::transfer(book, tx_context::sender(ctx))
    }

    /// Collect profits from the bookstore.
    public fun collect_profits(_: &BookstoreOwnerCap, store: &mut DigitalBookstore, ctx: &mut TxContext): Coin<SUI> {
        let amount = balance::value(&store.balance);
        coin::take(&mut store.balance, amount, ctx)
    }
}
