module examples::digital_art {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    // Importing functionality from the wrapper module
    use examples::wrapper::{Self, Wrapper};

    // Structure representing a digital art piece
    struct DigitalArt has store {
        id: UID,
        title: String,
        creator: String,
        created_at: u64,
        current_owner: UID
    }

    // Function to create a new digital art piece
    public fun create_art(
        title: String, creator: String, ctx: &mut TxContext
    ): Wrapper<DigitalArt> {
        let art = DigitalArt {
            id: object::new(ctx),
            title,
            creator,
            created_at: ctx.now(),
            current_owner: ctx.sender()
        };
        wrapper::create(art, ctx)
    }

    // Function to transfer ownership of a digital art piece
    public fun transfer_art(
        art: &mut Wrapper<DigitalArt>, new_owner: UID, ctx: &mut TxContext
    ) {
        let DigitalArt { current_owner, .. } = art;
        assert!(ctx.sender() == current_owner, 401); // Unauthorized transfer

        art.current_owner = new_owner;
        // Optionally, log the transfer or update a history record here
    }

    // Function to view details of a digital art piece
    public fun view_art_details(art: &Wrapper<DigitalArt>) -> (String, String, u64, UID) {
        let DigitalArt { title, creator, created_at, current_owner, .. } = art;
        (title.clone(), creator.clone(), *created_at, *current_owner)
    }
}
