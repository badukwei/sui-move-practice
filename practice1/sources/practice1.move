module practice1::practice1 {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::ascii::String;

    public struct Product has key, store {
        id: UID,
        name: String,
        price: u64,
    }

    public struct Store has key, store {
        id: UID,
        product: Product,
        name: String,
    }

    public fun create_product(name: String, price: u64, ctx: &mut TxContext) {
        let product = Product {
            id: object::new(ctx),
            name,
            price,
        };

        transfer::transfer(product, tx_context::sender(ctx))
    }
}
