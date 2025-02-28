module practice1::objects {
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

    public entry fun add_owner(_: &OwnerCap, new_owner_address: address, ctx: &mut TxContext) {
        transfer::transfer(OwnerCap {
            id: object::new(ctx),
        }, new_owner_address);
    }

    public entry fun create_bill(_: &OwnerCap, price: u64, name: String, ctx: &mut TxContext) {
        let bill = Bill {
            id: object::new(ctx),
            price,
            name,
        };

        transfer::transfer(bill, tx_context::sender(ctx));
    }

    public entry fun request_bill(bill: Bill, intended_address: address, ctx: &mut TxContext) {
        let folder = Folder {
            id: object::new(ctx),
            bill,
            intended_address,
        };

        transfer::transfer(folder, intended_address)
    }

    public entry fun unpack_bill(folder: Folder, ctx: &mut TxContext) {
        assert!(folder.intended_address == tx_context::sender(ctx), EWrongAddress);

        let Folder {
            id,
            bill,
            intended_address: _,
        } = folder;

        transfer::transfer(bill, tx_context::sender(ctx));
        object::delete(id);
    }

    public entry fun delete_bill(_: &OwnerCap, bill: Bill) {
        let Bill { id, price: _, name: _ } = bill;
        object::delete(id);
    }

    public entry fun update_bill_price(_: &OwnerCap, bill: &mut Bill, new_price: u64) {
        bill.price = new_price;
    }

    public entry fun update_bill_name(_: &OwnerCap, bill: &mut Bill, new_name: String) {
        bill.name = new_name;
    }

    public fun view_price(bill: &Bill): u64{
        bill.price
    }

    public fun view_name(bill: &Bill): String{
        bill.name
    }
}
