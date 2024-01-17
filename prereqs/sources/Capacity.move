module examples::virtual_library {
    use sui::transfer;
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    /// Type that marks Capability to create new `VirtualBook`s.
    struct LibraryAdminCap has key { id: UID }

    /// Custom type representing a virtual book.
    struct VirtualBook has key, store { id: UID, title: String }

    /// Module initializer is called once on module publish.
    /// Here we create only one instance of `LibraryAdminCap` and send it to the publisher.
    fun init(ctx: &mut TxContext) {
        transfer::transfer(LibraryAdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

    /// Only the owner of the `LibraryAdminCap` can call this function to create a new virtual book.
    public fun create_and_send(
        _: &LibraryAdminCap, title: vector<u8>, to: address, ctx: &mut TxContext
    ) {
        transfer::transfer(VirtualBook {
            id: object::new(ctx),
            title: string::utf8(title)
        }, to)
    }
}
