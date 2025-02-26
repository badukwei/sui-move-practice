module practice1::practice1 {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::String;

    // struct
    public struct Bill has key, store {
        id: UID,
        price: u64,
        name: String,
    }

    public struct Folder has key, store {
        id: UID,
        bill: Bill,
        intended_address: address,
    }

    public struct OwnerCap has key {
        id: UID,
    }

    // errors
    const EWrongAddress: u64 = 0;

    // functions
    fun init(ctx: &mut TxContext) {
        transfer::transfer(OwnerCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx));
    }

    public fun create_bill(_: &OwnerCap, price: u64, name: String, ctx: &mut TxContext): Bill {
        let bill = Bill {
            id: object::new(ctx),
            price,
            name,
        };

        bill
    }

    public fun request_bill(bill: Bill, intended_address: address, ctx: &mut TxContext) {
        let folder = Folder {
            id: object::new(ctx),
            bill,
            intended_address,
        };

        transfer::transfer(folder, intended_address)
    }

    public fun unpack_bill(folder: Folder, ctx: &mut TxContext): Bill {
        assert!(folder.intended_address == tx_context::sender(ctx), EWrongAddress);

        let Folder {
            id,
            bill,
            intended_address: _,
        } = folder;

          
        object::delete(id);
        bill
    }
}
