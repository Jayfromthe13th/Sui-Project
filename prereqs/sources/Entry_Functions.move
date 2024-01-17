module examples::digital_collectible {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    
    struct Collectible has key {
        id: UID,
        name String,
        creator: address
    }

    public fun create_collectible(ctx: &mut TxContext, name: string, creator: address) Collectible {
        Collectible {
            id: object::new(ctx),
            namne: name,
            creator: creator
        }
    }

    entry fun transfer_collectible(to: address, ctx: &mut TxContext, collectible: Collectible) {
        transfer::transfer(collectible, to)
    }
}