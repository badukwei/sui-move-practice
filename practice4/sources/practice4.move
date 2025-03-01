module practice4::template {
    use sui::coin;
    use sui::url;

    public struct TEMPLATE has drop {}

    const DECIMALS: u8 = 0;
    const SYMBOL: vector<u8> = b"TMPL";
    const NAME: vector<u8> = b"template_coin";
    const DESCRIPTION: vector<u8> = b"template_coin description";
    const ICON_URL: vector<u8> = b"template_icon_url";

    /// Capability allowing the bearer to mint and burn
    /// coins of type `T`. Transferable
    // public struct TreasuryCap<phantom T> has key, store {
    //     id: UID,
    //     total_supply: Supply<T>,
    // }

    fun init(witness: TEMPLATE, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness, 
            DECIMALS, 
            SYMBOL, 
            NAME, 
            DESCRIPTION, 
            option::some(url::new_unsafe_from_bytes(ICON_URL)),
            ctx
        );

        transfer::public_transfer(treasury, tx_context::sender(ctx));
        transfer::public_transfer(metadata, tx_context::sender(ctx));
    }
}