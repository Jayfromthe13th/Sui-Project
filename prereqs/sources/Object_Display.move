module examples::virtual_estate {
    use sui::tx_context::{sender, TxContext};
    use std::string::{utf8, String};
    use sui::transfer;
    use sui::object::{Self, UID};

    use sui::package;
    use sui::display;

    struct Estate has key, store {
        id: UID,
        location: String,
        image_link: String,
    }

    struct VIRTUAL_ESTATE has drop {}

    fun init(otw: VIRTUAL_ESTATE, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"location"),
            utf8(b"view"),
            utf8(b"image_link"),
            utf8(b"description"),
            utf8(b"official_site"),
            utf8(b"creator"),
        ];

        let values = vector[
            utf8(b"{location}"),
            utf8(b"https://virtual-estate.io/view/{id}"),
            utf8(b"ipfs://{image_link}"),
            utf8(b"Experience luxury living in the virtual world!"),
            utf8(b"https://virtual-estate.io"),
            utf8(b"Virtual Estate Developer")
        ];

        let publisher = package::claim(otw, ctx);
        let display = display::new_with_fields<Estate>(
            &publisher, keys, values, ctx
        );
        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

    public fun mint(location: String, image_link: String, ctx: &mut TxContext): Estate {
        let id = object::new(ctx);
        Estate { id, location, image_link }
    }
}
